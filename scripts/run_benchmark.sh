#!/bin/sh
# Reproducible cross-framework benchmark for MoUI (Skia Raster/GPU), GPUI,
# Flutter (Skia/Impeller) and Electron. Adapters whose toolchain is missing are
# recorded as `skipped` in the report; this is intentional, see docs/limitations.md.
set -eu
python3 "$(dirname "$0")/generate_fixtures.py"

# Build the MoonBit GPUI app once; the adapter below only invokes its stable
# benchmark entrypoint for each fixture/scenario repetition.
"$(dirname "$0")/../gpui/build.sh"

python3 "$(dirname "$0")/../bench/run_benchmark.py" \
  --adapter moui-skia-raster='MOUI_SKIA_RENDERER=skia-raster moon run moui/benchmark --target native --release -- {fixture} {scenario}' \
  --adapter moui-skia-gpu='MOUI_SKIA_RENDERER=skia-gpu moon run moui/benchmark --target native --release -- {fixture} {scenario}' \
  --adapter gpui='python3 gpui/benchmark.py {fixture} {scenario}' \
  --adapter flutter-skia='FLUTTER_RENDERER=skia dart run flutter/tool/benchmark.dart {fixture} {scenario}' \
  --adapter flutter-impeller='FLUTTER_RENDERER=impeller dart run flutter/tool/benchmark.dart {fixture} {scenario}' \
  --adapter electron='npm run --prefix electron benchmark -- {fixture} {scenario}' \
  --out results/local.json
python3 "$(dirname "$0")/../bench/report.py" results/local.json > results/local.md
