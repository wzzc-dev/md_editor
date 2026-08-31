#!/usr/bin/env python3
"""Capture and parse macOS compositor display timestamps.

The framework callbacks used by the adapters are useful diagnostics, but they
are not a common presentation boundary.  This module is intentionally small
and dependency-free so the benchmark can use the same source on every native
window implementation: Instruments' ``Animation Hitches`` display tables.

The parser accepts exported xctrace XML rather than scraping the human-facing
Instruments UI.  xctrace exports values in nanoseconds and uses ``ref`` nodes
for repeated values; both details are handled here and covered by the runner's
unit tests.
"""

from __future__ import annotations

import datetime as _datetime
import math
import os
import platform
import re
import shutil
import signal
import subprocess
import tempfile
import time
import xml.etree.ElementTree as ET
from bisect import bisect_left
from collections import Counter
from dataclasses import dataclass, field
from pathlib import Path
from typing import Iterable, Mapping


# Animation Hitches is the macOS template that exports both the compositor
# surface/swap tables and per-refresh scan-out intervals consumed below.
# Metal System Trace does not contain ``displayed-surfaces-interval`` on all
# Xcode 26 devices, so it cannot be the strict presentation source by itself.
TRACE_TEMPLATE = os.environ.get("UI_BENCHMARK_XCTRACE_TEMPLATE", "Animation Hitches")
# Xcode 26.3 can leave an Animation Hitches bundle with only RunIssues when
# the template's implicit POI instrument is not materialized. Add it
# explicitly so custom action markers and the compositor stores are flushed.
TRACE_INSTRUMENT = "Points of Interest"
DEFAULT_START_DELAY_SECONDS = 0.50
DEFAULT_EXPORT_TIMEOUT_SECONDS = 45.0
_NANOSECONDS_PER_MILLISECOND = 1_000_000.0


@dataclass
class DisplayTraceResult:
    """System-presentation samples for one adapter process."""

    status: str
    source: str = field(
        default_factory=lambda: (
            "macOS-xctrace-"
            + TRACE_TEMPLATE.replace(" ", "-")
            + "+PointsOfInterest"
        )
    )
    trace_path: str | None = None
    present_timestamps_ms: list[float] = field(default_factory=list)
    present_interval_samples_ms: list[float] = field(default_factory=list)
    input_to_present_samples_ms: list[float] = field(default_factory=list)
    dropped_display_frames: int | None = None
    frame_budget_ms: float | None = None
    refresh_hz: float | None = None
    present_association: str | None = None
    first_present_after_process_ms: float | None = None
    surface_ids: list[int] = field(default_factory=list)
    swap_ids: list[int] = field(default_factory=list)
    error: str | None = None
    trace_started_epoch_ms: float | None = None

    def as_payload(self) -> dict:
        """Return JSON-safe fields used by ``run_benchmark.py``."""
        return {
            "system_trace_status": self.status,
            "system_trace_source": self.source,
            "system_trace_path": self.trace_path,
            "system_present_timestamps_ms": self.present_timestamps_ms,
            "system_present_interval_samples_ms": self.present_interval_samples_ms,
            "system_input_to_present_samples_ms": self.input_to_present_samples_ms,
            "system_dropped_display_frames": self.dropped_display_frames,
            "system_frame_budget_ms": self.frame_budget_ms,
            "system_refresh_hz": self.refresh_hz,
            "system_present_association": self.present_association,
            "system_first_present_ms": self.first_present_after_process_ms,
            "system_surface_ids": self.surface_ids,
            "system_swap_ids": self.swap_ids,
            "system_trace_started_epoch_ms": self.trace_started_epoch_ms,
            "system_trace_error": self.error,
        }


@dataclass
class _SurfaceRow:
    timestamp_ns: int
    surface_id: int | None
    swap_id: int | None
    desired_presentation_ns: int | None = None
    display_name: str | None = None


@dataclass
class _VSyncRow:
    timestamp_ns: int
    display_name: str | None


@dataclass
class _UpdateRow:
    start_ns: int
    swap_id: int | None
    surface_id: int | None
    process_pid: int | None
    display_name: str | None


@dataclass
class _SignpostRow:
    timestamp_ns: int
    process_pid: int | None
    name: str | None
    message: str | None


def supported() -> bool:
    """Whether this host can run the requested system trace."""
    return platform.system() == "Darwin" and _xctrace_path() is not None


def display_session_locked() -> bool:
    """Return whether the active macOS console session is at the lock screen.

    WindowServer does not scan out application surfaces while the session is
    locked. Detecting that state before starting Instruments avoids producing a
    seemingly valid trace containing only unrelated system surfaces.
    """
    if platform.system() != "Darwin":
        return False
    try:
        result = subprocess.run(
            ["ioreg", "-n", "Root", "-d", "1", "-l", "-w0"],
            capture_output=True,
            text=True,
            timeout=3,
            check=False,
        )
    except (OSError, subprocess.SubprocessError):
        return False
    return '"CGSSessionScreenIsLocked"=Yes' in result.stdout


def _xctrace_path() -> str | None:
    path = "/usr/bin/xctrace"
    if os.path.isfile(path) and os.access(path, os.X_OK):
        return path
    for directory in os.environ.get("PATH", "").split(os.pathsep):
        candidate = Path(directory) / "xctrace"
        if candidate.is_file() and os.access(candidate, os.X_OK):
            return str(candidate)
    return None


def _local_name(tag: str) -> str:
    return tag.rsplit("}", 1)[-1]


_XmlValue = int | str | None


def _integer(element: ET.Element | None, values_by_id: dict[str, _XmlValue]) -> int | None:
    if element is None:
        return None
    ref = element.attrib.get("ref")
    if ref:
        value = values_by_id.get(ref)
        return value if isinstance(value, int) and not isinstance(value, bool) else None
    text = (element.text or "").strip().replace(",", "")
    if text:
        try:
            return int(text, 0)
        except ValueError:
            try:
                return int(float(text))
            except ValueError:
                pass
    fmt = element.attrib.get("fmt", "")
    match = re.search(r"(?:0x)?[0-9a-fA-F]+", fmt.replace(",", ""))
    if match:
        token = match.group(0)
        try:
            return int(token, 0 if token.lower().startswith("0x") else 10)
        except ValueError:
            return None
    return None


