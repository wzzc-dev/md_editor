#!/usr/bin/env python3
"""Invoke the built GpMark.mbt/GPUI executable in real-window benchmark mode.

Same ui-frame protocol and trace-gate handoff as the other adapters; the Rust
report row is named explicitly through UI_BENCHMARK_ADAPTER_NAME so it lives
under "gpmark".
"""

from __future__ import annotations

import json
import os
import platform
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent
binary = ROOT / "dist" / "gpmark-markdown-editor"
if platform.system() != "Darwin":
    # GpMark.mbt is only validated on macOS arm64; report the same `skipped`
    # protocol the harness uses for unavailable tools instead of an error.
    print(json.dumps({
        "adapter": "gpmark",
        "status": "skipped",
        "reason": "GpMark.mbt (GPUI) is verified on macOS arm64 only",
    }))
    raise SystemExit(0)
if not binary.exists():
    raise SystemExit(f"{binary} is missing; run bench/adapters/gpmark/build.py first")

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
# GPUI's AppKit loop does not unwind on quit, so the report is flushed from
# Rust before the process terminates.
environment = os.environ.copy()
environment["UI_BENCHMARK_ADAPTER_NAME"] = "gpmark"
result = subprocess.run([str(binary), "--ui-benchmark", *sys.argv[1:]], check=False, env=environment)
raise SystemExit(result.returncode)
