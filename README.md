# Cross-framework Markdown WYSIWYG benchmark

This repository contains intentionally small desktop Markdown editors and one
repeatable benchmark protocol. The same source document, 1280x800 viewport and
interaction script are used for MoUI (Skia raster/GPU), MoMark, GpMark.mbt
(GPUI), Flutter (Skia/Impeller) and Electron/Vditor. Desktop UI-process
adapters emit `ui-frame` records;
separate command-line adapters retain a renderer-independent
`headless-render` diagnostic baseline.

The editor contract is deliberately narrow: open a `.md` file, edit Markdown,
render the formatted document live, and scroll a long document. Saving emits
Markdown source from the edited block model; insignificant whitespace may be
normalized. Unsupported constructs remain editable source text.

## Layout

| Directory | Implementation |
| --- | --- |
| `moui/` | MoonBit + local MoUI rich-text editor, native Skia and WGPU entrypoints |
| `momark/` | Git submodule: [MoMark](https://github.com/wzzc-dev/MoMark) — the standalone Markdown editor example app (extracted from MoUI `examples/markdown_editor`) |
| `gpmark/` | Git submodule: [GpMark.mbt](https://github.com/wzzc-dev/GpMark.mbt) — MoonBit velotype-style block WYSIWYG on GPUI over the vendored Rust native binding |
| `flutter/` | Flutter Material 3 WYSIWYG comparison editor |
| `electron/` | Electron + Vditor WYSIWYG comparison editor |
| `data/` | Deterministic Small/Medium/Large/Stress Markdown fixtures |
| `bench/` | Cross-platform runner, raw JSON and report generation |
| `docs/` | Build, run and measurement notes |

## Quick start

```sh
# Build each application once and run all seven desktop UI-process adapters.
./scripts/run_ui_benchmark.sh

# Fast seven-adapter integration smoke run.
UI_BENCHMARK_REPETITIONS=1 UI_BENCHMARK_WARMUPS=0 \
  ./scripts/run_ui_benchmark.sh --fixture small \
  --out results/smoke-ui.json

# Run the MoUI/MoMark adapters in a real AppKit window instead of the
# default headless host surface (framework-callback diagnostics only).
UI_BENCHMARK_WINDOWED=1 ./scripts/run_ui_benchmark.sh --out results/windowed-ui.json
```

Workspace builds (`moon run`/`moon build`/`moon test` with a target path) must
run from the repository root — only then do the `vendor/MoUI` submodule sources
override the published versions for `momark` and `moui`. See
[`docs/build-and-run.md`](docs/build-and-run.md).

The GUI entrypoints are documented in [`docs/build-and-run.md`](docs/build-and-run.md).
The benchmark never invents timings: unavailable commands are reported as
`skipped`, while every measured sample contains host metadata, renderer,
command, action count, frame sample count, warm-ups and raw samples. Flutter
Skia/Impeller labels are accepted only after matching engine startup logs.

The current audited macOS arm64 capture is
[`results/macos-arm64-ui.json`](results/macos-arm64-ui.json) with the rendered
[`Markdown report`](results/macos-arm64-ui.md): 252/252 desktop UI-process
records (seven adapters x four fixtures x three scenarios x three repetitions)
are measured on an Apple M4 16 GiB host at 1280x800, with the `gpmark` row
emitted by the GpMark.mbt submodule editor. The report intentionally shows
where the strict 2x screen passes and fails; frame clocks are framework-specific
and are not compositor-equivalent. By default the MoUI/MoMark adapters render
on a headless host surface (no window); `UI_BENCHMARK_WINDOWED=1` runs them in
a real AppKit window with the same class of framework-callback diagnostics as
the GPUI/Flutter/Electron adapters
(see [`docs/benchmark-protocol.md`](docs/benchmark-protocol.md)). A dedicated
Windows amd64 16 GiB capture is
still required and is documented in [`docs/windows.md`](docs/windows.md).

For a protocol-only Flutter baseline (when Dart is installed), use
`dart run flutter/tool/benchmark.dart {fixture} {scenario}`. This measures the
same block preparation as the comparison widgets; desktop Flutter frame
claims still require an instrumented GUI run.

Electron uses Vditor 3.11.3 in `mode: "wysiwyg"` and loads all assets locally;
its headless benchmark additionally emits a Small-only full Lute DOM row.
The `gpmark/` submodule runs the GpMark.mbt editor: its MoonBit core owns the
command tree, editor state, Markdown model, event handlers, file operations and
process entrypoint, linked to the vendored `gpui-moonbit` Rust static library
that is limited to the GPUI native capability bridge.

## Reproducibility

Run on an idle machine, disable battery/power saving, keep the generated
1280x800 viewport, and use the default one process warm-up plus three recorded
repetitions. The script builds MoUI once and directly starts the same binary
for Raster and GPU. It builds Flutter Profile once and verifies Skia/Impeller
from engine logs. See
[`docs/benchmark-protocol.md`](docs/benchmark-protocol.md) for the exact
command line and metric definitions. Windows amd64 reproduction is documented
in [`docs/windows.md`](docs/windows.md).
