#!/usr/bin/env python3
"""Invoke the already-built GpMark.mbt (GPUI) headless benchmark without rebuilding."""

from __future__ import annotations

import json
import os
import platform
import sys
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
os.execv(str(binary), [str(binary), "--benchmark", *sys.argv[1:]])
