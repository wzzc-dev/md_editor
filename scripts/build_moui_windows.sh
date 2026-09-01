#!/usr/bin/env bash
# Two-pass MSVC build for the Windows MoUI benchmark binaries.
#
# The registry `Milky2018/wgpu_mbt` package compiles its C stubs without a
# /std flag; MSVC then rejects its C11-atomics header (C1189), while
# `moui_skia` pins `/std:c++20` for its C++ stubs through package-level
# flags. One cl invocation cannot carry both standards (D8016) and moon has
# no consumer-side flag injection, so the flag sets are separated by build
# pass instead of by source or by vendored patching:
#
#   pass 1, clean env : windows_skia — a skia-only closure with no wgpu_mbt,
#                       compiling every shared C++ stub object.
#   pass 2, CL=c11    : windows_benchmark — with pass 1 fresh, the remaining
#                       objects are exactly wgpu_mbt's .c stubs plus this
#                       benchmark package, so the C11 flags reach C-only
#                       invocations and never touch a C++ object.
#
# Any future C++ object landing in pass 2 fails loudly with D8016 instead
# of miscompiling. Steady-state contract: moon tracks the CL environment
# per object, so after pass 2 every moon command that compiles the
# windows_benchmark closure (including the matrix's lazy `moon run`
# adapters, which embed the same environment) must carry
#   CL='/std:c11 /experimental:c11atomics' MBT_WGPU_LINK_MODE=dynamic
#   MBT_WGPU_NATIVE_ROOT=<.cache/wgpu-native-msvc>
# A bare invocation invalidates the wgpu C objects and fails loudly with
# C1189; rerunning this script repairs the state from any drift.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/moui"

# The dynamic (LoadLibrary) link mode is required on Windows: the upstream
# static win32 artifact is GNU-ABI and unresolvable through the MSVC
# toolchain moon drives. MBT_WGPU_NATIVE_ROOT must hold the official
# wgpu-native MSVC zip contents (dll + import lib + git-tag meta);
# scripts/fetch_wgpu_native.ps1 materializes them into .cache/wgpu-native-msvc.
NATIVE_ROOT="${MBT_WGPU_NATIVE_ROOT:-$ROOT/.cache/wgpu-native-msvc}"
if command -v cygpath >/dev/null 2>&1; then
  NATIVE_ROOT="$(cygpath -w "$NATIVE_ROOT")"
fi

moon build windows_skia --target native --release
CL='/std:c11 /experimental:c11atomics' \
MBT_WGPU_LINK_MODE=dynamic \
MBT_WGPU_NATIVE_ROOT="$NATIVE_ROOT" \
  moon build windows_benchmark --target native --release
