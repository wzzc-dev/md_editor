#!/usr/bin/env python3
"""Build the MoonBit-authored GPUI application and create a runnable bundle."""

from __future__ import annotations

import os
import platform
import shutil
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent
DEFAULT_CARGO_HOME = ROOT.parent / ".tools" / "gpui-cargo-home"


def run(command: list[str], **kwargs) -> subprocess.CompletedProcess[str]:
    print("+", " ".join(command), flush=True)
    return subprocess.run(command, cwd=ROOT, text=True, check=True, **kwargs)


def install_atomic(source: Path, target: Path) -> None:
    """Install a binary without truncating an executable held by an old run.

    macOS keeps the vnode/code-signature state of a running Mach-O alive. An
    in-place ``copy2`` can therefore leave later launches stuck in dyld while
    an older benchmark process still has the destination open. Writing a new
    sibling and replacing the directory entry gives each launch a complete,
    stable inode; existing processes continue to use their old file safely.
    """
    target.parent.mkdir(parents=True, exist_ok=True)
    fd, temporary_name = tempfile.mkstemp(prefix=f".{target.name}.", dir=target.parent)
    os.close(fd)
    temporary = Path(temporary_name)
    try:
        shutil.copy2(source, temporary)
        os.replace(temporary, target)
    except BaseException:
        try:
            temporary.unlink()
        except FileNotFoundError:
            pass
        raise


def bundle_macos(executable: Path) -> Path:
    app = ROOT / "dist" / "GPUI Markdown Editor.app"
    macos = app / "Contents" / "MacOS"
    macos.mkdir(parents=True, exist_ok=True)
    target = macos / "gpui-markdown-editor"
    install_atomic(executable, target)
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
    environment = os.environ.copy()
    environment.setdefault("CARGO_HOME", str(DEFAULT_CARGO_HOME))
    run(
        ["moon", "build", "cmd/main", "--target", "native", "--release"],
        env=environment,
    )
    candidates = list((ROOT / "_build" / "native" / "release" / "build").glob("**/cmd/main/main.exe"))
    candidates += list((ROOT.parent / "_build" / "native" / "release" / "build").glob("**/md_editor_gpui/cmd/main/main.exe"))
    if not candidates:
        raise SystemExit("MoonBit executable not found under _build/native/release/build")
    executable = max(candidates, key=lambda path: path.stat().st_mtime)
    if platform.system() == "Darwin":
        app = bundle_macos(executable)
        install_atomic(executable, ROOT / "dist" / "gpui-markdown-editor")
        print(f"Built {app}\nRun: open '{app}'")
    else:
        dist = ROOT / "dist"
        dist.mkdir(parents=True, exist_ok=True)
        install_atomic(executable, dist / ("gpui-markdown-editor.exe" if platform.system() == "Windows" else "gpui-markdown-editor"))
        print(f"Built {executable}")


if __name__ == "__main__":
    main()
