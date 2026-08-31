#!/usr/bin/env python3
"""Run the common Markdown editor benchmark adapter protocol."""

from __future__ import annotations

import argparse
import json
import math
import os
import platform
import re
import shlex
import shutil
import signal
import subprocess
import sys
import threading
import time
from typing import Any
from pathlib import Path

from macos_display_trace import TraceSession, display_session_locked, unavailable_result

ROOT = Path(__file__).resolve().parents[1]
FIXTURES = {"small": 5 * 1024, "medium": 50 * 1024, "large": 500 * 1024, "stress": 5 * 1024 * 1024}
SCENARIOS = ("open", "input", "scroll")
DEFAULT_ADAPTERS = (
    "moui-skia-raster", "moui-skia-gpu", "moui-wgpu", "gpui", "flutter-skia", "flutter-impeller", "electron"
)


def memory_gb() -> float | None:
    try:
        pages = os.sysconf("SC_PHYS_PAGES")
        size = os.sysconf("SC_PAGE_SIZE")
        return round(pages * size / 1024**3, 2)
    except (AttributeError, OSError, ValueError):
        if sys.platform.startswith("win"):
            try:
                output = subprocess.run(
                    ["powershell", "-NoProfile", "-Command", "(Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory"],
                    text=True,
                    capture_output=True,
                    timeout=10,
                    check=False,
                ).stdout.strip()
                return round(int(output) / 1024**3, 2) if output else None
            except (OSError, ValueError, subprocess.TimeoutExpired):
                return None
        return None


def gpu_model() -> str | None:
    """Return a best-effort GPU label without making hardware a prerequisite."""
    configured = os.environ.get("GPU_MODEL")
    if configured:
        return configured
    if sys.platform == "darwin":
        try:
            output = subprocess.run(
                ["system_profiler", "SPDisplaysDataType"],
                text=True,
                capture_output=True,
                timeout=10,
                check=False,
            ).stdout
            for line in output.splitlines():
                if "Chipset Model:" in line:
                    return line.split(":", 1)[1].strip()
        except (OSError, subprocess.TimeoutExpired):
            pass
    if sys.platform.startswith("win"):
        try:
            output = subprocess.run(
                ["powershell", "-NoProfile", "-Command", "(Get-CimInstance Win32_VideoController | Select-Object -First 1 -ExpandProperty Name)"],
                text=True,
                capture_output=True,
                timeout=10,
                check=False,
            ).stdout.strip()
            if output:
                return output
        except (OSError, subprocess.TimeoutExpired):
            pass
    return None


def toolchain_versions() -> dict[str, str]:
    versions: dict[str, str] = {"python": sys.version.split()[0]}
    for name, command in (
        ("moon", ["moon", "version"]),
        ("rustc", ["rustc", "--version"]),
        ("cargo", ["cargo", "--version"]),
        ("node", ["node", "--version"]),
        ("npm", ["npm", "--version"]),
        ("flutter", ["flutter", "--version"]),
    ):
        try:
            result = subprocess.run(command, text=True, capture_output=True, timeout=10, check=False)
        except (OSError, subprocess.TimeoutExpired):
            continue
        line = next((line.strip() for line in result.stdout.splitlines() if line.strip()), "")
        if result.returncode == 0 and line:
            versions[name] = line
    return versions


def percentile(values: list[float], ratio: float) -> float | None:
    if not values:
        return None
    ordered = sorted(values)
    return ordered[round((len(ordered) - 1) * ratio)]


def validate_nonnegative_number(value: object, field: str) -> None:
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        raise ValueError(f"ui-frame {field} must be a number")
    if not math.isfinite(value) or value < 0:
        raise ValueError(f"ui-frame {field} must be finite and nonnegative")


def validate_sample_list(
    payload: dict, field: str, expected: int, *, allow_null: bool = False
) -> list[float | None]:
    values = payload.get(field)
    if not isinstance(values, list) or len(values) != expected:
        raise ValueError(f"ui-frame {field} must contain {expected} samples")
    for index, value in enumerate(values):
        if value is None and allow_null:
            continue
        validate_nonnegative_number(value, f"{field}[{index}]")
    return values


def validate_count(payload: dict, field: str, expected: int) -> None:
    value = payload.get(field)
    if isinstance(value, bool) or not isinstance(value, int) or value != expected:
        raise ValueError(f"ui-frame {field} must be the integer {expected}")