def _string(element: ET.Element | None, values_by_id: dict[str, _XmlValue]) -> str | None:
    if element is None:
        return None
    ref = element.attrib.get("ref")
    if ref:
        value = values_by_id.get(ref)
        return value if isinstance(value, str) else None
    value = element.attrib.get("fmt") or (element.text or "").strip()
    return value or None


def _row_values(root: ET.Element) -> dict[str, list[tuple[ET.Element, dict[str, _XmlValue]]]]:
    """Return row elements grouped by schema, with xctrace refs resolved."""
    # Union XPath exports use one reference namespace across all selected
    # tables. A ref in displayed-surfaces-interval may therefore point to a
    # value declared in the surface-swap node. Build that namespace once;
    # individual exports still work because their IDs are a subset of it.
    global_values: dict[str, _XmlValue] = {}
    for element in root.iter():
        element_id = element.attrib.get("id")
        if not element_id:
            continue
        tag = _local_name(element.tag)
        if tag == "process":
            pid = next((desc for desc in element.iter() if _local_name(desc.tag) == "pid"), None)
            global_values[element_id] = _integer(pid, global_values)
        elif tag in {"display-name", "string", "signpost-name", "format-string", "category", "subsystem", "os-log-metadata"}:
            global_values[element_id] = _string(element, global_values)
        elif "ref" not in element.attrib:
            global_values[element_id] = _integer(element, global_values)
    result: dict[str, list[tuple[ET.Element, dict[str, _XmlValue]]]] = {}
    for node in root.iter():
        if _local_name(node.tag) != "node":
            continue
        schema = next((child for child in node if _local_name(child.tag) == "schema"), None)
        if schema is None:
            continue
        schema_name = schema.attrib.get("name")
        if not schema_name:
            continue
        values_by_id: dict[str, _XmlValue] = dict(global_values)
        for element in node.iter():
            element_id = element.attrib.get("id")
            if element_id:
                if _local_name(element.tag) == "process":
                    pid = next((desc for desc in element.iter() if _local_name(desc.tag) == "pid"), None)
                    values_by_id[element_id] = _integer(pid, values_by_id)
                elif _local_name(element.tag) in {"display-name", "string", "signpost-name", "format-string", "category", "subsystem", "os-log-metadata"}:
                    values_by_id[element_id] = _string(element, values_by_id)
                else:
                    values_by_id[element_id] = _integer(element, values_by_id)
        rows = [(row, values_by_id) for row in node if _local_name(row.tag) == "row"]
        result.setdefault(schema_name, []).extend(rows)
    return result


def _child(row: ET.Element, mnemonic: str) -> ET.Element | None:
    for child in row:
        if _local_name(child.tag) == mnemonic:
            return child
    return None


def _parse_rows(root: ET.Element, schema: str) -> list[dict[str, _XmlValue]]:
    grouped = _row_values(root).get(schema, [])
    parsed: list[dict[str, _XmlValue]] = []
    schema_element = next(
        (element for element in root.iter()
         if _local_name(element.tag) == "schema" and element.attrib.get("name") == schema),
        None,
    )
    mnemonics = []
    if schema_element is not None:
        for column in schema_element:
            if _local_name(column.tag) != "col":
                continue
            mnemonic = next((child for child in column if _local_name(child.tag) == "mnemonic"), None)
            mnemonics.append((mnemonic.text or "").strip() if mnemonic is not None else "")
    relevant = {
        "start", "timestamp", "duration", "delay", "surface-id", "swap-id",
        "desired-presentation-time", "present-surface-id", "pid", "process",
        "display", "display-name", "time", "name", "format-string", "message",
        "subsystem", "category", "event-type",
    }
    for row, values_by_id in grouped:
        item: dict[str, _XmlValue] = {}
        # Exported element tags describe engineering types rather than the
        # column mnemonic (both surface-id and swap-id are
        # ``displayed-surface-swap``). Use schema/row position to distinguish
        # them and resolve refs through the global id map.
        for index, child in enumerate(row):
            key = mnemonics[index] if index < len(mnemonics) else ""
            if key in relevant:
                # In the exported XML a process is a nested object whose
                # ``fmt`` is human text (and may contain unrelated hex
                # characters). Always use its explicit child pid.
                if key == "process":
                    reference = child.attrib.get("ref")
                    if reference:
                        value = values_by_id.get(reference)
                    else:
                        pid = next((desc for desc in child.iter() if _local_name(desc.tag) == "pid"), None)
                        value = _integer(pid, values_by_id)
                elif key in {"display", "display-name", "name", "format-string", "message", "subsystem", "category"}:
                    value = _string(child, values_by_id)
                else:
                    value = _integer(child, values_by_id)
                item[key] = value
        parsed.append(item)
    return parsed


def _parse_trace_start_epoch_ms(root: ET.Element) -> float | None:
    for element in root.iter():
        if _local_name(element.tag) != "start-date":
            continue
        text = (element.text or "").strip()
        if not text:
            continue
        try:
            value = _datetime.datetime.fromisoformat(text)
            return value.timestamp() * 1000.0
        except ValueError:
            return None
    return None


def _display_rows(root: ET.Element) -> list[_SurfaceRow]:
    rows = _parse_rows(root, "display-surface-swap")
    result = []
    for row in rows:
        timestamp = row.get("timestamp")
        if not isinstance(timestamp, int):
            continue
        result.append(
            _SurfaceRow(
                timestamp_ns=timestamp,
                surface_id=row.get("surface-id") if isinstance(row.get("surface-id"), int) else None,
                swap_id=row.get("swap-id") if isinstance(row.get("swap-id"), int) else None,
                desired_presentation_ns=(
                    row.get("desired-presentation-time")
                    if isinstance(row.get("desired-presentation-time"), int)
                    else None
                ),
                display_name=row.get("display-name") if isinstance(row.get("display-name"), str) else None,
            )
        )
    return result


