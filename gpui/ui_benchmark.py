#!/usr/bin/env python3
"""Invoke the built MoonBit/GPUI executable in real-window benchmark mode."""

from __future__ import annotations

import os
import platform
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
name = "gpui-markdown-editor.exe" if platform.system() == "Windows" else "gpui-markdown-editor"
binary = ROOT / "dist" / name
if not binary.exists():
    raise SystemExit(f"{binary} is missing; run gpui/build.py first")
os.execv(str(binary), [str(binary), "--ui-benchmark", *sys.argv[1:]])
