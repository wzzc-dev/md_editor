#!/usr/bin/env python3
"""Invoke the built MoonBit/GPUI executable in real-window benchmark mode."""

from __future__ import annotations

import os
import platform
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent
name = "gpui-markdown-editor.exe" if platform.system() == "Windows" else "gpui-markdown-editor"
binary = ROOT / "dist" / name
if not binary.exists():
    raise SystemExit(f"{binary} is missing; run gpui/build.py first")

gate = os.environ.get("UI_BENCHMARK_TRACE_GATE")
pid_file = os.environ.get("UI_BENCHMARK_TRACE_PID_FILE")
if pid_file:
    try:
        Path(pid_file).write_text(str(os.getpid()), encoding="ascii")
    except OSError:
        pass
start_path = os.environ.get("UI_BENCHMARK_TRACE_START_FILE")
if start_path:
    try:
        Path(start_path).write_text(str(time.time() * 1000.0), encoding="ascii")
    except OSError:
        pass
if gate:
    timeout = float(os.environ.get("UI_BENCHMARK_TRACE_GATE_TIMEOUT_SECONDS", "120"))
    deadline = time.monotonic() + max(timeout, 1.0)
    while not os.path.exists(gate) and time.monotonic() < deadline:
        time.sleep(0.01)
    if not os.path.exists(gate):
        raise SystemExit("system trace gate was not released")
# The Windows build links as a GUI-subsystem PE. CRT exec*() does not mark the
# inherited std handles inheritable, so the benchmark report (written by the
# Rust side through GetStdHandle) would vanish through an exec chain when the
# harness captures stdout via a pipe. CreateProcess via subprocess.run passes
# the handles correctly on every platform, at the cost of one extra process.
result = subprocess.run([str(binary), "--ui-benchmark", *sys.argv[1:]], check=False)
raise SystemExit(result.returncode)
