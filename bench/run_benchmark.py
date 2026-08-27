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
import subprocess
import sys
import time
from typing import Any
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FIXTURES = {"small": 5 * 1024, "medium": 50 * 1024, "large": 500 * 1024, "stress": 5 * 1024 * 1024}
SCENARIOS = ("open", "input", "scroll")
DEFAULT_ADAPTERS = (
    "moui-skia-raster", "moui-skia-gpu", "gpui", "flutter-skia", "flutter-impeller", "electron"
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


def validate_sample_list(payload: dict, field: str, expected: int) -> list[float]:
    values = payload.get(field)
    if not isinstance(values, list) or len(values) != expected:
        raise ValueError(f"ui-frame {field} must contain {expected} samples")
    for index, value in enumerate(values):
        validate_nonnegative_number(value, f"{field}[{index}]")
    return values


def validate_count(payload: dict, field: str, expected: int) -> None:
    value = payload.get(field)
    if isinstance(value, bool) or not isinstance(value, int) or value != expected:
        raise ValueError(f"ui-frame {field} must be the integer {expected}")


def validate_ui_payload(payload: dict, scenario: str) -> None:
    """Reject malformed UI records before they enter a comparison report."""
    if payload.get("measurement_scope") != "ui-frame":
        return
    expected = 1 if scenario == "open" else (120 if scenario == "scroll" else 10)
    validate_sample_list(payload, "samples_ms", expected)
    validate_count(payload, "action_count", expected)
    validate_count(payload, "frame_sample_count", expected)
    expected_warmups = 0 if scenario == "open" else 1
    validate_count(payload, "warmup_action_count", expected_warmups)
    dropped = payload.get("dropped_frames")
    if isinstance(dropped, bool) or not isinstance(dropped, int) or not 0 <= dropped <= expected:
        raise ValueError(f"ui-frame {scenario} dropped_frames must be an integer in 0..{expected}")
    viewport = payload.get("viewport", {})
    if not isinstance(viewport, dict):
        raise ValueError("ui-frame viewport must be an object")
    if viewport.get("width") != 1280 or viewport.get("height") != 800:
        raise ValueError(f"ui-frame viewport must be 1280x800, got {viewport!r}")
    if payload.get("scenario") != scenario:
        raise ValueError(f"ui-frame scenario mismatch: {payload.get('scenario')!r}")
    for field in ("mean_ms", "p95_ms", "p99_ms", "document_load_ms", "first_interactive_ms"):
        validate_nonnegative_number(payload.get(field), field)
    if scenario == "open":
        validate_nonnegative_number(payload.get("startup_ms"), "startup_ms")
    elif payload.get("startup_ms") is not None:
        raise ValueError(f"ui-frame {scenario} must not contain startup_ms")
    if scenario == "input":
        validate_sample_list(payload, "input_latency_samples_ms", expected)
        validate_nonnegative_number(payload.get("input_latency_ms"), "input_latency_ms")
    else:
        if payload.get("input_latency_samples_ms") not in (None, []):
            raise ValueError(f"ui-frame {scenario} must not contain input latency samples")
        if payload.get("input_latency_ms") is not None:
            raise ValueError(f"ui-frame {scenario} input_latency_ms must be null")
    if payload.get("startup_ms") is not None:
        validate_nonnegative_number(payload["startup_ms"], "startup_ms")


def parse_adapters(values: list[str]) -> dict[str, str]:
    adapters: dict[str, str] = {}
    for value in values:
        if "=" not in value:
            raise ValueError(f"adapter must be NAME=COMMAND: {value}")
        name, command = value.split("=", 1)
        adapters[name] = command
    return adapters


def run_command(command: str, fixture: Path, scenario: str, adapter_name: str | None = None) -> list[dict]:
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
    try:
        process = subprocess.run(rendered, cwd=ROOT, env=command_env, text=True, capture_output=True, timeout=1800)
    except FileNotFoundError as error:
        return [{"status": "skipped", "command": displayed_command, "elapsed_ms": 0.0,
                 "reason": f"adapter executable unavailable: {error}"}]
    except subprocess.TimeoutExpired:
        return [{"status": "error", "command": displayed_command, "elapsed_ms": 1800000.0,
                 "error": "adapter timed out after 1800 seconds"}]
    elapsed = (time.perf_counter() - started) * 1000
    if process.returncode:
        return [{"status": "error", "command": displayed_command, "elapsed_ms": elapsed,
                 "error": process.stderr[-4000:] or f"exit {process.returncode}"}]
    records: list[dict] = []
    for line in process.stdout.splitlines():
        if not line.strip():
            continue
        try:
            payload = json.loads(line)
        except json.JSONDecodeError:
            continue
        payload.setdefault("status", "measured")
        payload.update({"command": displayed_command, "process_elapsed_ms": elapsed})
        payload.setdefault("action_count", 1 if scenario == "open" else (120 if scenario == "scroll" else 10))
        payload.setdefault("frame_sample_count", len(payload.get("samples_ms", [])))
        payload.setdefault("warmup_action_count", 0)
        if scenario == "open":
            payload.setdefault("startup_ms", elapsed)
        if payload.get("status") == "measured":
            try:
                validate_ui_payload(payload, scenario)
            except ValueError as error:
                payload["status"] = "error"
                payload["error"] = str(error)
        records.append(payload)
    if not records:
        return [{"status": "error", "command": displayed_command, "elapsed_ms": elapsed,
                 "error": "adapter did not print any JSON object", "stdout": process.stdout[-4000:]}]
    return records


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--adapter", action="append", default=[], metavar="NAME=COMMAND")
    parser.add_argument("--fixture", action="append", choices=tuple(FIXTURES), dest="fixtures")
    parser.add_argument("--repetitions", type=int, default=3)
    parser.add_argument("--warmups", type=int, default=1)
    parser.add_argument("--fail-on-error", action="store_true")
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
                    run_command(command, fixture, scenario, adapter)
                runs = [run_command(command, fixture, scenario, adapter) for _ in range(args.repetitions)]
                for run in runs:
                    for record in run:
                        records.append({**base, **record})
    renderer_env: dict[str, str] = {}
    for key in ("MOUI_SKIA_RENDERER", "FLUTTER_ENGINE_SWITCHES", "GPU_MODEL"):
        if key in os.environ:
            renderer_env[key] = os.environ[key]
    output: dict[str, Any] = {
        "schema": "md-editor-benchmark/v1",
        "generated_at_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "platform": platform.platform(), "os_release": platform.release(), "machine": platform.machine(),
        "cpu": platform.processor() or platform.uname().processor,
        "memory_gb": memory_gb(), "python": sys.version.split()[0],
        "gpu": gpu_model(), "renderer_env": renderer_env, "toolchains": toolchain_versions(),
        "viewport": {"width": 1280, "height": 800, "refresh_hz": 60, "frame_budget_ms": 16.667},
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
