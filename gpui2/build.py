#!/usr/bin/env python3
"""Build the md_mbt-based GPUI2 application and install its benchmark binary.

gpui2 reuses the md_mbt editor (MoonBit core + GPUI adapter over the
benchmark-instrumented wzzc-dev/gpui-moonbit fork). This script only drives
`moon build` in that checkout and installs the resulting executable next to
the adapter wrappers; all editor logic lives in md_mbt.
"""

from __future__ import annotations

import os
import platform
import shutil
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent
MD_MBT = Path(os.environ.get("MD_MBT_DIR", str(ROOT.parents[1] / "md_mbt"))).resolve()
# Same registry cache the gpui adapter pins so machine-wide registry
# replacement settings cannot make the vendored binding unreproducible.
DEFAULT_CARGO_HOME = ROOT.parent / ".tools" / "gpui-cargo-home"


def run(command: list[str], **kwargs) -> subprocess.CompletedProcess[str]:
    print("+", " ".join(command), flush=True)
    return subprocess.run(command, text=True, check=True, **kwargs)


def install_atomic(source: Path, target: Path) -> None:
    """Install a binary without truncating an executable held by an old run.

    Mirrors gpui/build.py: macOS keeps the vnode/code-signature state of a
    running Mach-O alive, so each launch gets a complete new inode.
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


def remove_stale_release_outputs() -> None:
    """Force relinking when the external Rust static library changes.

    MoonBit's incremental graph does not include `libgpui_sys.a` produced by
    the gpui-bindings prebuild hook, so a stale executable could silently keep
    an older benchmark loop.
    """
    for path in (MD_MBT / "_build" / "native" / "release" / "build").glob("**/main/main.exe"):
        path.unlink(missing_ok=True)


def main() -> None:
    if platform.system() != "Darwin":
        print(f"gpui2 (md_mbt) is verified on macOS arm64 only; skipping the build on {platform.system()}.")
        return
    if not MD_MBT.is_dir():
        raise SystemExit(f"{MD_MBT} is missing; set MD_MBT_DIR to the md_mbt checkout")
    environment = os.environ.copy()
    environment.setdefault("CARGO_HOME", str(DEFAULT_CARGO_HOME))
    remove_stale_release_outputs()
    run(["moon", "build", "--target", "native", "--release"], cwd=MD_MBT, env=environment)
    candidates = list((MD_MBT / "_build" / "native" / "release" / "build").glob("**/main/main.exe"))
    if not candidates:
        raise SystemExit("MoonBit executable not found under md_mbt/_build/native/release/build")
    executable = max(candidates, key=lambda path: path.stat().st_mtime)
    install_atomic(executable, ROOT / "dist" / "gpui2-markdown-editor")
    print(f"Built {ROOT / 'dist' / 'gpui2-markdown-editor'} from {MD_MBT}")


if __name__ == "__main__":
    main()