def validate_system_trace_payload(payload: dict) -> None:
    """Validate optional compositor samples without requiring trace support."""
    for field in (
        "system_present_timestamps_ms",
        "system_present_interval_samples_ms",
        "system_input_to_present_samples_ms",
    ):
        values = payload.get(field, [])
        if not isinstance(values, list):
            raise ValueError(f"ui-frame {field} must be an array")
        for index, value in enumerate(values):
            validate_nonnegative_number(value, f"{field}[{index}]")
    dropped = payload.get("system_dropped_display_frames")
    if dropped is not None and (isinstance(dropped, bool) or not isinstance(dropped, int) or dropped < 0):
        raise ValueError("ui-frame system_dropped_display_frames must be null or a nonnegative integer")
    first = payload.get("system_first_present_ms")
    if first is not None:
        validate_nonnegative_number(first, "system_first_present_ms")
    for field in ("system_frame_budget_ms", "system_refresh_hz"):
        value = payload.get(field)
        if value is not None:
            validate_nonnegative_number(value, field)
    actions = payload.get("action_timestamps_epoch_ms", [])
    if not isinstance(actions, list):
        raise ValueError("ui-frame action_timestamps_epoch_ms must be an array")
    for index, value in enumerate(actions):
        validate_nonnegative_number(value, f"action_timestamps_epoch_ms[{index}]")
    for field in ("action_window_start_epoch_ms", "action_window_end_epoch_ms"):
        value = payload.get(field)
        if value is not None:
            validate_nonnegative_number(value, field)
    start = payload.get("action_window_start_epoch_ms")
    end = payload.get("action_window_end_epoch_ms")
    if start is not None and end is not None and end < start:
        raise ValueError("ui-frame action window end precedes start")
    status = payload.get("system_trace_status")
    if status is not None and status not in {"captured", "unsupported", "no-target-surface", "insufficient-samples", "error"}:
        raise ValueError(f"ui-frame unknown system_trace_status: {status!r}")
    if status == "captured":
        scenario = payload.get("scenario")
        expected_actions = 10 if scenario == "input" else (120 if scenario == "scroll" else 0)
        if scenario in {"open", "input", "scroll"}:
            action_samples = payload.get("system_input_to_present_samples_ms", [])
            if len(action_samples) != expected_actions:
                raise ValueError(
                    f"strict system trace must contain {expected_actions} action-to-present samples, "
                    f"got {len(action_samples)}"
                )


def validate_ui_payload(payload: dict, scenario: str) -> None:
    """Reject malformed UI records before they enter a comparison report."""
    if payload.get("measurement_scope") != "ui-frame":
        return
    expected = 1 if scenario == "open" else (120 if scenario == "scroll" else 10)
    interval_expected = 0 if scenario == "open" else expected
    validate_sample_list(payload, "frame_work_samples_ms", expected)
    validate_sample_list(payload, "frame_interval_samples_ms", interval_expected)
    if scenario == "input":
        validate_sample_list(payload, "input_to_visible_samples_ms", expected)
    elif payload.get("input_to_visible_samples_ms") not in (None, []):
        raise ValueError(f"ui-frame {scenario} must not contain input-to-visible samples")
    # A null sample means the adapter did not instrument that stage. It is
    # deliberately distinct from numeric zero (a measured zero-cost stage).
    offscreen_samples = validate_sample_list(
        payload, "offscreen_samples_ms", expected, allow_null=True
    )
    readback_samples = validate_sample_list(
        payload, "readback_samples_ms", expected, allow_null=True
    )
    offscreen_readback_samples = validate_sample_list(
        payload, "offscreen_readback_samples_ms", expected, allow_null=True
    )
    for field, values in (
        ("offscreen_ms", offscreen_samples),
        ("readback_ms", readback_samples),
        ("offscreen_readback_ms", offscreen_readback_samples),
    ):
        if field not in payload:
            continue
        aggregate = payload.get(field)
        has_numeric = any(value is not None for value in values)
        if has_numeric and aggregate is None:
            raise ValueError(f"ui-frame {field} aggregate is missing for measured samples")
        if not has_numeric and aggregate is not None:
            raise ValueError(f"ui-frame {field} must be null when all samples are unmeasured")
    validate_count(payload, "action_count", expected)
    validate_count(payload, "frame_sample_count", interval_expected)
    expected_warmups = 0 if scenario == "open" else 1
    validate_count(payload, "warmup_action_count", expected_warmups)
    dropped = payload.get("dropped_display_frames")
    if isinstance(dropped, bool) or not isinstance(dropped, int) or dropped < 0:
        raise ValueError(f"ui-frame {scenario} dropped_display_frames must be a nonnegative integer")
    viewport = payload.get("viewport", {})
    if not isinstance(viewport, dict):
        raise ValueError("ui-frame viewport must be an object")
    if viewport.get("width") != 1280 or viewport.get("height") != 800:
        raise ValueError(f"ui-frame viewport must be 1280x800, got {viewport!r}")
    if payload.get("scenario") != scenario:
        raise ValueError(f"ui-frame scenario mismatch: {payload.get('scenario')!r}")
    for field in ("frame_work_ms", "first_interactive_ms", "document_load_ms"):
        validate_nonnegative_number(payload.get(field), field)
    for field in ("offscreen_ms", "readback_ms", "offscreen_readback_ms"):
        value = payload.get(field)
        if value is not None:
            validate_nonnegative_number(value, field)
    if scenario == "open":
        if payload.get("frame_interval_ms") is not None:
            validate_nonnegative_number(payload.get("frame_interval_ms"), "frame_interval_ms")
    else:
        validate_nonnegative_number(payload.get("frame_interval_ms"), "frame_interval_ms")
    if scenario == "input":
        validate_nonnegative_number(payload.get("input_to_visible_ms"), "input_to_visible_ms")
    else:
        if payload.get("input_to_visible_samples_ms") not in (None, []):
            raise ValueError(f"ui-frame {scenario} must not contain input-to-visible samples")
        if payload.get("input_to_visible_ms") is not None:
            raise ValueError(f"ui-frame {scenario} input_to_visible_ms must be null")
    for field in (
        "frame_work_samples_ms", "frame_interval_samples_ms", "input_to_visible_samples_ms",
        "offscreen_samples_ms", "readback_samples_ms", "offscreen_readback_samples_ms",
    ):
        if field not in payload:
            raise ValueError(f"ui-frame payload is missing {field}")


