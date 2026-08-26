# Cross-framework Markdown WYSIWYG benchmark

This repository contains intentionally small desktop Markdown editors and one
repeatable benchmark protocol. The same source document, viewport size and
interaction script are used for MoUI (Skia raster/GPU), GPUI, Flutter (Skia/
Impeller) and Electron. The checked-in command-line adapters provide a
renderer-independent `headless-render` baseline; GUI frame claims require the
platform-specific instrumentation described below.

The editor contract is deliberately narrow: open a `.md` file, edit Markdown,
render the formatted document live, and scroll a long document. The saved
value is always the original Markdown source. Unsupported constructs remain
editable source text.

## Layout

| Directory | Implementation |
| --- | --- |
| `moui/` | MoonBit + MoUI rich-text editor, native Skia entrypoint |
| `gpui/` | Rust GPUI 0.2 editor using `gpui-component` input and `markdown` |
| `flutter/` | Flutter Material 3 comparison editor |
| `electron/` | Electron comparison editor |
| `data/` | Deterministic Small/Medium/Large/Stress Markdown fixtures |
| `bench/` | Cross-platform runner, raw JSON and report generation |
| `docs/` | Build, run and measurement notes |

## Quick start

```sh
python3 scripts/generate_fixtures.py
moon check moui/app --target native
cargo check --manifest-path gpui/Cargo.toml
python3 bench/run_benchmark.py \
  --adapter gpui='cargo run --release --manifest-path gpui/Cargo.toml -- --benchmark {fixture} {scenario}' \
  --adapter electron='npm run --prefix electron benchmark -- {fixture} {scenario}' \
  --fixture small --repetitions 1 --warmups 0 --out results/local.json
python3 bench/report.py results/local.json > results/local.md
```

The GUI entrypoints are documented in [`docs/build-and-run.md`](docs/build-and-run.md).
The benchmark never invents timings: unavailable commands are reported as
`skipped`, while every measured sample contains the host, renderer, command,
warm-up count and raw frame samples.

For a protocol-only Flutter baseline (when Dart is installed), use
`dart run flutter/tool/benchmark.dart {fixture} {scenario}`. This measures the
same block preparation as the comparison widgets; desktop Flutter frame
claims still require an instrumented GUI run.

## Reproducibility

Run on an idle machine, disable battery/power saving, use a fixed window size
of 1280x800, and run each scenario three times. On macOS and Windows use the
same MoUI binary for Skia Raster and Skia GPU, selecting
`MOUI_SKIA_RENDERER=skia-raster|skia-gpu`. Flutter renderer selection is
controlled by `--enable-impeller` (or `--no-enable-impeller`). See
[`docs/benchmark-protocol.md`](docs/benchmark-protocol.md) for the exact
command line and metric definitions.
