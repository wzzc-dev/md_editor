#!/usr/bin/env python3
"""Invoke the already-built gpui2 (md_mbt) headless benchmark without rebuilding."""

from __future__ import annotations

import json
import os
import platform
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
binary = ROOT / "dist" / "gpui2-markdown-editor"
if platform.system() != "Darwin":
    print(json.dumps({
        "adapter": "gpui2",
        "status": "skipped",
        "reason": "gpui2 (md_mbt) is verified on macOS arm64 only",
    }))
    raise SystemExit(0)
if not binary.exists():
    raise SystemExit(f"{binary} is missing; run gpui2/build.py first")
os.execv(str(binary), [str(binary), "--benchmark", *sys.argv[1:]])
