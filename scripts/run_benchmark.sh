#!/bin/sh
# Reproducible cross-framework benchmark for MoUI (Skia Raster/GPU), GPUI,
# Flutter (Skia/Impeller) and Electron. Adapters whose toolchain is missing are
# recorded as `skipped` in the report; this is intentional, see docs/limitations.md.
set -eu
python3 "$(dirname "$0")/generate_fixtures.py"

python3 "$(dirname "$0")/../bench/run_benchmark.py" \
  --adapter moui-skia-raster='env MOUI_SKIA_RENDERER=skia-raster moon run moui/benchmark --target native -- {fixture} {scenario}' \
  --adapter moui-skia-gpu='env MOUI_SKIA_RENDERER=skia-gpu moon run moui/benchmark --target native -- {fixture} {scenario}' \
  --adapter gpui='cargo run --release --manifest-path gpui/Cargo.toml -- --benchmark {fixture} {scenario}' \
  --adapter flutter-skia='dart run flutter/tool/benchmark.dart {fixture} {scenario}' \
  --adapter flutter-impeller='dart run flutter/tool/benchmark.dart {fixture} {scenario}' \
  --adapter electron='npm run --prefix electron benchmark -- {fixture} {scenario}' \
  --out results/local.json
python3 "$(dirname "$0")/../bench/report.py" results/local.json > results/local.md
