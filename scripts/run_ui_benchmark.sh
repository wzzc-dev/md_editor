#!/bin/sh
# Build once, then run all six desktop UI-process adapters through the harness.
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
SYSTEM=$(uname -s)
ARCH=$(uname -m)

case "$SYSTEM" in
  Darwin)
    PLATFORM_SLUG="macos-$ARCH"
    FLUTTER_TARGET=macos
    MOUI_GPU_ROUTE=metal
    ;;
  MINGW*|MSYS*|CYGWIN*)
    PLATFORM_SLUG="windows-$ARCH"
    FLUTTER_TARGET=windows
    MOUI_GPU_ROUTE=direct3d
    ;;
  *)
    echo "UI benchmark supports macOS and Windows only (found $SYSTEM)" >&2
    exit 64
    ;;
esac

OUT=${UI_BENCHMARK_OUT:-"$ROOT/results/$PLATFORM_SLUG-ui.json"}
REPETITIONS=${UI_BENCHMARK_REPETITIONS:-3}
WARMUPS=${UI_BENCHMARK_WARMUPS:-1}
TIMEOUT=${UI_BENCHMARK_TIMEOUT_SECONDS:-120}

python3 "$ROOT/scripts/generate_fixtures.py"
moon build moui/benchmark --target native --release
"$ROOT/gpui/build.sh"
npm ci --prefix "$ROOT/electron"
(
  cd "$ROOT/flutter"
  flutter pub get
  flutter build "$FLUTTER_TARGET" --profile
)

MOUI_GPU_ROUTE=$MOUI_GPU_ROUTE python3 "$ROOT/bench/run_benchmark.py" \
  --adapter moui-skia-raster='python3 moui/ui_benchmark.py skia-raster {fixture} {scenario}' \
  --adapter moui-skia-gpu='python3 moui/ui_benchmark.py skia-gpu {fixture} {scenario}' \
  --adapter moui-wgpu='python3 moui/ui_benchmark.py wgpu {fixture} {scenario}' \
  --adapter gpui='python3 gpui/ui_benchmark.py {fixture} {scenario}' \
  --adapter flutter-skia='python3 flutter/ui_benchmark.py skia {fixture} {scenario}' \
  --adapter flutter-impeller='python3 flutter/ui_benchmark.py impeller {fixture} {scenario}' \
  --adapter electron='python3 electron/ui_benchmark.py {fixture} {scenario}' \
  --repetitions "$REPETITIONS" \
  --warmups "$WARMUPS" \
  --timeout "$TIMEOUT" \
  --out "$OUT" \
  "$@"
python3 "$ROOT/bench/report.py" "$OUT" > "${OUT%.json}.md"
echo "wrote $OUT and ${OUT%.json}.md"
