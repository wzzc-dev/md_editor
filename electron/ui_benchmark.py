#!/usr/bin/env python3
"""Invoke the installed Electron runtime in Vditor WYSIWYG benchmark mode."""

from __future__ import annotations

import argparse
import os
import platform
import subprocess
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def build_signpost_helper() -> Path | None:
    if platform.system() != "Darwin":
        return None
    helper = ROOT / "signpost-helper"
    source = ROOT / "signpost_helper.c"
    try:
        if not helper.exists() or helper.stat().st_mtime < source.stat().st_mtime:
            subprocess.run(
                ["cc", "-O2", str(source), "-o", str(helper)],
                check=True,
                capture_output=True,
                text=True,
            )
        return helper
    except (OSError, subprocess.CalledProcessError):
        return None


def electron_binary() -> Path:
    if platform.system() == "Darwin":
        return (
            ROOT
            / "node_modules"
            / "electron"
            / "dist"
            / "Electron.app"
            / "Contents"
            / "MacOS"
            / "Electron"
        )
    if platform.system() == "Windows":
        return ROOT / "node_modules" / "electron" / "dist" / "electron.exe"
    return ROOT / "node_modules" / "electron" / "dist" / "electron"


def _wait_for_trace_gate() -> None:
    gate = os.environ.get("UI_BENCHMARK_TRACE_GATE")
    if not gate:
        return
    timeout = float(os.environ.get("UI_BENCHMARK_TRACE_GATE_TIMEOUT_SECONDS", "120"))
    deadline = time.monotonic() + max(timeout, 1.0)
    while not os.path.exists(gate) and time.monotonic() < deadline:
        time.sleep(0.01)
    if not os.path.exists(gate):
        raise SystemExit("system trace gate was not released")


def _write_trace_pid() -> None:
    path = os.environ.get("UI_BENCHMARK_TRACE_PID_FILE")
    if path:
        try:
            Path(path).write_text(str(os.getpid()), encoding="ascii")
        except OSError:
            pass
    start_path = os.environ.get("UI_BENCHMARK_TRACE_START_FILE")
    if start_path:
        try:
            Path(start_path).write_text(str(time.time() * 1000.0), encoding="ascii")
        except OSError:
            pass


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("fixture", type=Path)
    parser.add_argument("scenario", choices=("open", "input", "scroll"))
    args = parser.parse_args()

    binary = electron_binary()
    if not binary.is_file():
        raise SystemExit(f"{binary} is missing; run 'npm ci --prefix {ROOT}' first")
    fixture = args.fixture.resolve()
    if not fixture.is_file():
        raise SystemExit(f"fixture is unreadable: {fixture}")
    _write_trace_pid()
    _wait_for_trace_gate()
    helper = build_signpost_helper()
    if helper is not None:
        os.environ["MD_EDITOR_SIGNPOST_HELPER"] = str(helper)
    os.execv(
        str(binary),
        [str(binary), str(ROOT), "--ui-benchmark", str(fixture), args.scenario],
    )


if __name__ == "__main__":
    main()
