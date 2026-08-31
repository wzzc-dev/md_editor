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
import signal
import subprocess
import tempfile
import time
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field
from pathlib import Path
from typing import Iterable


TRACE_TEMPLATE = "Animation Hitches"
DEFAULT_START_DELAY_SECONDS = 0.50
DEFAULT_EXPORT_TIMEOUT_SECONDS = 45.0
_NANOSECONDS_PER_MILLISECOND = 1_000_000.0


@dataclass
class DisplayTraceResult:
    """System-presentation samples for one adapter process."""

    status: str
    source: str = "macOS-xctrace-Animation-Hitches"
    trace_path: str | None = None
    present_timestamps_ms: list[float] = field(default_factory=list)
    present_interval_samples_ms: list[float] = field(default_factory=list)
    input_to_present_samples_ms: list[float] = field(default_factory=list)
    dropped_display_frames: int | None = None
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
            "system_first_present_ms": self.first_present_after_process_ms,
            "system_surface_ids": self.surface_ids,
            "system_swap_ids": self.swap_ids,
            "system_trace_started_epoch_ms": self.trace_started_epoch_ms,
        }


@dataclass
class _SurfaceRow:
    timestamp_ns: int
    surface_id: int | None
    swap_id: int | None
    desired_presentation_ns: int | None = None


@dataclass
class _UpdateRow:
    start_ns: int
    swap_id: int | None
    surface_id: int | None
    process_pid: int | None


def supported() -> bool:
    """Whether this host can run the requested system trace."""
    return platform.system() == "Darwin" and _xctrace_path() is not None


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


def _integer(element: ET.Element | None, values_by_id: dict[str, int | None]) -> int | None:
    if element is None:
        return None
    ref = element.attrib.get("ref")
    if ref:
        return values_by_id.get(ref)
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


def _row_values(root: ET.Element) -> dict[str, list[tuple[ET.Element, dict[str, int | None]]]]:
    """Return row elements grouped by schema, with xctrace refs resolved."""
    result: dict[str, list[tuple[ET.Element, dict[str, int | None]]]] = {}
    for node in root.iter():
        if _local_name(node.tag) != "node":
            continue
        schema = next((child for child in node if _local_name(child.tag) == "schema"), None)
        if schema is None:
            continue
        schema_name = schema.attrib.get("name")
        if not schema_name:
            continue
        values_by_id: dict[str, int | None] = {}
        for element in node.iter():
            element_id = element.attrib.get("id")
            if element_id:
                if _local_name(element.tag) == "process":
                    pid = next((desc for desc in element.iter() if _local_name(desc.tag) == "pid"), None)
                    values_by_id[element_id] = _integer(pid, values_by_id)
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


def _parse_rows(root: ET.Element, schema: str) -> list[dict[str, int | None]]:
    grouped = _row_values(root).get(schema, [])
    parsed: list[dict[str, int | None]] = []
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
    }
    for row, values_by_id in grouped:
        item: dict[str, int | None] = {}
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
        if timestamp is None:
            continue
        result.append(
            _SurfaceRow(
                timestamp_ns=timestamp,
                surface_id=row.get("surface-id"),
                swap_id=row.get("swap-id"),
                desired_presentation_ns=row.get("desired-presentation-time"),
            )
        )
    return result


def _target_rows(root: ET.Element, pid: int) -> tuple[set[int], set[int]]:
    """Collect target process swap/surface IDs from trace process tables."""
    swap_ids: set[int] = set()
    surface_ids: set[int] = set()
    for row in _parse_rows(root, "hitches-updates"):
        if row.get("process") == pid:
            if row.get("swap-id") is not None:
                swap_ids.add(row["swap-id"])
            if row.get("surface-id") is not None:
                surface_ids.add(row["surface-id"])
    for row in _parse_rows(root, "metal-command-buffer-frame-assignment"):
        if row.get("pid") == pid and row.get("present-surface-id") is not None:
            surface_ids.add(row["present-surface-id"])
    return swap_ids, surface_ids


