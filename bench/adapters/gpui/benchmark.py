#!/usr/bin/env python3
"""Invoke the already-built gpui (md_mbt) headless benchmark without rebuilding."""

from __future__ import annotations

import json
import os
import platform
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
binary = ROOT / "dist" / "gpui-markdown-editor"
if platform.system() != "Darwin":
    # md_mbt is only validated on macOS arm64; report the same `skipped`
    # protocol the harness uses for unavailable tools instead of an error.
    print(json.dumps({
        "adapter": "gpui",
        "status": "skipped",
        "reason": "gpui (md_mbt) is verified on macOS arm64 only",
    }))
    raise SystemExit(0)
if not binary.exists():
    raise SystemExit(f"{binary} is missing; run bench/adapters/gpui/build.py first")
os.execv(str(binary), [str(binary), "--benchmark", *sys.argv[1:]])
