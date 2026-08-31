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
import signal
import subprocess
import sys
import time
from typing import Any
from pathlib import Path

from macos_display_trace import TraceSession, unavailable_result

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
    status = payload.get("system_trace_status")
    if status is not None and status not in {"captured", "unsupported", "no-target-surface", "insufficient-samples", "error"}:
        raise ValueError(f"ui-frame unknown system_trace_status: {status!r}")


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
    process: subprocess.Popen[str] | None = None
    trace_session: TraceSession | None = None
    trace_result = unavailable_result("system trace not requested")
    trace_gate: Path | None = None
    trace_gate_directory: Path | None = None

    def finish_trace() -> None:
        nonlocal trace_result
        if trace_session is None or process is None:
            return
        expected = 1 if scenario == "open" else (120 if scenario == "scroll" else 10)
        trace_result = trace_session.finish(
            process_started_epoch_ms=process_started_epoch_ms,
            pid=process.pid,
            expected_samples=expected,
            refresh_hz=60.0,
        )

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

            trace_gate_directory = Path(tempfile.mkdtemp(prefix="md-editor-trace-gate-"))
            trace_gate = trace_gate_directory / "release"
            command_env["UI_BENCHMARK_TRACE_GATE"] = str(trace_gate)
            command_env["UI_BENCHMARK_TRACE_GATE_TIMEOUT_SECONDS"] = "120"
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
            output_directory = system_trace_dir or (ROOT / "results" / "system-traces")
            trace_session = TraceSession(
                process.pid,
                output_directory,
                start_delay_seconds=system_trace_start_delay_seconds,
                export_timeout_seconds=system_trace_export_timeout_seconds,
            )
            trace_session.start()
            # Unsupported hosts still release the gate so the diagnostic run
            # remains usable; their system fields are explicitly n/a.
            assert trace_gate is not None
            trace_gate.touch()
        stdout, stderr = process.communicate(timeout=timeout_seconds)
    except FileNotFoundError as error:
        finish_trace()
        return [{"status": "skipped", "command": displayed_command, "elapsed_ms": 0.0,
                 "reason": f"adapter executable unavailable: {error}", **trace_payload()}]
    except subprocess.TimeoutExpired:
        stop_process()
        finish_trace()
        return [{"status": "error", "command": displayed_command, "elapsed_ms": timeout_seconds * 1000,
                 "error": f"adapter timed out after {timeout_seconds:g} seconds", **trace_payload()}]
    except KeyboardInterrupt:
        stop_process()
        finish_trace()
        raise
    finally:
        # If the adapter exits before communicate returns, xctrace must still
        # be finalized so its trace package is readable by the parser.
        if process is not None and trace_session is not None and trace_session.process is not None:
            pass
    finish_trace()
    elapsed = (time.perf_counter() - started) * 1000
    if process.returncode:
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
        try:
            trace_gate_directory.rmdir()
        except OSError:
            pass
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
        help="采集 macOS Animation Hitches compositor present timestamps; no callback fallback",
    )
    parser.add_argument(
        "--system-trace-dir",
        type=Path,
        help="保留 xctrace 包的目录（默认 results/system-traces）",
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
                runs = [
                    run_command(
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
                    for _ in range(args.repetitions)
                ]
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
        "viewport": {"width": 1280, "height": 800, "refresh_hz": 60, "frame_budget_ms": 16.667},
        "gpu_backend": "Metal" if sys.platform == "darwin" else ("Direct3D" if sys.platform.startswith("win") else "unknown"),
        "comparison_mode": "strict-system-present" if args.system_present_trace else "framework-callback-diagnostic",
        "system_present": {
            "requested": args.system_present_trace,
            "source": "macOS xctrace Animation Hitches display-surface-swap",
            "fallback": "none",
            "trace_directory": str(args.system_trace_dir or (ROOT / "results" / "system-traces")) if args.system_present_trace else None,
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