def _target_update_rows(root: ET.Element, pid: int) -> list[_UpdateRow]:
    result = []
    for row in _parse_rows(root, "hitches-updates"):
        if row.get("process") != pid or row.get("start") is None:
            continue
        result.append(
            _UpdateRow(
                start_ns=row["start"],
                swap_id=row.get("swap-id"),
                surface_id=row.get("surface-id"),
                process_pid=pid,
            )
        )
    return result


def parse_exported_xml(
    xml_text: str,
    *,
    pid: int,
    process_started_epoch_ms: float | None = None,
    expected_samples: int | None = None,
    refresh_hz: float = 60.0,
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

    swap_ids, surface_ids = _target_rows(root, pid)
    if not swap_ids and not surface_ids:
        return DisplayTraceResult(
            "no-target-surface",
            trace_path=trace_path,
            error=f"xctrace contained no display surface associated with pid {pid}",
        )
    display = _display_rows(root)
    selected = [
        row for row in display
        if (row.swap_id is not None and row.swap_id in swap_ids)
        or (row.surface_id is not None and row.surface_id in surface_ids)
    ]
    # A target's process table can be present without a matching swap table in
    # short traces.  Do not fall back to unrelated system surfaces.
    selected.sort(key=lambda row: row.timestamp_ns)
    required_presents = 1 if expected_samples == 1 else ((expected_samples or 0) + 1)
    if expected_samples is not None and expected_samples > 0:
        # Keep the final action window. Earlier rows are startup/warm-up frames.
        selected = selected[-required_presents:]
    if len(selected) < (required_presents or 1):
        return DisplayTraceResult(
            "insufficient-samples",
            trace_path=trace_path,
            surface_ids=sorted(surface_ids),
            swap_ids=sorted(swap_ids),
            error=f"xctrace yielded {len(selected)} target presents; expected at least {required_presents or 1}",
        )

    trace_start_epoch_ms = _parse_trace_start_epoch_ms(root)
    timestamps_ms = [row.timestamp_ns / _NANOSECONDS_PER_MILLISECOND for row in selected]
    intervals = [timestamps_ms[index] - timestamps_ms[index - 1] for index in range(1, len(timestamps_ms))]
    budget = 1000.0 / max(refresh_hz, 1.0)
    dropped = sum(max(math.ceil(interval / budget) - 1, 0) for interval in intervals)
    first_after_process = None
    if process_started_epoch_ms is not None and trace_start_epoch_ms is not None:
        first_epoch = trace_start_epoch_ms + timestamps_ms[0]
        first_after_process = max(first_epoch - process_started_epoch_ms, 0.0)

    # An update interval is the closest system-level proxy for action-to-present
    # latency. It is emitted only when xctrace associates an update with the
    # target process and the corresponding swap; otherwise the strict report
    # correctly displays input latency as n/a.
    updates = _target_update_rows(root, pid)
    update_latency: list[float] = []
    for update in updates:
        for row in selected:
            if update.swap_id is not None and row.swap_id == update.swap_id:
                update_latency.append(max((row.timestamp_ns - update.start_ns) / _NANOSECONDS_PER_MILLISECOND, 0.0))
                break

    return DisplayTraceResult(
        "captured",
        trace_path=trace_path,
        present_timestamps_ms=timestamps_ms,
        present_interval_samples_ms=intervals,
        input_to_present_samples_ms=update_latency,
        dropped_display_frames=dropped,
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
    # unrelated system samples. These four tables are sufficient for both
    # CPU-window and Metal-window implementations.
    fragments: list[str] = []
    with tempfile.TemporaryDirectory(prefix="md-editor-xctrace-export-") as directory:
        for index, schema in enumerate((
            "display-surface-swap",
            "hitches-updates",
            "metal-command-buffer-frame-assignment",
        )):
            output = Path(directory) / f"{index}.xml"
            completed = subprocess.run(
                [xctrace, "export", "--input", str(trace_path), "--xpath", _xpath_for_schema(schema), "--output", str(output)],
                capture_output=True,
                text=True,
                timeout=timeout_seconds,
                check=False,
            )
            if completed.returncode != 0:
                raise RuntimeError(completed.stderr.strip() or f"xctrace export failed for {schema}")
            if output.exists():
                fragments.append(output.read_text(encoding="utf-8", errors="replace"))
    # Each export is a trace-query-result document. Combine its nodes under a
    # synthetic root; the parser only depends on node/schema/row structure.
    nodes: list[str] = []
    for fragment in fragments:
        try:
            root = ET.fromstring(fragment)
        except ET.ParseError:
            continue
        nodes.extend(ET.tostring(node, encoding="unicode") for node in root if _local_name(node.tag) == "node")
    return "<trace-query-result>" + "".join(nodes) + "</trace-query-result>"


class TraceSession:
    """Lifecycle wrapper for ``xctrace record --attach``."""

    def __init__(
        self,
        pid: int,
        output_directory: Path,
        *,
        start_delay_seconds: float = DEFAULT_START_DELAY_SECONDS,
        export_timeout_seconds: float = DEFAULT_EXPORT_TIMEOUT_SECONDS,
    ) -> None:
        self.pid = pid
        self.output_directory = output_directory
        self.start_delay_seconds = max(start_delay_seconds, 0.0)
        self.export_timeout_seconds = max(export_timeout_seconds, 1.0)
        self.trace_path = output_directory / f"pid-{pid}-{time.time_ns()}.trace"
        self.process: subprocess.Popen[str] | None = None
        self.started_epoch_ms: float | None = None
        self.start_error: str | None = None

    def start(self) -> None:
        xctrace = _xctrace_path()
        if platform.system() != "Darwin" or xctrace is None:
            self.start_error = "macOS xctrace is unavailable"
            return
        self.output_directory.mkdir(parents=True, exist_ok=True)
        self.started_epoch_ms = time.time() * 1000.0
        try:
            self.process = subprocess.Popen(
                [
                    xctrace,
                    "record",
                    "--template",
                    TRACE_TEMPLATE,
                    "--attach",
                    str(self.pid),
                    "--output",
                    str(self.trace_path),
                    "--time-limit",
                    "60s",
                    "--no-prompt",
                ],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                start_new_session=True,
            )
            time.sleep(self.start_delay_seconds)
        except (OSError, subprocess.SubprocessError) as error:
            self.start_error = str(error)

    def finish(
        self,
        *,
        process_started_epoch_ms: float | None,
        pid: int,
        expected_samples: int | None,
        refresh_hz: float,
    ) -> DisplayTraceResult:
        if self.start_error:
            return DisplayTraceResult("unsupported", trace_path=str(self.trace_path), error=self.start_error)
        if self.process is not None and self.process.poll() is None:
            try:
                self.process.send_signal(signal.SIGINT)
                self.process.wait(timeout=20)
            except (OSError, subprocess.TimeoutExpired):
                try:
                    self.process.kill()
                except OSError:
                    pass
        if not self.trace_path.exists():
            return DisplayTraceResult("error", trace_path=str(self.trace_path), error="xctrace did not produce a trace file")
        try:
            exported = _export_tables(self.trace_path, self.export_timeout_seconds)
        except (OSError, RuntimeError, subprocess.TimeoutExpired) as error:
            return DisplayTraceResult("error", trace_path=str(self.trace_path), error=str(error))
        result = parse_exported_xml(
            exported,
            pid=pid,
            process_started_epoch_ms=process_started_epoch_ms,
            expected_samples=expected_samples,
            refresh_hz=refresh_hz,
            trace_path=str(self.trace_path),
        )
        result.trace_started_epoch_ms = self.started_epoch_ms
        if result.present_timestamps_ms and process_started_epoch_ms is not None and self.started_epoch_ms is not None:
            # Table exports intentionally omit the trace TOC. The recording
            # start captured immediately before xctrace is a close enough
            # epoch anchor for startup diagnostics; compositor intervals and
            # dropped-frame counts remain entirely timestamp-derived.
            result.first_present_after_process_ms = max(
                self.started_epoch_ms + result.present_timestamps_ms[0] - process_started_epoch_ms,
                0.0,
            )
        return result


def unavailable_result(reason: str) -> DisplayTraceResult:
    return DisplayTraceResult("unsupported", error=reason)