def parse_adapters(values: list[str]) -> dict[str, str]:
    adapters: dict[str, str] = {}
    for value in values:
        if "=" not in value:
            raise ValueError(f"adapter must be NAME=COMMAND: {value}")
        name, command = value.split("=", 1)
        adapters[name] = command
    return adapters


def run_command(
    command: str,
    fixture: Path,
    scenario: str,
    adapter_name: str | None = None,
    timeout_seconds: float = 1800.0,
    *,
    system_trace: bool = False,
    system_trace_dir: Path | None = None,
    system_trace_start_delay_seconds: float = 0.50,
    system_trace_export_timeout_seconds: float = 45.0,
) -> list[dict]:
    """Run one adapter invocation and return a list of measured records.

    Adapters may print more than one JSON object (one per measurement scope, for
    example a comparable `headless-render` row plus a renderer-level
    `richtext-full` row). Each printed object becomes its own record; the
    adapter-emitted `adapter` field is authoritative so a single command can
    back multiple rows.
    """
    tokens = shlex.split(command)
    command_env = os.environ.copy()
    if system_trace:
        # Attached Animation Hitches recordings on Xcode 26 finalize only
        # after the target remains alive through the recorder's time limit.
        # Keep the tail longer than that limit, with extra headroom for the
        # stress fixture's 20-second recording window.
        command_env.setdefault(
            "UI_BENCHMARK_TRACE_TAIL_MS",
            "15000" if fixture.stat().st_size >= FIXTURES["stress"] else "10000",
        )
    assignments: list[str] = []
    # Allow adapter-specific settings without invoking a shell, e.g.
    # `FLUTTER_RENDERER=impeller dart run ...`. Keeping this in the harness
    # makes commands reproducible on macOS, Windows and CI alike.
    assignment = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*=.*$")
    while tokens and assignment.match(tokens[0]):
        assignment_token = tokens.pop(0)
        assignments.append(assignment_token)
        key, value = assignment_token.split("=", 1)
        command_env[key] = value
    rendered = [token.format(fixture=str(fixture), scenario=scenario) for token in tokens]
    if "{fixture}" not in command:
        rendered.append(str(fixture))
    if "{scenario}" not in command:
        rendered.append(scenario)
    displayed_command = assignments + rendered
    started = time.perf_counter()
    process_started_epoch_ms: float | None = None
    trace_gate_released_epoch_ms: float | None = None
    process: subprocess.Popen[str] | None = None
    trace_session: TraceSession | None = None
    trace_additional_pids: list[int] = []
    trace_result = unavailable_result("system trace not requested")
    trace_action_window_start_epoch_ms: float | None = None
    trace_action_window_end_epoch_ms: float | None = None
    trace_action_timestamps_epoch_ms: list[float] = []
    trace_gate: Path | None = None
    trace_gate_directory: Path | None = None
    trace_pid_file: Path | None = None
    trace_start_file: Path | None = None
    trace_target_stdout: Path | None = None
    trace_mirror: Path | None = None
    # Launching the adapter under xctrace gives Instruments ownership of the
    # target lifecycle.  Attached recordings can miss WindowServer surface
    # rows when a short-lived adapter tears down its window before deferred
    # stores flush; launch mode keeps the trace target alive through save.
    launch_trace = (
        system_trace
        and platform.system() == "Darwin"
        and not display_session_locked()
    )
    trace_finished = False
    descendant_stop: threading.Event | None = None
    descendant_thread: threading.Thread | None = None

    def collect_descendants() -> None:
        """Capture Chromium/Flutter helper PIDs while the root is alive."""
        if process is None:
            return
        assert descendant_stop is not None
        while not descendant_stop.wait(0.05):
            try:
                lines = subprocess.check_output(
                    ["ps", "-axo", "pid=,ppid="], text=True, stderr=subprocess.DEVNULL
                ).splitlines()
                parents: dict[int, list[int]] = {}
                for line in lines:
                    fields = line.split()
                    if len(fields) != 2:
                        continue
                    child, parent = (int(fields[0]), int(fields[1]))
                    parents.setdefault(parent, []).append(child)
                pending = [process.pid]
                seen = {process.pid}
                while pending:
                    parent = pending.pop()
                    for child in parents.get(parent, []):
                        if child not in seen:
                            seen.add(child)
                            pending.append(child)
                trace_additional_pids.extend(pid for pid in seen if pid != process.pid)
            except (OSError, ValueError, subprocess.CalledProcessError):
                continue

    def stop_descendant_collection() -> None:
        if descendant_stop is not None:
            descendant_stop.set()
        if descendant_thread is not None:
            descendant_thread.join(timeout=1.0)

    def finish_trace() -> None:
        nonlocal trace_result, trace_finished
        if trace_finished:
            return
        if trace_session is None:
            return
        trace_pid = process.pid if process is not None else None
        if trace_pid is None and trace_pid_file is not None:
            try:
                trace_pid = int(trace_pid_file.read_text(encoding="ascii").strip())
            except (OSError, ValueError):
                trace_pid = None
        if trace_pid is None:
            trace_result = unavailable_result("xctrace launch did not expose target pid")
            trace_finished = True
            return
        if trace_start_file is not None:
            try:
                process_started_epoch_ms = float(
                    trace_start_file.read_text(encoding="ascii").strip()
                )
            except (OSError, ValueError):
                pass
        expected = 1 if scenario == "open" else (120 if scenario == "scroll" else 10)
        trace_result = trace_session.finish(
            # Startup is measured from process creation. The trace gate is
            # only an ordering barrier and must not become the first-present
            # origin, otherwise an already displayed first frame is clamped
            # to zero.
            process_started_epoch_ms=process_started_epoch_ms,
            pid=trace_pid,
            additional_pids=trace_additional_pids,
            action_window_start_epoch_ms=trace_action_window_start_epoch_ms,
            action_window_end_epoch_ms=trace_action_window_end_epoch_ms,
            action_timestamps_epoch_ms=(
                trace_action_timestamps_epoch_ms
                if scenario in {"input", "scroll"}
                else []
            ),
            expected_samples=expected,
        )
        trace_finished = True

    def trace_payload() -> dict:
        return trace_result.as_payload() if system_trace else {}

    def stop_process() -> None:
        if process is None or process.poll() is not None:
            return
        try:
            if os.name == "nt":
                process.terminate()
            else:
                os.killpg(process.pid, signal.SIGTERM)
        except (OSError, ProcessLookupError):
            pass
        try:
            process.communicate(timeout=2)
        except subprocess.TimeoutExpired:
            try:
                if os.name == "nt":
                    process.kill()
                else:
                    os.killpg(process.pid, signal.SIGKILL)
            except (OSError, ProcessLookupError):
                pass
            process.communicate()

    try:
        if system_trace:
            # The adapter wrappers hold the application before creating its
            # native window. This makes attach deterministic and avoids a
            # trace that starts after the first present.
            import tempfile

            gate_root = ROOT / "results" / ".trace-gates"
            gate_root.mkdir(parents=True, exist_ok=True)
            trace_gate_directory = Path(tempfile.mkdtemp(prefix="case-", dir=gate_root))
            trace_gate = trace_gate_directory / "release"
            trace_pid_file = trace_gate_directory / "target.pid"
            trace_start_file = trace_gate_directory / "target.start"
            trace_target_stdout = trace_gate_directory / "target.stdout"
            trace_mirror = trace_gate_directory / "target.mirror"
            trace_target_tmp = trace_gate_directory / "target-tmp"
            trace_target_tmp.mkdir(parents=True, exist_ok=True)
            command_env["UI_BENCHMARK_TRACE_GATE"] = str(trace_gate)
            command_env["UI_BENCHMARK_TRACE_PID_FILE"] = str(trace_pid_file)
            command_env["UI_BENCHMARK_TRACE_START_FILE"] = str(trace_start_file)
            command_env["UI_BENCHMARK_TRACE_MIRROR"] = str(trace_mirror)
            command_env["TMPDIR"] = str(trace_target_tmp.resolve())
            command_env["UI_BENCHMARK_TRACE_GATE_TIMEOUT_SECONDS"] = "120"
            command_env["UI_BENCHMARK_SYSTEM_PRESENT"] = "1"
        process_started_epoch_ms = time.time() * 1000.0
        if launch_trace:
            launch_command = list(rendered)
            if launch_command and not os.path.isabs(launch_command[0]):
                resolved = shutil.which(launch_command[0])
                if resolved is None:
                    raise FileNotFoundError(launch_command[0])
                launch_command[0] = resolved
            output_directory = system_trace_dir or (trace_gate_directory / "traces")
            trace_session = TraceSession(
                None,
                output_directory,
                start_delay_seconds=system_trace_start_delay_seconds,
                export_timeout_seconds=system_trace_export_timeout_seconds,
                save_timeout_seconds=max(180.0, timeout_seconds),
                window_seconds=float(os.environ.get(
                    "UI_BENCHMARK_TRACE_WINDOW_SECONDS",
                    "30.0" if fixture.stat().st_size >= FIXTURES["stress"] else "12.0",
                )),
                record_time_limit_seconds=float(os.environ.get(
                    "UI_BENCHMARK_TRACE_RECORD_SECONDS",
                    "12.0" if fixture.stat().st_size >= FIXTURES["stress"] else "8.0",
                )),
                temp_directory=(ROOT / "results" / ".xctrace-tmp" /
                                f"launch-{time.time_ns()}"),
                keep_trace=system_trace_dir is not None,
                launch_command=launch_command,
                target_stdout_path=trace_target_stdout,
                launch_environment={
                    key: command_env[key]
                    for key in command_env
                    if key.startswith(("UI_BENCHMARK_", "MOUI_", "FLUTTER_", "GPU_"))
                    or key == "TMPDIR"
                },
            )
            trace_session.start(command_env)
            assert trace_gate is not None
            trace_gate_released_epoch_ms = time.time() * 1000.0
            trace_gate.touch()
            if trace_pid_file is not None:
                pid_deadline = time.monotonic() + 15.0
                while time.monotonic() < pid_deadline and not trace_pid_file.exists():
                    time.sleep(0.01)
            if trace_start_file is not None:
                start_deadline = time.monotonic() + 15.0
                while time.monotonic() < start_deadline and not trace_start_file.exists():
                    time.sleep(0.01)
            report_deadline = time.monotonic() + timeout_seconds
            report_idle_deadline = time.monotonic() + 5.0
            while time.monotonic() < report_deadline:
                try:
                    if trace_target_stdout is not None and trace_target_stdout.exists():
                        text = trace_target_stdout.read_text(encoding="utf-8", errors="replace")
                        if '"measurement_scope":"ui-frame"' in text:
                            break
                        pid_text = trace_pid_file.read_text(encoding="ascii").strip() if trace_pid_file and trace_pid_file.exists() else ""
                        target_alive = True
                        if pid_text:
                            try:
                                os.kill(int(pid_text), 0)
                            except (OSError, ValueError):
                                target_alive = False
                        if pid_text and not target_alive and time.monotonic() >= report_idle_deadline:
                            break
                except OSError:
                    pass
                time.sleep(0.05)
            stdout = trace_target_stdout.read_text(encoding="utf-8", errors="replace") if trace_target_stdout is not None and trace_target_stdout.exists() else ""
            stderr = ""
            for line in stdout.splitlines():
                try:
                    candidate = json.loads(line)
                except json.JSONDecodeError:
                    continue
                if not isinstance(candidate, dict):
                    continue
                values = candidate.get("system_trace_process_ids", [])
                if isinstance(values, list):
                    trace_additional_pids.extend(value for value in values if isinstance(value, int) and value > 0)
                if candidate.get("measurement_scope") != "ui-frame":
                    continue
                start = candidate.get("action_window_start_epoch_ms")
                end = candidate.get("action_window_end_epoch_ms")
                actions = candidate.get("action_timestamps_epoch_ms", [])
                if isinstance(start, (int, float)):
                    trace_action_window_start_epoch_ms = float(start)
                if isinstance(end, (int, float)):
                    trace_action_window_end_epoch_ms = float(end)
                if isinstance(actions, list):
                    trace_action_timestamps_epoch_ms = [float(value) for value in actions if isinstance(value, (int, float))]
        else:
            process = subprocess.Popen(
                rendered,
                cwd=ROOT,
                env=command_env,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                start_new_session=os.name != "nt",
            )
            process_started_epoch_ms = time.time() * 1000.0
            if system_trace:
                descendant_stop = threading.Event()
                descendant_thread = threading.Thread(target=collect_descendants, daemon=True)
                descendant_thread.start()
                assert trace_gate_directory is not None
                output_directory = system_trace_dir or (trace_gate_directory / "traces")
                trace_session = TraceSession(
                    process.pid,
                    output_directory,
                    start_delay_seconds=system_trace_start_delay_seconds,
                    export_timeout_seconds=system_trace_export_timeout_seconds,
                    save_timeout_seconds=max(180.0, timeout_seconds),
                    window_seconds=float(os.environ.get(
                        "UI_BENCHMARK_TRACE_WINDOW_SECONDS",
                        "30.0" if fixture.stat().st_size >= FIXTURES["stress"] else "12.0",
                    )),
                    record_time_limit_seconds=float(os.environ.get(
                        "UI_BENCHMARK_TRACE_RECORD_SECONDS",
                        "12.0" if fixture.stat().st_size >= FIXTURES["stress"] else "8.0",
                    )),
                    temp_directory=(ROOT / "results" / ".xctrace-tmp" / f"{process.pid}-{time.time_ns()}"),
                    keep_trace=system_trace_dir is not None,
                )
                trace_session.start(command_env)
                assert trace_gate is not None
                trace_gate_released_epoch_ms = time.time() * 1000.0
                trace_gate.touch()
            stdout, stderr = process.communicate(timeout=timeout_seconds)
        if system_trace:
            for line in stdout.splitlines():
                try:
                    candidate = json.loads(line)
                except json.JSONDecodeError:
                    continue
                if not isinstance(candidate, dict):
                    continue
                values = candidate.get("system_trace_process_ids", [])
                if isinstance(values, list):
                    trace_additional_pids.extend(
                        value for value in values
                        if isinstance(value, int) and not isinstance(value, bool) and value > 0
                    )
                if candidate.get("measurement_scope") != "ui-frame":
                    continue
                start = candidate.get("action_window_start_epoch_ms")
                end = candidate.get("action_window_end_epoch_ms")
                actions = candidate.get("action_timestamps_epoch_ms", [])
                if isinstance(start, (int, float)) and not isinstance(start, bool):
                    trace_action_window_start_epoch_ms = float(start)
                if isinstance(end, (int, float)) and not isinstance(end, bool):
                    trace_action_window_end_epoch_ms = float(end)
                if isinstance(actions, list):
                    trace_action_timestamps_epoch_ms = [
                        float(value) for value in actions
                        if isinstance(value, (int, float)) and not isinstance(value, bool)
                    ]
    except FileNotFoundError as error:
        stop_descendant_collection()
        finish_trace()
        return [{"status": "skipped", "command": displayed_command, "elapsed_ms": 0.0,
                 "reason": f"adapter executable unavailable: {error}", **trace_payload()}]
    except subprocess.TimeoutExpired:
        stop_process()
        stop_descendant_collection()
        finish_trace()
        return [{"status": "error", "command": displayed_command, "elapsed_ms": timeout_seconds * 1000,
                 "error": f"adapter timed out after {timeout_seconds:g} seconds", **trace_payload()}]
    except KeyboardInterrupt:
        stop_process()
        stop_descendant_collection()
        finish_trace()
        raise
    stop_descendant_collection()
    finish_trace()
    elapsed = (time.perf_counter() - started) * 1000
    if process is not None and process.returncode:
        return [{"status": "error", "command": displayed_command, "elapsed_ms": elapsed,
                 "error": stderr[-4000:] or f"exit {process.returncode}", **trace_payload()}]
    records: list[dict] = []
    for line in stdout.splitlines():
        if not line.strip():
            continue
        try:
            payload = json.loads(line)
        except json.JSONDecodeError:
            continue
        if not isinstance(payload, dict):
            continue
        payload.setdefault("status", "measured")
        payload.update({"command": displayed_command, "process_elapsed_ms": elapsed})
        if system_trace and adapter_name in {"flutter-skia", "flutter-impeller"} and payload.get("measurement_scope") == "ui-frame":
            requested_renderer = adapter_name.removeprefix("flutter-")
            marker = (
                "Using the Impeller rendering backend"
                if requested_renderer == "impeller"
                else "Using the Skia rendering backend"
            )
            engine_log = stderr + "\n" + stdout
            if marker not in engine_log:
                payload["status"] = "error"
                payload["error"] = f"Flutter engine log did not confirm the requested {requested_renderer} renderer"
            else:
                payload["verified_renderer"] = requested_renderer
                payload["renderer_verification_source"] = "flutter-engine-startup-log"
        if system_trace and payload.get("measurement_scope") == "ui-frame":
            payload.update(trace_payload())
            # The trace parser's historical field name is retained for
            # compatibility; expose the scenario-neutral name used by the
            # strict comparison report.
            payload["system_action_to_present_samples_ms"] = list(
                payload.get("system_input_to_present_samples_ms") or []
            )
            payload["system_action_to_present_ms"] = (
                sum(payload["system_action_to_present_samples_ms"])
                / len(payload["system_action_to_present_samples_ms"])
                if payload["system_action_to_present_samples_ms"]
                else None
            )
            payload["system_action_to_present_p95_ms"] = (
                sorted(payload["system_action_to_present_samples_ms"])[
                    round((len(payload["system_action_to_present_samples_ms"]) - 1) * 0.95)
                ]
                if payload["system_action_to_present_samples_ms"]
                else None
            )
            if payload.get("system_trace_status") != "captured":
                payload["status"] = "error"
                payload["error"] = (
                    "strict system-present trace did not capture a target surface: "
                    f"{payload.get('system_trace_error') or payload.get('system_trace_status')}"
                )
        payload.setdefault("action_count", 1 if scenario == "open" else (120 if scenario == "scroll" else 10))
        payload.setdefault("frame_sample_count", len(payload.get("frame_interval_samples_ms", payload.get("samples_ms", []))))
        payload.setdefault("warmup_action_count", 0)
        if payload.get("status") == "measured":
            try:
                validate_ui_payload(payload, scenario)
                if system_trace:
                    validate_system_trace_payload(payload)
            except ValueError as error:
                payload["status"] = "error"
                payload["error"] = str(error)
        records.append(payload)
    if not records:
        return [{"status": "error", "command": displayed_command, "elapsed_ms": elapsed,
                 "error": "adapter did not print any JSON object", "stdout": stdout[-4000:], **trace_payload()}]
    if trace_gate_directory is not None:
        shutil.rmtree(trace_gate_directory, ignore_errors=True)
    return records


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--adapter", action="append", default=[], metavar="NAME=COMMAND")
    parser.add_argument("--fixture", action="append", choices=tuple(FIXTURES), dest="fixtures")
    parser.add_argument("--repetitions", type=int, default=3)
    parser.add_argument("--warmups", type=int, default=1)
    parser.add_argument("--fail-on-error", action="store_true")
    parser.add_argument(
        "--system-present-trace",
        action="store_true",
        help="采集 macOS compositor present timestamps（Animation Hitches + Points of Interest）；不回退到框架回调",
    )
    parser.add_argument(
        "--system-trace-dir",
        type=Path,
        help="保留 xctrace 包的目录（默认使用临时目录并在解析后删除）",
    )
    parser.add_argument(
        "--system-trace-start-delay",
        type=float,
        default=0.50,
        help="xctrace attach 后放行 adapter 的等待时间（秒）",
    )
    parser.add_argument(
        "--system-trace-export-timeout",
        type=float,
        default=45.0,
        help="每个 xctrace 表导出的超时时间（秒）",
    )
    parser.add_argument(
        "--system-trace-retries",
        type=int,
        default=3,
        help="xctrace 保存或导出失败时每个 case 的最大尝试次数",
    )
    parser.add_argument("--timeout", type=float, default=float(os.environ.get("BENCHMARK_TIMEOUT_SECONDS", "1800")))
    parser.add_argument("--out", type=Path, default=ROOT / "results" / "benchmark.json")
    args = parser.parse_args()
    subprocess.run([sys.executable, str(ROOT / "scripts" / "generate_fixtures.py")], check=True)
    commands = parse_adapters(args.adapter)
    fixtures = args.fixtures or list(FIXTURES)
    records: list[dict] = []
    for adapter in DEFAULT_ADAPTERS:
        command = commands.get(adapter)
        for fixture_name in fixtures:
            fixture = ROOT / "data" / f"{fixture_name}.md"
            for scenario in SCENARIOS:
                base = {"adapter": adapter, "fixture": fixture_name, "scenario": scenario,
                        "repetitions": args.repetitions, "warmups": args.warmups}
                if command is None:
                    records.append({**base, "status": "skipped", "reason": "no command supplied"})
                    continue
                for _ in range(args.warmups):
                    run_command(command, fixture, scenario, adapter, args.timeout)
                runs = []
                for _ in range(args.repetitions):
                    attempts = max(1, args.system_trace_retries if args.system_present_trace else 1)
                    run = []
                    for attempt in range(attempts):
                        run = run_command(
                            command,
                            fixture,
                            scenario,
                            adapter,
                            args.timeout,
                            system_trace=args.system_present_trace,
                            system_trace_dir=args.system_trace_dir,
                            system_trace_start_delay_seconds=args.system_trace_start_delay,
                            system_trace_export_timeout_seconds=args.system_trace_export_timeout,
                        )
                        comparable = [record for record in run if record.get("measurement_scope") == "ui-frame"]
                        if not args.system_present_trace or (
                            comparable
                            and all(record.get("system_trace_status") == "captured" for record in comparable)
                        ):
                            break
                    for record in run:
                        record["system_trace_attempts"] = attempt + 1
                    runs.append(run)
                for run in runs:
                    for record in run:
                        records.append({**base, **record})
    renderer_env: dict[str, str] = {}
    for key in ("MOUI_SKIA_RENDERER", "FLUTTER_ENGINE_SWITCHES", "GPU_MODEL"):
        if key in os.environ:
            renderer_env[key] = os.environ[key]
    output: dict[str, Any] = {
        "schema": "md-editor-benchmark/v2",
        "generated_at_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "platform": platform.platform(), "os_release": platform.release(), "machine": platform.machine(),
        "cpu": platform.processor() or platform.uname().processor,
        "memory_gb": memory_gb(), "python": sys.version.split()[0],
        "gpu": gpu_model(), "renderer_env": renderer_env, "toolchains": toolchain_versions(),
        "viewport": {
            "width": 1280,
            "height": 800,
            "refresh_hz": None if args.system_present_trace else 60,
            "frame_budget_ms": None if args.system_present_trace else 16.667,
        },
        "gpu_backend": "Metal" if sys.platform == "darwin" else ("Direct3D" if sys.platform.startswith("win") else "unknown"),
        "comparison_mode": "strict-system-present" if args.system_present_trace else "framework-callback-diagnostic",
        "system_present": {
            "requested": args.system_present_trace,
            "source": "macOS xctrace Animation Hitches + Points of Interest displayed-surfaces-interval + display-vsyncs-interval",
            "fallback": "none",
            "trace_directory": str(args.system_trace_dir) if args.system_trace_dir else None,
            "trace_retention": "kept" if args.system_trace_dir else "ephemeral",
        },
        "benchmark_config": {
            "font": "system-ui 16px", "line_height": 1.55, "overscan": 3,
            "virtual_row_height": 66, "virtualization": "fixed-height-window",
        },
        "fixtures": {name: {"bytes": size, "path": str(Path("data") / f"{name}.md")} for name, size in FIXTURES.items()},
        "records": records,
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(output, indent=2) + "\n", encoding="utf-8")
    measured = sum(record.get("status") == "measured" for record in records)
    print(f"wrote {args.out} ({measured} measured records, {len(records) - measured} skipped/error)")
    if args.fail_on_error and measured != len(records):
        raise SystemExit(1)


if __name__ == "__main__":
    main()
