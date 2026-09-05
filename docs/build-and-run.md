# Build and run

## MoUI

The checked-in project uses MoUI as the `vendor/MoUI` Git submodule. Its
framework, rich-text, Skia, Skia renderer, and WGPU renderer modules are
workspace members in `moon.work`, so their checked-out sources override the
versions recorded in `moui/moon.mod`. The official Markdown editor example app
is now the standalone [MoMark](https://github.com/wzzc-dev/MoMark) repository,
checked in as the `momark/` Git submodule and likewise a `moon.work` member
(`moui` imports it as `wzzc-dev/momark` for the `moui-md-*` benchmark rows).

```sh
git submodule update --init --recursive
```

`moon check moui/app --target native` validates the app without a window. On
macOS, `moon run moui/macos_skia --target native` opens the editor; use `moon
run moui/windows_skia --target native` on Windows. Set
`MOUI_SKIA_RENDERER=skia-raster` for Skia Raster or
`MOUI_SKIA_RENDERER=skia-gpu` for Skia GPU. The same environment selection is
available on both native entrypoints. Skia `auto` keeps the local provider's
GPU-first order with raster fallback, and the entrypoints pass the platform
application environment into the editor program.

The explicit WGPU routes use CoreText with Cosmic fallback on macOS and
DirectWrite with Cosmic fallback on Windows:

```sh
moon run moui/macos_wgpu --target native
moon run moui/windows_wgpu --target native
```

A file can be opened with **Open** and saved with **Save**. For protocol smoke tests without a window, run
`moon run moui/benchmark --target native --release -- data/small.md scroll`;
this prints
a comparable `headless-render` row (a lightweight block splitter matching the
GPUI/Electron/Flutter adapters) plus a `richtext-full` row
(`markdown_document`, capped at the small fixture). Set
`MOUI_SKIA_RENDERER` before the command to label the adapter
(`moui-skia-raster` or `moui-skia-gpu`). The real UI adapter is built once and
started directly, without `moon run` overhead. It uses the same fixed-height
block virtualization as the other comparison editors:

```sh
moon build moui/benchmark --target native --release
python3 moui/ui_benchmark.py skia-raster data/small.md scroll
MOUI_GPU_ROUTE=metal python3 moui/ui_benchmark.py skia-gpu data/small.md scroll
```

## GpMark.mbt (GPUI)

`gpmark/` is the [GpMark.mbt](https://github.com/wzzc-dev/GpMark.mbt) Git
submodule: a velotype-style MoonBit block-WYSIWYG
core (live inline transforms, snapshot undo, estimator-windowed block
rendering) on GPUI, vendoring the benchmark-instrumented
wzzc-dev/gpui-moonbit fork under `gpmark/third_party`:

```sh
git submodule update --init --recursive   # gpmark and its vendored gpui-moonbit
./bench/adapters/gpmark/build.sh
```

`build.py` runs `moon build --target native --release` inside the submodule
(unless `CARGO_HOME` is set explicitly, it uses the ignored repository-local
`.tools/gpmark-cargo-home` so the vendored binding stays reproducible) and
installs `bench/adapters/gpmark/dist/gpmark-markdown-editor`. Pass a Markdown
path
as the first argument to open the document in the interactive 1280x800 GPUI
window. MoonBit owns the command tree, block model, input handlers, file I/O,
benchmark and native process entrypoint; the vendored Rust `gpui-sys` static
library only exposes GPUI window, rendering and input capabilities over the
native binding.

The benchmark wrappers invoke the built executable without rebuilding:

```sh
python3 bench/adapters/gpmark/ui_benchmark.py data/small.md input
python3 bench/adapters/gpmark/benchmark.py data/small.md open
```

The Rust window benchmark loop labels the ui-frame row through
`UI_BENCHMARK_ADAPTER_NAME` (set by the wrapper to `gpmark`). Input actions
reach
the editor as real `EVENT_TEXT` dispatches and scroll drives the retained
`ScrollHandle`. GpMark.mbt is validated on macOS arm64 only; on other platforms
the
adapter emits the shared `skipped` protocol row.

## Flutter and Electron

Flutter requires a current stable SDK. For interactive use, run `flutter run
-d macos --no-enable-impeller` or the corresponding Windows command. The UI
benchmark requires a Profile build and validates the engine backend log before
emitting a result:

```sh
cd flutter
flutter pub get
flutter build macos --profile       # use windows on Windows
cd ..
python3 flutter/ui_benchmark.py skia data/small.md scroll
python3 flutter/ui_benchmark.py impeller data/small.md scroll
```

A pure Dart headless adapter remains available as `dart run
flutter/tool/benchmark.dart data/small.md scroll`. Electron requires Node
22.12+ for Electron 44. `npm ci --prefix electron` runs the project's
`postinstall` to fetch the platform runtime. Run `npm run check --prefix
electron` to validate the JavaScript entrypoints. Start it with `npm run --prefix
electron start`; run the direct adapter with `python3 electron/ui_benchmark.py
data/small.md scroll`. The editor is Vditor 3.11.3 in `mode: "wysiwyg"`, with
all assets loaded locally from `electron/node_modules`.

All four UIs intentionally expose the same title, Open, Save, document body,
status line and scrolling behavior. They are comparison implementations, not
feature-complete editors.

## Full UI matrix

`scripts/run_ui_benchmark.sh` generates fixtures, builds each application once,
runs all seven desktop UI-process adapters, and writes a platform-specific
JSON/Markdown pair under `results/`. Extra runner options are forwarded, for example
`--fixture medium --repetitions 1 --warmups 0`.
