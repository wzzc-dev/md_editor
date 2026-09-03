#!/bin/sh
# Reproducible cross-framework benchmark for MoUI (Skia Raster/GPU), GPUI,
# Flutter (Skia/Impeller) and Electron. Adapters whose toolchain is missing are
# recorded as `skipped` in the report; this is intentional, see docs/limitations.md.
set -eu
python3 "$(dirname "$0")/generate_fixtures.py"

# The macOS benchmark package hardcodes AppKit/CoreText/Metal native stubs
# and cannot link on Windows; the Windows package mirrors its protocol.
case "$(uname -s)" in
  Darwin) MOUI_BENCHMARK_PACKAGE=moui/benchmark ;;
  MINGW*|MSYS*|CYGWIN*) MOUI_BENCHMARK_PACKAGE=moui/windows_benchmark ;;
  *) MOUI_BENCHMARK_PACKAGE=moui/benchmark ;;
esac

# The lazy `moon run` adapter commands below compile the windows_benchmark
# closure, and moon tracks the CL environment per object: every such command
# must carry the same CL/MBT_WGPU_* environment as the two-pass prebuild, or
# wgpu_mbt's C stub objects get invalidated and rebuild without the C11 flags
# (loud C1189, repaired by rerunning scripts/build_moui_windows.sh).
MOUI_NATIVE_ENV=""
if [ "$MOUI_BENCHMARK_PACKAGE" = "moui/windows_benchmark" ]; then
  "$(dirname "$0")/build_moui_windows.sh"
  MOUI_NATIVE_ENV="CL='/std:c11 /experimental:c11atomics' MBT_WGPU_LINK_MODE=dynamic MBT_WGPU_NATIVE_ROOT='$(cygpath -w "$(dirname "$0")/../.cache/wgpu-native-msvc")' "
fi

# Build the gpui (md_mbt) app once; it is macOS-arm64-only, build.py
# self-skips elsewhere and the adapter then reports a `skipped` protocol row.
# The adapter below only invokes the stable benchmark entrypoint.
"$(dirname "$0")/../bench/adapters/gpui/build.sh"

python3 "$(dirname "$0")/../bench/run_benchmark.py" \
  --adapter moui-skia-raster="${MOUI_NATIVE_ENV}MOUI_SKIA_RENDERER=skia-raster moon run $MOUI_BENCHMARK_PACKAGE --target native --release -- {fixture} {scenario}" \
  --adapter moui-skia-gpu="${MOUI_NATIVE_ENV}MOUI_SKIA_RENDERER=skia-gpu moon run $MOUI_BENCHMARK_PACKAGE --target native --release -- {fixture} {scenario}" \
  --adapter gpui='python3 bench/adapters/gpui/benchmark.py {fixture} {scenario}' \
  --adapter flutter-skia='FLUTTER_RENDERER=skia dart run flutter/tool/benchmark.dart {fixture} {scenario}' \
  --adapter flutter-impeller='FLUTTER_RENDERER=impeller dart run flutter/tool/benchmark.dart {fixture} {scenario}' \
  --adapter electron='npm run --prefix electron benchmark -- {fixture} {scenario}' \
  --out results/local.json
python3 "$(dirname "$0")/../bench/report.py" results/local.json > results/local.md
