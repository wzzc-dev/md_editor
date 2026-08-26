# Adapter protocol

An adapter receives a fixture path and one scenario (`open`, `input`, or
`scroll`) and prints one JSON object on stdout. The required fields are:

```json
{"adapter":"name","measurement_scope":"headless-render","scenario":"scroll","samples_ms":[1.2],"mean_ms":1.2,"p95_ms":1.2,"p99_ms":1.2,"dropped_frames":0,"input_latency_ms":null}
```

`run_benchmark.py` adds process elapsed time and environment metadata. For
local runs against built applications:

```sh
python3 bench/run_benchmark.py \
  --adapter moui-skia-raster='moon run moui/benchmark --target native -- {fixture} {scenario}' \
  --adapter moui-skia-gpu='moon run moui/benchmark --target native -- {fixture} {scenario}' \
  --adapter gpui='cargo run --release --manifest-path gpui/Cargo.toml -- --benchmark {fixture} {scenario}' \
  --adapter flutter-skia='dart run flutter/tool/benchmark.dart {fixture} {scenario}' \
  --adapter flutter-impeller='dart run flutter/tool/benchmark.dart {fixture} {scenario}' \
  --adapter electron='npm run --prefix electron benchmark -- {fixture} {scenario}' \
  --fixture small --fixture medium --out results/local.json
python3 bench/report.py results/local.json > results/local.md
```

The MoUI and Flutter binaries can be wrapped in the same protocol without
changing the runner. Keeping the protocol outside the UI lets a Windows host
run the exact same scenarios as macOS.
