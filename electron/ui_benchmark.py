#!/usr/bin/env python3
"""Invoke the installed Electron runtime in Vditor WYSIWYG benchmark mode."""

from __future__ import annotations

import argparse
import os
import platform
from pathlib import Path

ROOT = Path(__file__).resolve().parent


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
    os.execv(
        str(binary),
        [str(binary), str(ROOT), "--ui-benchmark", str(fixture), args.scenario],
    )


if __name__ == "__main__":
    main()
