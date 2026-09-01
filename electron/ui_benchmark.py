#!/usr/bin/env python3
"""Invoke the installed Electron runtime in Vditor WYSIWYG benchmark mode."""

from __future__ import annotations

import argparse
import json
import os
import platform
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def build_signpost_helper() -> Path | None:
    if platform.system() != "Darwin":
        return None
    helper = ROOT / "signpost-helper"
    source = ROOT / "signpost_helper.c"
    try:
        if not helper.exists() or helper.stat().st_mtime < source.stat().st_mtime:
            subprocess.run(
                ["cc", "-O2", str(source), "-o", str(helper)],
                check=True,
                capture_output=True,
                text=True,
            )
        return helper
    except (OSError, subprocess.CalledProcessError):
        return None


def electron_binary() -> Path:
    if platform.system() == "Darwin":
        return (
            ROOT
            / "node_modules"
            / "electron"
            / "dist"
            / "Electron.app"
            / "Contents"
            / "MacOS"
            / "Electron"
        )
    if platform.system() == "Windows":
        return ROOT / "node_modules" / "electron" / "dist" / "electron.exe"
    return ROOT / "node_modules" / "electron" / "dist" / "electron"


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
    parser.add_argument("fixture", type=Path)
    parser.add_argument("scenario", choices=("open", "input", "scroll"))
    args = parser.parse_args()

    binary = electron_binary()
    if not binary.is_file():
        raise SystemExit(f"{binary} is missing; run 'npm ci --prefix {ROOT}' first")
    fixture = args.fixture.resolve()
    if not fixture.is_file():
        raise SystemExit(f"fixture is unreadable: {fixture}")
    _write_trace_pid()
    _wait_for_trace_gate()
    helper = build_signpost_helper()
    if helper is not None:
        os.environ["MD_EDITOR_SIGNPOST_HELPER"] = str(helper)
    # Chromium's libuv rejects the pseudo-inherited std handles Python uses
    # for subprocess.PIPE on Windows (the report silently disappears), but a
    # real inherited OS pipe works. The Electron main process writes one JSON
    # line and quits, while long-lived helper processes keep the write end
    # open, so read lines until a ui-frame payload arrives instead of waiting
    # for EOF.
    read_fd, write_fd = os.pipe()
    report_line: str | None = None
    write_fd_closed = False
    try:
        with os.fdopen(read_fd, "r", encoding="utf-8", errors="replace") as stream:
            process = subprocess.Popen(
                [str(binary), str(ROOT), "--ui-benchmark", str(fixture), args.scenario],
                stdout=write_fd,
                stderr=sys.stderr,
            )
            os.close(write_fd)
            write_fd_closed = True
            for line in stream:
                sys.stdout.write(line)
                sys.stdout.flush()
                stripped = line.strip()
                if not stripped.startswith("{"):
                    continue
                try:
                    payload = json.loads(stripped)
                except json.JSONDecodeError:
                    continue
                if payload.get("measurement_scope") == "ui-frame":
                    report_line = stripped
                    break
    finally:
        if not write_fd_closed:
            os.close(write_fd)
    waited = 0.0
    while process.poll() is None and waited < 30.0:
        time.sleep(0.05)
        waited += 0.05
    if process.poll() is None:
        process.terminate()
    returncode = process.wait()
    sys.stdout.flush()
    if report_line is None:
        raise SystemExit(returncode if returncode != 0 else 1)
    raise SystemExit(0)


if __name__ == "__main__":
    main()
