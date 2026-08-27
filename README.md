# Cross-framework Markdown WYSIWYG benchmark

This repository contains intentionally small desktop Markdown editors and one
repeatable benchmark protocol. The same source document, 1280x800 viewport and
interaction script are used for MoUI (Skia raster/GPU), GPUI, Flutter (Skia/
Impeller) and Electron/Vditor. Real-window adapters emit `ui-frame` records;
separate command-line adapters retain a renderer-independent
`headless-render` diagnostic baseline.

The editor contract is deliberately narrow: open a `.md` file, edit Markdown,
render the formatted document live, and scroll a long document. The saved
value is always the original Markdown source. Unsupported constructs remain
editable source text.

## Layout

| Directory | Implementation |
| --- | --- |
| `moui/` | MoonBit + MoUI rich-text editor, native Skia entrypoint |
| `gpui/` | MoonBit document model + Rust GPUI native staticlib, block WYSIWYG editor |
| `flutter/` | Flutter Material 3 WYSIWYG comparison editor |
| `electron/` | Electron + Vditor WYSIWYG comparison editor |
| `data/` | Deterministic Small/Medium/Large/Stress Markdown fixtures |
| `bench/` | Cross-platform runner, raw JSON and report generation |
| `docs/` | Build, run and measurement notes |

## Quick start

```sh
# Build each application once and run all six real-window adapters.
./scripts/run_ui_benchmark.sh

# Fast six-adapter integration smoke run.
UI_BENCHMARK_REPETITIONS=1 UI_BENCHMARK_WARMUPS=0 \
  ./scripts/run_ui_benchmark.sh --fixture small \
  --out results/smoke-ui.json
```

The GUI entrypoints are documented in [`docs/build-and-run.md`](docs/build-and-run.md).
The benchmark never invents timings: unavailable commands are reported as
`skipped`, while every measured sample contains host metadata, renderer,
command, action count, frame sample count, warm-ups and raw samples. Flutter
Skia/Impeller labels are accepted only after matching engine startup logs.

The current audited macOS arm64 capture is
[`results/macos-arm64-ui.json`](results/macos-arm64-ui.json) with the rendered
[`Markdown report`](results/macos-arm64-ui.md): 216/216 desktop UI-process
records are measured on an Apple M4 16 GiB host at 1280x800. The report intentionally shows
where the strict 2x screen passes and fails; frame clocks are framework-specific
and are not compositor-equivalent. A dedicated Windows amd64 16 GiB capture is
still required and is documented in [`docs/windows.md`](docs/windows.md).

For a protocol-only Flutter baseline (when Dart is installed), use
`dart run flutter/tool/benchmark.dart {fixture} {scenario}`. This measures the
same block preparation as the comparison widgets; desktop Flutter frame
claims still require an instrumented GUI run.

Electron uses Vditor 3.11.3 in `mode: "wysiwyg"` and loads all assets locally;
its headless benchmark additionally emits a Small-only full Lute DOM row.
GPUI's MoonBit
executable links a small Rust GPUI static library through native FFI. Both
editors expose a single formatted document surface and preserve Markdown
source on save. The GPUI MoonBit package owns the shared block counter and
native process entrypoint; the Rust layer supplies the GPUI interactive host.

## Reproducibility

Run on an idle machine, disable battery/power saving, keep the generated
1280x800 viewport, and use the default one process warm-up plus three recorded
repetitions. The script builds MoUI once and directly starts the same binary
for Raster and GPU. It builds Flutter Profile once and verifies Skia/Impeller
from engine logs. See
[`docs/benchmark-protocol.md`](docs/benchmark-protocol.md) for the exact
command line and metric definitions. Windows amd64 reproduction is documented
in [`docs/windows.md`](docs/windows.md).
