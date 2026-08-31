#!/usr/bin/env python3
"""Invoke the built MoonBit/GPUI executable in real-window benchmark mode."""

from __future__ import annotations

import os
import platform
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent
name = "gpui-markdown-editor.exe" if platform.system() == "Windows" else "gpui-markdown-editor"
binary = ROOT / "dist" / name
if not binary.exists():
    raise SystemExit(f"{binary} is missing; run gpui/build.py first")

gate = os.environ.get("UI_BENCHMARK_TRACE_GATE")
if gate:
    timeout = float(os.environ.get("UI_BENCHMARK_TRACE_GATE_TIMEOUT_SECONDS", "120"))
    deadline = time.monotonic() + max(timeout, 1.0)
    while not os.path.exists(gate) and time.monotonic() < deadline:
        time.sleep(0.01)
    if not os.path.exists(gate):
        raise SystemExit("system trace gate was not released")
os.execv(str(binary), [str(binary), "--ui-benchmark", *sys.argv[1:]])
