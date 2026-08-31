#!/usr/bin/env python3
"""Invoke the built MoUI benchmark executable without `moon run` overhead."""

from __future__ import annotations

import argparse
import os
import platform
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
# Workspace builds (`moon.work`) drop the module-name prefix from the build
# path; single-module builds keep it. Prefer whichever binary is newest.
_BINARY_CANDIDATES = (
    ROOT / "_build" / "native" / "release" / "build" / "benchmark" / "benchmark.exe",
    ROOT
    / "_build"
    / "native"
    / "release"
    / "build"
    / "cross_framework"
    / "md_editor_moui"
    / "benchmark"
    / "benchmark.exe",
)


def _benchmark_binary() -> Path | None:
    candidates = [path for path in _BINARY_CANDIDATES if path.is_file()]
    if not candidates:
        return None
    return max(candidates, key=lambda path: path.stat().st_mtime)


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
    parser.add_argument("renderer", choices=("skia-raster", "skia-gpu", "wgpu"))
    parser.add_argument("fixture", type=Path)
    parser.add_argument("scenario", choices=("open", "input", "scroll"))
    args = parser.parse_args()

    binary = _benchmark_binary()
    if binary is None:
        raise SystemExit(
            "benchmark executable is missing; run "
            "'moon build moui/benchmark --target native --release' first"
        )
    fixture = args.fixture.resolve()
    if not fixture.is_file():
        raise SystemExit(f"fixture is unreadable: {fixture}")

    _write_trace_pid()
    _wait_for_trace_gate()
    env = os.environ.copy()
    env["MOUI_SKIA_RENDERER"] = args.renderer
    if args.renderer == "skia-gpu":
        default_route = "direct3d" if platform.system() == "Windows" else "metal"
        env.setdefault("MOUI_GPU_ROUTE", default_route)
    os.execve(
        str(binary),
        [str(binary), "--ui-benchmark", str(fixture), args.scenario],
        env,
    )


if __name__ == "__main__":
    main()