def _displayed_surface_rows(root: ET.Element) -> list[_SurfaceRow]:
    """Read the per-refresh surface actually selected for scan-out."""
    rows = _parse_rows(root, "displayed-surfaces-interval")
    result: list[_SurfaceRow] = []
    for row in rows:
        timestamp = row.get("start")
        if not isinstance(timestamp, int):
            continue
        surface_id = row.get("surface-id")
        result.append(
            _SurfaceRow(
                timestamp_ns=timestamp,
                surface_id=surface_id if isinstance(surface_id, int) else None,
                swap_id=None,
                display_name=(
                    row.get("display-name")
                    if isinstance(row.get("display-name"), str)
                    else None
                ),
            )
        )
    return result


def _vsync_rows(root: ET.Element) -> list[_VSyncRow]:
    result: list[_VSyncRow] = []
    for row in _parse_rows(root, "display-vsyncs-interval"):
        timestamp = row.get("timestamp")
        if not isinstance(timestamp, int):
            continue
        result.append(
            _VSyncRow(
                timestamp_ns=timestamp,
                display_name=row.get("display-name") if isinstance(row.get("display-name"), str) else None,
            )
        )
    return result


def _signpost_rows(root: ET.Element, pids: set[int]) -> list[_SignpostRow]:
    result: list[_SignpostRow] = []
    for row in _parse_rows(root, "os-signpost"):
        timestamp = row.get("time")
        process_pid = row.get("process")
        if not isinstance(timestamp, int) or (process_pid is not None and process_pid not in pids):
            continue
        result.append(
            _SignpostRow(
                timestamp_ns=timestamp,
                process_pid=process_pid if isinstance(process_pid, int) else None,
                name=row.get("name") if isinstance(row.get("name"), str) else None,
                message=row.get("message") if isinstance(row.get("message"), str) else None,
            )
        )
    return result


def _log_rows(root: ET.Element, pids: set[int]) -> list[_SignpostRow]:
    """Read PointsOfInterest os-log markers from the same trace clock.

    macOS 26's Animation Hitches template records the custom os-log event but
    may omit the corresponding ``os-signpost`` row. The marker is intentionally
    emitted through both APIs; treating the os-log event as the primary source
    keeps input latency strict without falling back to a framework clock.
    """
    result: list[_SignpostRow] = []
    for row in _parse_rows(root, "os-log"):
        timestamp = row.get("time")
        process_pid = row.get("process")
        if not isinstance(timestamp, int) or (process_pid is not None and process_pid not in pids):
            continue
        message = row.get("message") if isinstance(row.get("message"), str) else None
        format_string = row.get("format-string") if isinstance(row.get("format-string"), str) else None
        result.append(
            _SignpostRow(
                timestamp_ns=timestamp,
                process_pid=process_pid if isinstance(process_pid, int) else None,
                name=None,
                message=message or format_string,
            )
        )
    return result


def _action_signpost_rows(root: ET.Element, pids: set[int]) -> list[_SignpostRow]:
    rows = _signpost_rows(root, pids)
    return [
        row for row in rows
        if row.name == "md_editor_action"
        or (row.message is not None and "md_editor_action" in row.message)
    ]


def _action_marker_rows(root: ET.Element, pids: set[int], expected: int) -> list[_SignpostRow]:
    """Choose one system-clock action stream, preferring signposts if present."""
    signposts = sorted(_action_signpost_rows(root, pids), key=lambda row: row.timestamp_ns)
    if len(signposts) >= expected:
        return signposts
    logs = sorted(
        [row for row in _log_rows(root, pids)
         if row.message is not None and "md_editor_action" in row.message],
        key=lambda row: row.timestamp_ns,
    )
    return logs if len(logs) >= expected else signposts


def _median(values: list[float]) -> float | None:
    if not values:
        return None
    ordered = sorted(values)
    middle = len(ordered) // 2
    if len(ordered) % 2:
        return ordered[middle]
    return (ordered[middle - 1] + ordered[middle]) / 2.0


