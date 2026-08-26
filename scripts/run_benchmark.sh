#!/bin/sh
set -eu
python3 "$(dirname "$0")/generate_fixtures.py"
python3 "$(dirname "$0")/../bench/run_benchmark.py" \
  --adapter gpui='cargo run --release --manifest-path gpui/Cargo.toml -- --benchmark {fixture} {scenario}' \
  --adapter electron='npm run --prefix electron benchmark -- {fixture} {scenario}' \
  --out results/local.json
python3 "$(dirname "$0")/../bench/report.py" results/local.json > results/local.md
