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
override the published versions for `momark` and `moui`. `moon.work` also lists
the vendored `vendor/MoUI/window/modules/{window,windowing}` packages, so the
native window/AppKit layer used by the entrypoints is the checked-out source
rather than the published `wzzc-dev/window`. See
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
The current audited captures are the dated pairs
[`results/macos-arm64-ui-20260905.json`](results/macos-arm64-ui-20260905.json)
with its rendered
[`Markdown report`](results/macos-arm64-ui-20260905.md) (Apple M4 16 GiB,
360/360 desktop UI-process records — ten adapters x four fixtures x three
scenarios x three repetitions) and
[`results/windows-amd64-ui-20260905.json`](results/windows-amd64-ui-20260905.json)
with its [`Markdown report`](results/windows-amd64-ui-20260905.md) (Windows 11
amd64 16 GiB, 360/360 records including the `gpmark` native-window rows from
the GpMark.mbt submodule editor over the vendored `gpui-moonbit` MSVC bridge).
The reports intentionally show where the strict 2x screen passes and fails;
frame clocks are framework-specific and are not compositor-equivalent.
Reproduction on Windows is documented in [`docs/windows.md`](docs/windows.md).

After the September MoMark input-path optimizations (binary-search block
lookups with O(1) session-length clamps, memoized font-file typefaces, and the
native glyph-mapping memo that removed an O(N^2) per-keystroke coverage pass),
a focused re-measurement of the `moui-md-*` adapters is captured as the dated
pair [`results/macos-arm64-ui-20260916-momark-inputfix.json`](results/macos-arm64-ui-20260916-momark-inputfix.json)
with its rendered
[`Markdown report`](results/macos-arm64-ui-20260916-momark-inputfix.md):
180 measured records (the three MoMark renderers, the simplified MoUI raster
control, and `gpmark` x four fixtures x three scenarios x three repetitions)
on the same Apple M4 16 GiB host in native-window mode; the Flutter and
Electron rows are `skipped` in this focused capture. MoMark stress input
latency (frame interval mean/P95) improves from 38.13/48.32, 20.94/22.55 and
24.65/27.38 ms (raster/GPU/wgpu, [`macos-arm64-ui-20260914-postfix`](results/macos-arm64-ui-20260914-postfix.md))
to 34.87/36.29, 17.98/19.28 and 21.64/22.89 ms, with `gpmark` at 9.27/10.71 ms.
A diagnostic headless probe (a temporary 2,000-keystroke loop run during
development, outside the audited protocol and not preserved as a results
capture) shows the long-typing growth pathology — per-keystroke coverage
checks of the edited block were quadratic in its length — flattening from
~44 ms at 1,000 typed keys and ~120 ms at 2,000 to ~15 ms and ~27 ms. The `moui-md-wgpu`
`工作` column reads 0 in this capture because the native wgpu pump currently
emits no frame-phase diagnostics (it was 4.2 ms in the 20260914-postfix
capture); compare that adapter on the frame-interval and input-to-visible
columns.

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