def _frame_budget_ms(vsync_rows: list[_VSyncRow], selected: list[_SurfaceRow]) -> float | None:
    """Derive the display period from trace VSyncs, never a configured Hz.

    Instruments may expose more than one label for one physical display. We
    first deduplicate equal timestamps per label, then choose the candidate
    period that best quantizes the target present intervals. This also avoids
    treating duplicated VSync rows as a zero-millisecond refresh period.
    """
    grouped: dict[str, set[int]] = {}
    for row in vsync_rows:
        grouped.setdefault(row.display_name or "", set()).add(row.timestamp_ns)
    candidates: list[float] = []
    for timestamps in grouped.values():
        ordered = sorted(timestamps)
        intervals = [
            (ordered[index] - ordered[index - 1]) / _NANOSECONDS_PER_MILLISECOND
            for index in range(1, len(ordered))
            if ordered[index] > ordered[index - 1]
        ]
        # Trace gaps are not refresh periods. The lower half retains the
        # repeated VSync cadence while discarding pauses caused by trace loss.
        if intervals:
            lower_half = sorted(intervals)[: max(1, (len(intervals) + 1) // 2)]
            candidate = _median(lower_half)
            if candidate is not None and candidate >= 1.0:
                candidates.append(candidate)
    if not candidates:
        return None
    target_intervals = [
        (selected[index].timestamp_ns - selected[index - 1].timestamp_ns)
        / _NANOSECONDS_PER_MILLISECOND
        for index in range(1, len(selected))
        if selected[index].timestamp_ns > selected[index - 1].timestamp_ns
    ]
    if not target_intervals:
        return min(candidates)

    def quantization_error(candidate: float) -> float:
        errors = [
            abs(interval / candidate - max(round(interval / candidate), 1))
            for interval in target_intervals
        ]
        return _median(errors) or 0.0

    return min(candidates, key=lambda candidate: (quantization_error(candidate), candidate))


def _target_rows(root: ET.Element, pids: set[int]) -> tuple[set[int], set[int]]:
    """Collect target process swap/surface IDs from trace process tables."""
    swap_ids: set[int] = set()
    surface_ids: set[int] = set()
    for row in _parse_rows(root, "hitches-updates"):
        if row.get("process") in pids:
            if row.get("swap-id") is not None:
                swap_ids.add(row["swap-id"])
            if row.get("surface-id") is not None:
                surface_ids.add(row["surface-id"])
    for row in _parse_rows(root, "metal-command-buffer-frame-assignment"):
        if row.get("pid") in pids and row.get("present-surface-id") is not None:
            surface_ids.add(row["present-surface-id"])
    return swap_ids, surface_ids


def _target_update_rows(root: ET.Element, pids: set[int]) -> list[_UpdateRow]:
    result = []
    for row in _parse_rows(root, "hitches-updates"):
        process_pid = row.get("process")
        if process_pid not in pids or row.get("start") is None:
            continue
        result.append(
            _UpdateRow(
                start_ns=row["start"],
                swap_id=row.get("swap-id"),
                surface_id=row.get("surface-id"),
                process_pid=process_pid,
                display_name=row.get("display") if isinstance(row.get("display"), str) else None,
            )
        )
    return result


def _relative_trace_ns(epoch_ms: float, trace_start_epoch_ms: float) -> int:
    return round((epoch_ms - trace_start_epoch_ms) * _NANOSECONDS_PER_MILLISECOND)


def _target_display_rows(
    display_rows: list[_SurfaceRow], target_swap_ids: set[int]
) -> tuple[str | None, list[_SurfaceRow]]:
    """Resolve the physical display using process-associated swap IDs."""
    associated = [
        row for row in display_rows
        if row.swap_id is not None and row.swap_id in target_swap_ids
    ]
    names = Counter(row.display_name for row in associated if row.display_name)
    if not names:
        # Older xctrace exports omit the display-name column. In that format
        # the target surface association is still auditable, but the physical
        # display identity is unavailable; callers keep the row set and mark
        # the weaker association in the result.
        return None, associated
    # A window can move between displays. The benchmark pins one 1280x800
    # window, so use the physical display carrying most target swaps and keep
    # the chosen name in the audit payload.
    display_name = names.most_common(1)[0][0]
    return display_name, [row for row in associated if row.display_name == display_name]


def _target_surface_rows(
    display_rows: list[_SurfaceRow], target_surface_ids: set[int]
) -> list[_SurfaceRow]:
    """Resolve target presents when the trace exposes surface IDs but no swaps."""
    return [
        row for row in display_rows
        if row.surface_id is not None and row.surface_id in target_surface_ids
    ]


def _dropped_slots(interval_ms: float, budget_ms: float) -> int:
    """Count missed refresh slots while tolerating timestamp quantization jitter."""
    if budget_ms <= 0.0:
        return 0
    slots = max(1, int(math.floor(interval_ms / budget_ms + 0.5)))
    return max(slots - 1, 0)


def _match_action_presents(
    action_timestamps_epoch_ms: list[float],
    target_present_rows: list[_SurfaceRow],
    trace_start_epoch_ms: float,
) -> list[float]:
    """Match each action to the next distinct process-associated present."""
    available = sorted(target_present_rows, key=lambda row: row.timestamp_ns)
    result: list[float] = []
    present_ns = [row.timestamp_ns for row in available]
    for action_epoch_ms in action_timestamps_epoch_ms:
        action_ns = _relative_trace_ns(action_epoch_ms, trace_start_epoch_ms)
        present_index = bisect_left(present_ns, action_ns)
        if present_index >= len(available):
            return []
        latency = (available[present_index].timestamp_ns - action_ns) / _NANOSECONDS_PER_MILLISECOND
        result.append(latency)
    return result


def parse_exported_xml(
    xml_text: str,
    *,
    pid: int,
    additional_pids: Iterable[int] = (),
    process_started_epoch_ms: float | None = None,
    action_window_start_epoch_ms: float | None = None,
    action_window_end_epoch_ms: float | None = None,
    action_timestamps_epoch_ms: Iterable[float] = (),
    expected_samples: int | None = None,
    trace_path: str | None = None,
) -> DisplayTraceResult:
    """Parse one xctrace export and associate samples with ``pid``.

    ``display-surface-swap`` is system compositor data.  It is never accepted
    without a process/surface association: mixing another application's
    display swaps would make a seemingly precise result invalid.
    """
    try:
        root = ET.fromstring(xml_text)
    except ET.ParseError as error:
        return DisplayTraceResult("error", trace_path=trace_path, error=f"invalid xctrace XML: {error}")

    target_pids = {pid, *(value for value in additional_pids if isinstance(value, int) and value > 0)}
    swap_ids, surface_ids = _target_rows(root, target_pids)
    target_surfaces = {value for value in surface_ids if value > 0}
    if not swap_ids and not target_surfaces:
        return DisplayTraceResult(
            "no-target-surface",
            trace_path=trace_path,
            error=f"xctrace contained no compositor swap associated with pids {sorted(target_pids)}",
        )
    display = _display_rows(root)
    displayed = _displayed_surface_rows(root)
    target_display_name, target_present_rows = _target_display_rows(display, swap_ids)
    if not target_present_rows and target_surfaces:
        target_present_rows = _target_surface_rows(display, target_surfaces)
    if not target_present_rows:
        return DisplayTraceResult(
            "no-target-surface",
            trace_path=trace_path,
            surface_ids=sorted(surface_ids),
            swap_ids=sorted(swap_ids),
            error="target process swaps could not be associated with a physical display",
        )
    target_present_rows.sort(key=lambda row: row.timestamp_ns)
    trace_start_epoch_ms = _parse_trace_start_epoch_ms(root)

    if expected_samples is not None and expected_samples > 1:
        if (
            trace_start_epoch_ms is None
            or action_window_start_epoch_ms is None
            or action_window_end_epoch_ms is None
            or action_window_end_epoch_ms <= action_window_start_epoch_ms
        ):
            return DisplayTraceResult(
                "insufficient-samples",
                trace_path=trace_path,
                surface_ids=sorted(surface_ids),
                swap_ids=sorted(swap_ids),
                error="adapter did not provide a valid action window for compositor sampling",
            )
        start_ns = _relative_trace_ns(action_window_start_epoch_ms, trace_start_epoch_ms)
        end_ns = _relative_trace_ns(action_window_end_epoch_ms, trace_start_epoch_ms)
        # `displayed-surfaces-interval` is the compositor's per-refresh
        # scan-out stream. The swap table above only identifies the target
        # surface and cannot be used as a frame clock.
        if not displayed:
            return DisplayTraceResult(
                "insufficient-samples",
                trace_path=trace_path,
                surface_ids=sorted(surface_ids),
                swap_ids=sorted(swap_ids),
                error="xctrace did not export displayed-surfaces-interval scan-out samples",
            )
        displayed_names = Counter(
            row.display_name for row in displayed
            if row.surface_id in target_surfaces and row.display_name
        )
        scanout_display_name = displayed_names.most_common(1)[0][0] if displayed_names else None
        selected = [
            row for row in displayed
            if (scanout_display_name is None or row.display_name == scanout_display_name)
            and (not target_surfaces or row.surface_id in target_surfaces)
            and start_ns <= row.timestamp_ns <= end_ns
        ]
        # When the recorder target is an inert process (used to avoid
        # xctrace's launch/exit race), displayed-surfaces-interval is filtered
        # to that inert target. The global display-surface-swap stream is still
        # compositor data and is already associated with the benchmark PID via
        # hitches-updates swap IDs, so use it as the strict fallback.
        if not selected:
            selected = [
                row for row in target_present_rows
                if start_ns <= row.timestamp_ns <= end_ns
            ]
    else:
        # Open has no action interval. Strict runner calls use the first
        # compositor scan-out selected for the target surface; diagnostic
        # parser calls without expected_samples preserve all associated swap
        # rows for backwards-compatible inspection.
        if expected_samples is None:
            selected = target_present_rows
        else:
            selected = []
            if displayed:
                displayed_names = Counter(
                    row.display_name for row in displayed
                    if row.surface_id in target_surfaces and row.display_name
                )
                scanout_display_name = displayed_names.most_common(1)[0][0] if displayed_names else None
                first_target_swap_ns = target_present_rows[0].timestamp_ns
                selected = [
                    row for row in displayed
                    if (scanout_display_name is None or row.display_name == scanout_display_name)
                    and (not target_surfaces or row.surface_id in target_surfaces)
                    and row.timestamp_ns >= first_target_swap_ns
                ][:1]
        if expected_samples is not None and not selected:
            return DisplayTraceResult(
                "insufficient-samples",
                trace_path=trace_path,
                surface_ids=sorted(surface_ids),
                swap_ids=sorted(swap_ids),
                error="xctrace did not export a target-surface scan-out for open",
            )
    selected.sort(key=lambda row: row.timestamp_ns)
    budget = _frame_budget_ms(_vsync_rows(root), selected)
    # The action count is not the display frame count: a burst of actions can
    # legitimately coalesce onto fewer refreshes. Require one present per
    # action only when strict action-to-present matching is requested; do not
    # infer a minimum from wall-clock window length, which would reject a
    # valid compositor stream when the adapter paces actions faster than the
    # display or when trace export omits idle refresh rows.
    minimum_presents = 1 if expected_samples == 1 else 2
    if len(selected) < minimum_presents:
        return DisplayTraceResult(
            "insufficient-samples",
            trace_path=trace_path,
            surface_ids=sorted(surface_ids),
            swap_ids=sorted(swap_ids),
            error=(
                f"xctrace yielded {len(selected)} compositor scan-outs in the action window; "
                f"expected at least {minimum_presents}"
            ),
        )

    timestamps_ms = [row.timestamp_ns / _NANOSECONDS_PER_MILLISECOND for row in selected]
    intervals = [timestamps_ms[index] - timestamps_ms[index - 1] for index in range(1, len(timestamps_ms))]
    dropped = (
        sum(_dropped_slots(interval, budget) for interval in intervals)
        if budget is not None
        else None
    )
    first_after_process = None
    if process_started_epoch_ms is not None and trace_start_epoch_ms is not None:
        first_epoch = trace_start_epoch_ms + timestamps_ms[0]
        first_after_process = max(first_epoch - process_started_epoch_ms, 0.0)

    # Adapter wall-clock action markers delimit the trace window only. The
    # latency endpoint is the explicit md_editor_action os_signpost, which is
    # recorded by xctrace in the same system clock as compositor presents.
    update_latency: list[float] = []
    if action_timestamps_epoch_ms and trace_start_epoch_ms is not None:
        # Prefer the explicit signpost emitted by the adapter. Its timestamp
        # and the compositor scan-out are in the same xctrace clock; the
        # wall-clock action markers are used only for window cropping.
        markers = _action_marker_rows(root, target_pids, len(action_timestamps_epoch_ms))
        # The action window ends immediately after the last dispatch. Include
        # a short compositor tail so the last action can be paired with the
        # next scan-out even when it lands just after the wall-clock marker.
        latency_present_rows = selected
        if expected_samples is not None and expected_samples > 1 and displayed:
            tail_ns = int(max((budget or 16.667) * 4.0, 100.0) * _NANOSECONDS_PER_MILLISECOND)
            displayed_latency_rows = [
                row for row in displayed
                if (scanout_display_name is None or row.display_name == scanout_display_name)
                and (not target_surfaces or row.surface_id in target_surfaces)
                and row.timestamp_ns >= start_ns
                and row.timestamp_ns <= end_ns + tail_ns
            ]
            if displayed_latency_rows:
                latency_present_rows = displayed_latency_rows
            # A final action can be issued after the last exported
            # displayed-surfaces row when the window stops invalidating just
            # before the recorder's time limit. The process-associated swap
            # stream still contains that compositor presentation; include it
            # as an endpoint sample (while retaining displayed-surfaces as
            # the frame-clock source for intervals and drops).
            swap_latency_rows = [
                row for row in target_present_rows
                if start_ns <= row.timestamp_ns <= end_ns + tail_ns
            ]
            if swap_latency_rows:
                merged = {row.timestamp_ns: row for row in latency_present_rows}
                merged.update({row.timestamp_ns: row for row in swap_latency_rows})
                latency_present_rows = sorted(merged.values(), key=lambda row: row.timestamp_ns)
        present_ns = [row.timestamp_ns for row in latency_present_rows]
        if len(markers) >= len(action_timestamps_epoch_ms):
            # Each action is paired independently with the first present at
            # or after its marker. Multiple actions can legitimately share a
            # refresh slot when input/scroll dispatch outruns the display;
            # consuming a present globally would incorrectly reject that
            # coalescing as missing samples.
            matched: list[float] = []
            for marker in markers[: len(action_timestamps_epoch_ms)]:
                present_index = bisect_left(present_ns, marker.timestamp_ns)
                if present_index >= len(present_ns):
                    break
                matched.append(
                    (present_ns[present_index] - marker.timestamp_ns)
                    / _NANOSECONDS_PER_MILLISECOND
                )
            if len(matched) == len(action_timestamps_epoch_ms):
                update_latency = matched

    return DisplayTraceResult(
        "captured",
        trace_path=trace_path,
        present_timestamps_ms=timestamps_ms,
        present_interval_samples_ms=intervals,
        input_to_present_samples_ms=update_latency,
        dropped_display_frames=dropped,
        frame_budget_ms=budget,
        refresh_hz=(1000.0 / budget if budget is not None else None),
        present_association=(
            "target-process-swap-id-to-surface-id;"
            "action-window-displayed-surfaces-interval"
        ),
        first_present_after_process_ms=first_after_process,
        surface_ids=sorted(surface_ids),
        swap_ids=sorted(swap_ids),
        trace_started_epoch_ms=trace_start_epoch_ms,
    )


def _xpath_for_schema(schema: str) -> str:
    return f'/trace-toc/run[@number="1"]/data/table[@schema="{schema}"]'


def _export_tables(trace_path: Path, timeout_seconds: float) -> str:
    """Export only the small set of tables needed for target association."""
    xctrace = _xctrace_path()
    if xctrace is None:
        raise FileNotFoundError("xctrace is unavailable")
    # A single XPath export of all tables can spend minutes materializing
    # unrelated system samples. These compositor, signpost and association
    # tables are sufficient for CPU-window and Metal-window implementations.
    fragments: list[str] = []
    trace_start_date: str | None = None
    with tempfile.TemporaryDirectory(prefix="md-editor-xctrace-export-") as directory:
        toc_output = Path(directory) / "toc.xml"
        toc = subprocess.run(
            [xctrace, "export", "--input", str(trace_path), "--toc", "--output", str(toc_output)],
            capture_output=True,
            text=True,
            timeout=timeout_seconds,
            check=False,
        )
        if toc.returncode != 0:
            raise RuntimeError(toc.stderr.strip() or "xctrace TOC export failed")
        if toc_output.exists():
            try:
                toc_root = ET.parse(toc_output).getroot()
                start = next((item for item in toc_root.iter() if _local_name(item.tag) == "start-date"), None)
                trace_start_date = (start.text or "").strip() if start is not None else None
            except ET.ParseError:
                trace_start_date = None
        # Avoid the expensive full Metal command-buffer table. The hitches
        # update stream already associates target processes with surfaces.
        schemas = (
            "display-surface-swap",
            "displayed-surfaces-interval",
            "display-vsyncs-interval",
            "hitches-updates",
            "os-signpost",
            "os-log",
        )
        union = " | ".join(
            f'/trace-toc/run[@number="1"]/data/table[@schema="{schema}"]'
            for schema in schemas
        )
        output = Path(directory) / "tables.xml"
        completed = subprocess.run(
            [xctrace, "export", "--input", str(trace_path), "--xpath", f"({union})", "--output", str(output)],
            capture_output=True,
            text=True,
            timeout=max(timeout_seconds * 2.0, 10.0),
            check=False,
        )
        if completed.returncode != 0:
            raise RuntimeError(completed.stderr.strip() or "xctrace export failed for compositor tables")
        if output.exists():
            fragments.append(output.read_text(encoding="utf-8", errors="replace"))
    # One union export is a single trace-query-result document. Keep all its
    # nodes under a synthetic root; the parser only depends on node/schema/row.
    nodes: list[str] = []
    for fragment in fragments:
        try:
            root = ET.fromstring(fragment)
        except ET.ParseError:
            continue
        for node in root:
            if _local_name(node.tag) != "node":
                continue
            # xctrace's union XPath export includes the rows but drops the
            # schema element on every node after the first. Recover the
            # schema from stable row mnemonics before handing the XML to the
            # normal parser.
            if next((child for child in node if _local_name(child.tag) == "schema"), None) is None:
                rows = [child for child in node if _local_name(child.tag) == "row"]
                tags = {
                    _local_name(child.tag)
                    for row in rows[:2]
                    for child in row
                }
                inferred = None
                if "displayed-surface-swap" in tags:
                    inferred = "display-surface-swap"
                elif "process" in tags and "duration" in tags:
                    inferred = "hitches-updates"
                elif "vsync-event" in tags:
                    inferred = "display-vsyncs-interval"
                elif "display-event-name" in tags:
                    inferred = "displayed-surfaces-interval"
                elif "format-string" in tags and "message-type" in tags:
                    inferred = "os-log"
                elif "signpost-name" in tags and "event-time" in tags:
                    inferred = "os-signpost"
                elif "gpu-driver-surface" in tags and "process" in tags:
                    inferred = "metal-command-buffer-frame-assignment"
                if inferred is not None:
                    schema = ET.Element("schema", {"name": inferred})
                    # The parser uses schema column mnemonics to decode rows;
                    # derive those from the table's engineering tags in the
                    # same order as the row children.
                    columns = {
                        "display-surface-swap": [
                            "timestamp", "delay", "display-name", "surface-id",
                            "framebuffer-index", "swap-id", "color", "pixel-format",
                            "hid-time", "generation-time", "min-quanta",
                            "desired-presentation-time", "layer1-surface-id",
                            "layer2-surface-id", "layer1-pixel-format", "layer2-pixel-format",
                        ],
                        "hitches-updates": [
                            "start", "duration", "process", "display", "swap-id",
                            "surface-id", "frame-color", "containment-level", "label",
                        ],
                        "display-vsyncs-interval": [
                            "timestamp", "duration", "display-name", "color", "event-label", "event",
                        ],
                        "displayed-surfaces-interval": [
                            "start", "duration", "cpu-to-display-latency", "display-name",
                            "connection-UUID", "surface-id", "pixel-format", "color",
                            "event-priority", "event-label", "category", "event-depth",
                            "direct-to-display", "detachment-reason", "detachment-suggestion",
                        ],
                        "os-log": [
                            "time", "thread", "process", "message-type", "format-string",
                            "backtrace", "subsystem", "category", "message", "emit-location",
                        ],
                        "os-signpost": [
                            "time", "thread", "process", "event-type", "scope",
                            "identifier", "name", "format-string", "backtrace",
                            "subsystem", "category", "message", "emit-location",
                        ],
                        "metal-command-buffer-frame-assignment": [
                            "timestamp", "cmdbuffer-id", "commit-time", "commit-id",
                            "frame-number", "frame-color", "cmdbuffer-index", "has-present",
                            "is-compositor", "type-name", "present-surface-id",
                            "compositor-cmdbuffer-id", "xr-frame", "pid", "process",
                        ],
                    }.get(inferred, [])
                    for index, child in enumerate(rows[0] if rows else []):
                        col = ET.SubElement(schema, "col")
                        mnemonic = ET.SubElement(col, "mnemonic")
                        mnemonic.text = columns[index] if index < len(columns) else _local_name(child.tag)
                    node.insert(0, schema)
            nodes.append(ET.tostring(node, encoding="unicode"))
    start_xml = ""
    if trace_start_date:
        start_xml = f"<start-date>{trace_start_date}</start-date>"
    return "<trace-query-result>" + start_xml + "".join(nodes) + "</trace-query-result>"


class TraceSession:
    """Lifecycle wrapper for ``xctrace record --attach``."""

    def __init__(
        self,
        pid: int | None,
        output_directory: Path,
        *,
        start_delay_seconds: float = DEFAULT_START_DELAY_SECONDS,
        export_timeout_seconds: float = DEFAULT_EXPORT_TIMEOUT_SECONDS,
        record_time_limit_seconds: float = 12.0,
        save_timeout_seconds: float = 180.0,
        window_seconds: float | None = None,
        temp_directory: Path | None = None,
        keep_trace: bool = False,
        launch_command: list[str] | None = None,
        target_stdout_path: Path | None = None,
        launch_environment: Mapping[str, str] | None = None,
    ) -> None:
        self.pid = pid
        self.output_directory = output_directory
        self.start_delay_seconds = max(start_delay_seconds, 0.0)
        self.export_timeout_seconds = max(export_timeout_seconds, 1.0)
        # xctrace 26 can produce an invalid bundle when interrupted with
        # SIGINT/SIGTERM immediately after an attached app exits. A natural
        # time limit lets Instruments finalize its stores reliably.
        self.record_time_limit_seconds = max(record_time_limit_seconds, 2.0)
        # Saving deferred Animation Hitches stores can take substantially
        # longer than the recording window (especially when WindowServer has
        # many surfaces). Do not terminate xctrace while it is materializing
        # the trace bundle.
        self.save_timeout_seconds = max(save_timeout_seconds, 30.0)
        self.window_seconds = window_seconds if window_seconds is None else max(window_seconds, 1.0)
        self.temp_directory = temp_directory
        self.keep_trace = keep_trace
        self.launch_command = launch_command
        self.target_stdout_path = target_stdout_path
        self.launch_environment = dict(launch_environment or {})
        self.trace_path = output_directory / f"pid-{pid or 'launch'}-{time.time_ns()}.trace"
        self.process: subprocess.Popen[str] | None = None
        self.log_path = self.output_directory / f"pid-{pid or 'launch'}-{time.time_ns()}.xctrace.log"
        self.started_epoch_ms: float | None = None
        self.start_error: str | None = None

    def start(self, environment: Mapping[str, str] | None = None) -> None:
        xctrace = _xctrace_path()
        if platform.system() != "Darwin" or xctrace is None:
            self.start_error = "macOS xctrace is unavailable"
            return
        if display_session_locked():
            self.start_error = (
                "macOS display session is locked; unlock the console before "
                "running strict system-present benchmarks"
            )
            return
        self.output_directory.mkdir(parents=True, exist_ok=True)
        if self.temp_directory is not None:
            self.temp_directory.mkdir(parents=True, exist_ok=True)
        self.started_epoch_ms = time.time() * 1000.0
        try:
            environment = dict(environment or os.environ)
            if self.temp_directory is not None:
                # Trace stores can be multiple gigabytes on large windows;
                # keep Instruments' working files on the data volume rather
                # than the small system-volume /var/folders filesystem.
                environment["TMPDIR"] = str(self.temp_directory.resolve())
            log = self.log_path.open("w", encoding="utf-8")
            command = [
                    xctrace,
                    "record",
                    "--template",
                    TRACE_TEMPLATE,
                    "--instrument",
                    TRACE_INSTRUMENT,
                    "--output",
                    str(self.trace_path),
                    # Let Instruments finalize the bundle at its natural
                    # limit. The runner chooses a longer limit for stress
                    # cases; interrupting the recorder produces a corrupt
                    # ``RunIssues``-only bundle on current Xcode releases.
                    "--time-limit",
                    f"{self.record_time_limit_seconds:g}s",
                    "--no-prompt",
            ]
            if self.window_seconds is not None:
                command.extend(["--window", f"{self.window_seconds:g}s"])
            if self.launch_command is None:
                command.extend(["--attach", str(self.pid)])
            else:
                for key, value in self.launch_environment.items():
                    command.extend(["--env", f"{key}={value}"])
                if self.target_stdout_path is not None:
                    command.extend(["--target-stdout", str(self.target_stdout_path)])
                command.extend(["--launch", "--", *self.launch_command])
            self.process = subprocess.Popen(
                command,
                stdout=log,
                stderr=subprocess.STDOUT,
                text=True,
                start_new_session=True,
                env=environment,
            )
            # xctrace startup is not instantaneous. Its status stream is
            # redirected to a file because a PIPE can make the recorder emit
            # malformed bundles on macOS 26 when the target exits quickly.
            # Release the adapter only after the recording-confirmation line
            # is durable, with a bounded fallback for older Xcode versions
            # that buffer the line.
            deadline = time.monotonic() + max(self.start_delay_seconds + 10.0, 10.0)
            while time.monotonic() < deadline and self.process.poll() is None:
                try:
                    if "Ctrl-C to stop the recording" in self.log_path.read_text(encoding="utf-8", errors="replace"):
                        break
                except OSError:
                    pass
                time.sleep(0.10)
            if self.process.poll() is None:
                time.sleep(self.start_delay_seconds)
        except (OSError, subprocess.SubprocessError) as error:
            self.start_error = str(error)

    def finish(
        self,
        *,
        process_started_epoch_ms: float | None,
        pid: int,
        additional_pids: Iterable[int],
        action_window_start_epoch_ms: float | None,
        action_window_end_epoch_ms: float | None,
        action_timestamps_epoch_ms: Iterable[float],
        expected_samples: int | None,
    ) -> DisplayTraceResult:
        if self.start_error:
            return DisplayTraceResult("unsupported", trace_path=str(self.trace_path), error=self.start_error)
        recorder_error = ""
        if self.process is not None and self.process.poll() is None:
            try:
                # Wait for the configured natural limit. This is deliberately
                # longer than the action window so the final compositor
                # presents and signposts are included in the bundle.
                _, recorder_error = self.process.communicate(
                    timeout=self.record_time_limit_seconds + self.save_timeout_seconds
                )
            except subprocess.TimeoutExpired:
                # A recorder that ignores its own time limit is exceptional;
                # terminate it only as a last resort and report the bundle as
                # invalid if it cannot finish promptly.
                try:
                    self.process.terminate()
                except OSError:
                    pass
                try:
                    _, recorder_error = self.process.communicate(timeout=10)
                except subprocess.TimeoutExpired:
                    try:
                        self.process.kill()
                    except OSError:
                        pass
                    return DisplayTraceResult(
                        "error",
                        trace_path=str(self.trace_path),
                        error="xctrace did not finish recording and saving within the configured save timeout",
                    )
        elif self.process is not None:
            _, recorder_error = self.process.communicate()
        # The output directory can appear before Instruments has finalized its
        # stores. Treat the explicit save confirmation as part of the record
        # contract; exporting a RunIssues-only bundle produces misleading
        # "missing template" errors later.
        try:
            recorder_log = self.log_path.read_text(encoding="utf-8", errors="replace")
        except OSError:
            recorder_log = ""
        if "Output file saved as:" not in recorder_log:
            if self.temp_directory is not None:
                shutil.rmtree(self.temp_directory, ignore_errors=True)
            if not self.keep_trace:
                shutil.rmtree(self.trace_path, ignore_errors=True)
            return DisplayTraceResult(
                "error",
                trace_path=str(self.trace_path),
                error="xctrace did not confirm output file save",
            )
        if not self.trace_path.exists():
            return DisplayTraceResult(
                "error",
                trace_path=str(self.trace_path),
                error=(recorder_error or "").strip() or "xctrace did not produce a trace file",
            )
        try:
            try:
                exported = _export_tables(self.trace_path, self.export_timeout_seconds)
            except (OSError, RuntimeError, subprocess.TimeoutExpired) as error:
                return DisplayTraceResult("error", trace_path=str(self.trace_path), error=str(error))
            result = parse_exported_xml(
                exported,
                pid=pid,
                additional_pids=additional_pids,
                process_started_epoch_ms=process_started_epoch_ms,
                action_window_start_epoch_ms=action_window_start_epoch_ms,
                action_window_end_epoch_ms=action_window_end_epoch_ms,
                action_timestamps_epoch_ms=action_timestamps_epoch_ms,
                expected_samples=expected_samples,
                trace_path=str(self.trace_path),
            )
        finally:
            # xctrace leaves its large intermediate ktrace files behind even
            # after a successful natural-limit save. They are not part of the
            # audit bundle and must be removed between cases.
            if self.temp_directory is not None:
                shutil.rmtree(self.temp_directory, ignore_errors=True)
        if result.trace_started_epoch_ms is None:
            result.trace_started_epoch_ms = self.started_epoch_ms
        if not self.keep_trace:
            shutil.rmtree(self.trace_path, ignore_errors=True)
            result.trace_path = None
        return result


def unavailable_result(reason: str) -> DisplayTraceResult:
    return DisplayTraceResult("unsupported", error=reason)
