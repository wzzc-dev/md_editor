#!/bin/sh
# Build once, then run all seven desktop UI-process adapters through the harness.
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
    MOUI_BENCHMARK_PACKAGE=moui/benchmark
    ;;
  MINGW*|MSYS*|CYGWIN*)
    PLATFORM_SLUG="windows-$ARCH"
    FLUTTER_TARGET=windows
    MOUI_GPU_ROUTE=direct3d
    # The macOS benchmark package hardcodes AppKit/CoreText/Metal stubs; the
    # Windows package mirrors it on top of backend-free headless primitives.
    MOUI_BENCHMARK_PACKAGE=moui/windows_benchmark
    ;;
  *)
    echo "UI benchmark supports macOS and Windows only (found $SYSTEM)" >&2
    exit 64
    ;;
esac

OUT=${UI_BENCHMARK_OUT:-"$ROOT/results/$PLATFORM_SLUG-ui.json"}
REPETITIONS=${UI_BENCHMARK_REPETITIONS:-3}
WARMUPS=${UI_BENCHMARK_WARMUPS:-1}
# Strict trace scratch can reach gigabytes per case. This wrapper owns the
# documented hardware entrypoint, so it reclaims scratch abandoned by earlier
# interrupted runs; bench/run_benchmark.py stays non-destructive by default.
SCRATCH_MAX_AGE_SECONDS=${UI_BENCHMARK_SCRATCH_MAX_AGE_SECONDS:-21600}
if [ "${UI_BENCHMARK_SYSTEM_TRACE:-0}" = "1" ]; then
  # Deferred xctrace stores (especially stress fixtures) can take several
  # minutes to materialize after the adapter has emitted its JSON.
  TIMEOUT=${UI_BENCHMARK_TIMEOUT_SECONDS:-300}
else
  TIMEOUT=${UI_BENCHMARK_TIMEOUT_SECONDS:-120}
fi
SYSTEM_TRACE_FLAG=
SYSTEM_TRACE_ARGS=
if [ "${UI_BENCHMARK_SYSTEM_TRACE:-0}" = "1" ]; then
  SYSTEM_TRACE_FLAG=--system-present-trace
  if [ -n "${UI_BENCHMARK_SYSTEM_TRACE_DIR:-}" ]; then
    SYSTEM_TRACE_ARGS="--system-trace-dir=${UI_BENCHMARK_SYSTEM_TRACE_DIR}"
  fi
fi

python3 "$ROOT/scripts/generate_fixtures.py"
# Windows needs the two-pass MSVC build (see scripts/build_moui_windows.sh);
# macOS builds the single benchmark package directly.
if [ "$MOUI_BENCHMARK_PACKAGE" = "moui/windows_benchmark" ]; then
  "$ROOT/scripts/build_moui_windows.sh"
else
  moon build "$MOUI_BENCHMARK_PACKAGE" --target native --release
fi
"$ROOT/gpui/build.sh"
# gpui2 (md_mbt) is macOS-arm64-only; build.py self-skips elsewhere and the
# adapter then reports the documented `skipped` protocol row.
"$ROOT/gpui2/build.sh"
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
  --adapter gpui2='python3 gpui2/ui_benchmark.py {fixture} {scenario}' \
  --adapter flutter-skia='python3 flutter/ui_benchmark.py skia {fixture} {scenario}' \
  --adapter flutter-impeller='python3 flutter/ui_benchmark.py impeller {fixture} {scenario}' \
  --adapter electron='python3 electron/ui_benchmark.py {fixture} {scenario}' \
  --repetitions "$REPETITIONS" \
  --warmups "$WARMUPS" \
  --timeout "$TIMEOUT" \
  --scratch-max-age-seconds "$SCRATCH_MAX_AGE_SECONDS" \
  $SYSTEM_TRACE_FLAG \
  $SYSTEM_TRACE_ARGS \
  --out "$OUT" \
  "$@"
python3 "$ROOT/bench/report.py" "$OUT" > "${OUT%.json}.md"
echo "wrote $OUT and ${OUT%.json}.md"
