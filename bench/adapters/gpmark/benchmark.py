#!/usr/bin/env python3
"""Invoke the already-built GpMark.mbt (GPUI) headless benchmark without rebuilding."""

from __future__ import annotations

import os
import platform
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
# Windows PE launches require the .exe suffix; keep the extensionless
# macOS/Linux name unchanged.
binary_name = "gpmark-markdown-editor.exe" if platform.system() == "Windows" else "gpmark-markdown-editor"
binary = ROOT / "dist" / binary_name
if not binary.exists():
    raise SystemExit(f"{binary} is missing; run bench/adapters/gpmark/build.py first")
os.execv(str(binary), [str(binary), "--benchmark", *sys.argv[1:]])
