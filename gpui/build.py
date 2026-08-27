#!/usr/bin/env python3
"""Build the Rust GPUI staticlib and link the MoonBit native executable."""

from __future__ import annotations

import json
import platform
import re
import shutil
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent
MANIFEST = ROOT / "cmd" / "main" / "moon.pkg"


def run(command: list[str], **kwargs) -> subprocess.CompletedProcess[str]:
    print("+", " ".join(command), flush=True)
    return subprocess.run(command, cwd=ROOT, text=True, check=True, **kwargs)


def rust_staticlib() -> tuple[Path, str]:
    process = run(
        ["cargo", "rustc", "--release", "--manifest-path", "Cargo.toml", "--", "--print", "native-static-libs"],
        capture_output=True,
    )
    output = process.stdout + process.stderr
    matches = re.findall(r"native-static-libs:\s*(.+)", output)
    if not matches:
        raise SystemExit("cargo did not report native-static-libs")
    system = platform.system()
    if system == "Windows":
        library = ROOT / "target" / "release" / "cross_framework_markdown_gpui.lib"
    else:
        library = ROOT / "target" / "release" / "libcross_framework_markdown_gpui.a"
    if not library.exists():
        raise SystemExit(f"Rust static library not found: {library}")
    flags = matches[-1].strip()
    if system == "Darwin":
        flags = " ".join(flag for flag in flags.split() if flag not in {"-lc", "-lm"})
    elif system == "Linux":
        flags = " ".join(flag for flag in flags.split() if flag != "-lc")
    return library, flags


def linked_manifest(library: Path, native_flags: str) -> str:
    link_flags = f'"{library.as_posix()}" {native_flags}'
    return """import {
  "cross_framework/md_editor_gpui/app" @app,
  "moonbitlang/core/encoding/utf8",
  "moonbitlang/core/env",
  "moonbitlang/x/fs",
}

options(
  "is-main": true,
  link: { "native": { "cc-link-flags": %s } },
)
""" % json.dumps(link_flags)


def bundle_macos(executable: Path) -> Path:
    app = ROOT / "dist" / "GPUI Markdown Editor.app"
    macos = app / "Contents" / "MacOS"
    macos.mkdir(parents=True, exist_ok=True)
    target = macos / "gpui-markdown-editor"
    shutil.copy2(executable, target)
    (app / "Contents" / "Info.plist").write_text(
        """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>gpui-markdown-editor</string>
<key>CFBundleIdentifier</key><string>dev.moonbit.gpui-markdown-editor</string>
<key>CFBundleName</key><string>GPUI Markdown Editor</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>NSHighResolutionCapable</key><true/>
</dict></plist>
""",
        encoding="utf-8",
    )
    return app


def main() -> None:
    library, native_flags = rust_staticlib()
    original = MANIFEST.read_text(encoding="utf-8")
    try:
        MANIFEST.write_text(linked_manifest(library, native_flags), encoding="utf-8")
        run(["moon", "build", "cmd/main", "--target", "native", "--release"])
    finally:
        MANIFEST.write_text(original, encoding="utf-8")
    candidates = list((ROOT.parent / "_build" / "native" / "release" / "build").glob("**/md_editor_gpui/cmd/main/main.exe"))
    candidates += list((ROOT / "_build" / "native" / "release" / "build").glob("**/cmd/main/main.exe"))
    if not candidates:
        raise SystemExit("MoonBit executable not found under _build/native/release/build")
    executable = candidates[0]
    if platform.system() == "Darwin":
        app = bundle_macos(executable)
        shutil.copy2(executable, ROOT / "dist" / "gpui-markdown-editor")
        print(f"Built {app}\nRun: open '{app}'")
    else:
        dist = ROOT / "dist"
        dist.mkdir(parents=True, exist_ok=True)
        shutil.copy2(executable, dist / ("gpui-markdown-editor.exe" if platform.system() == "Windows" else "gpui-markdown-editor"))
        print(f"Built {executable}")


if __name__ == "__main__":
    main()
