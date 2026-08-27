#!/usr/bin/env python3
"""Invoke the built MoUI benchmark executable without `moon run` overhead."""

from __future__ import annotations

import argparse
import os
import platform
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BINARY = (
    ROOT
    / "_build"
    / "native"
    / "release"
    / "build"
    / "cross_framework"
    / "md_editor_moui"
    / "benchmark"
    / "benchmark.exe"
)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("renderer", choices=("skia-raster", "skia-gpu"))
    parser.add_argument("fixture", type=Path)
    parser.add_argument("scenario", choices=("open", "input", "scroll"))
    args = parser.parse_args()

    if not BINARY.is_file():
        raise SystemExit(
            f"{BINARY} is missing; run "
            "'moon build moui/benchmark --target native --release' first"
        )
    fixture = args.fixture.resolve()
    if not fixture.is_file():
        raise SystemExit(f"fixture is unreadable: {fixture}")

    env = os.environ.copy()
    env["MOUI_SKIA_RENDERER"] = args.renderer
    if args.renderer == "skia-gpu":
        default_route = "direct3d" if platform.system() == "Windows" else "metal"
        env.setdefault("MOUI_GPU_ROUTE", default_route)
    os.execve(
        str(BINARY),
        [str(BINARY), "--ui-benchmark", str(fixture), args.scenario],
        env,
    )


if __name__ == "__main__":
    main()
