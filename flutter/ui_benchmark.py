#!/usr/bin/env python3
"""Run a Flutter Profile UI benchmark and verify the engine renderer log."""

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
APP_NAME = "cross_framework_markdown_flutter"
RENDERER_MARKERS = {
    "skia": "Using the Skia rendering backend",
    "impeller": "Using the Impeller rendering backend",
}


def profile_binary() -> Path:
    system = platform.system()
    if system == "Darwin":
        return (
            ROOT
            / "build"
            / "macos"
            / "Build"
            / "Products"
            / "Profile"
            / f"{APP_NAME}.app"
            / "Contents"
            / "MacOS"
            / APP_NAME
        )
    if system == "Windows":
        return ROOT / "build" / "windows" / "x64" / "runner" / "Profile" / f"{APP_NAME}.exe"
    raise SystemExit("Flutter desktop UI benchmark supports macOS and Windows only")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("renderer", choices=tuple(RENDERER_MARKERS))
    parser.add_argument("fixture", type=Path)
    parser.add_argument("scenario", choices=("open", "input", "scroll"))
    args = parser.parse_args()

    binary = profile_binary()
    if not binary.is_file():
        system = platform.system().lower()
        target = "macos" if system == "darwin" else "windows"
        raise SystemExit(
            f"{binary} is missing; run 'flutter build {target} --profile' in {ROOT}"
        )
    fixture = args.fixture.resolve()
    if not fixture.is_file():
        raise SystemExit(f"fixture is unreadable: {fixture}")

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

    env = os.environ.copy()
    env.update(
        {
            "FLUTTER_ENGINE_SWITCHES": "1",
            "FLUTTER_ENGINE_SWITCH_1": (
                "enable-impeller=true"
                if args.renderer == "impeller"
                else "enable-impeller=false"
            ),
            # The app uses this only for its result label. The wrapper verifies
            # the actual renderer independently from the engine startup log.
            "FLUTTER_RENDERER": args.renderer,
        }
    )
    if gate:
        # Preserve the PID that the runner attached xctrace to. Renderer
        # verification is performed by run_benchmark.py from the same engine
        # startup log in strict mode.
        os.execve(
            str(binary),
            [str(binary), "--ui-benchmark", str(fixture), args.scenario],
            env,
        )
    process: subprocess.CompletedProcess[str] | None = None
    attempt = 0
    for attempt in (1, 2):
        try:
            process = subprocess.run(
                [str(binary), "--ui-benchmark", str(fixture), args.scenario],
                cwd=ROOT,
                env=env,
                text=True,
                capture_output=True,
                timeout=1800,
                check=False,
            )
        except subprocess.TimeoutExpired as error:
            raise SystemExit("Flutter UI benchmark timed out after 1800 seconds") from error
        log = f"{process.stderr}\n{process.stdout}"
        transient_renderer_crash = (
            process.returncode < 0 or "ImpellerValidationBreak" in log
        )
        if process.returncode == 0 or not transient_renderer_crash:
            break

    assert process is not None
    log = f"{process.stderr}\n{process.stdout}"
    marker = RENDERER_MARKERS[args.renderer]
    if process.returncode != 0:
        sys.stderr.write(process.stderr)
        raise SystemExit(f"Flutter UI benchmark exited with {process.returncode}")
    windows_skia = platform.system() == "Windows" and args.renderer == "skia"
    if windows_skia:
        # The Windows engine never logs a Skia backend line; it logs the
        # Impeller backend only when Impeller is active. A clean run is then
        # proven by the absence of that line.
        if RENDERER_MARKERS["impeller"] in log:
            sys.stderr.write(process.stderr)
            raise SystemExit(
                "Flutter engine reported the Impeller backend for a skia run"
            )
    elif marker not in log:
        sys.stderr.write(process.stderr)
        raise SystemExit(
            f"Flutter engine log did not confirm the requested {args.renderer} renderer"
        )

    expected_adapter = f"flutter-{args.renderer}"
    for line in process.stdout.splitlines():
        try:
            payload = json.loads(line)
        except json.JSONDecodeError:
            continue
        if payload.get("measurement_scope") != "ui-frame":
            continue
        if payload.get("adapter") != expected_adapter:
            raise SystemExit(
                f"Flutter payload adapter mismatch: expected {expected_adapter!r}"
            )
        if payload.get("scenario") != args.scenario:
            raise SystemExit("Flutter payload scenario mismatch")
        viewport = payload.get("viewport", {})
        if viewport.get("width") != 1280 or viewport.get("height") != 800:
            raise SystemExit(
                f"Flutter viewport mismatch: {payload.get('viewport')!r}"
            )
        payload["verified_renderer"] = args.renderer
        payload["renderer_verification_source"] = (
            "windows-skia-negative-impeller-marker"
            if windows_skia
            else "flutter-engine-startup-log"
        )
        payload["wrapper_retry_count"] = attempt - 1
        print(json.dumps(payload, separators=(",", ":")))
        return
    sys.stderr.write(process.stderr)
    raise SystemExit("Flutter UI benchmark did not emit a ui-frame JSON payload")


if __name__ == "__main__":
    main()
