# Build and run

## MoUI

The checked-in project is a small MoonBit package using the MoUI rich-text
packages. Because `moui_richtext` is currently developed in the MoUI
workspace rather than published to the public registry, check out MoUI next to
this repository before building:

```sh
git clone https://github.com/wzzc-dev/MoUI.git ../MoUI
git -C ../MoUI submodule update --init --recursive
```

`moon check moui/app --target native` validates the app without a window. On
macOS, `moon run moui/macos_skia --target native` opens the editor; use `moon
run moui/windows_skia --target native` on Windows. Set
`MOUI_SKIA_RENDERER=skia-raster` for Skia Raster or
`MOUI_SKIA_RENDERER=skia-gpu` for Skia GPU. The same environment selection is
available on both native entrypoints. A file can be opened with **Open** and
saved with **Save**. For protocol smoke tests without a window, run
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

## GPUI

Build the MoonBit executable and Rust/GPUI static library together:

```sh
./gpui/build.sh                 # macOS/Linux
pwsh -File gpui/build.ps1       # Windows
```

The macOS build emits `gpui/dist/GPUI Markdown Editor.app`; the Windows build
emits `gpui/dist/gpui-markdown-editor.exe`. The executable opens the GPUI
window at 1280x800. The **Open** button uses a native file dialog, **Save**
writes the Markdown source, and the formatted block surface accepts keyboard
input and wheel scrolling. The MoonBit executable owns the shared benchmark
and native process entrypoint; the Rust staticlib owns the GPUI interactive
block model and input/window bridge.
`cargo check --manifest-path gpui/Cargo.toml` is sufficient on CI hosts
without a display server.

The GPUI desktop-window benchmark directly invokes the built executable:

```sh
python3 gpui/ui_benchmark.py data/small.md input
```

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
runs all six desktop UI-process adapters, and writes a platform-specific
JSON/Markdown pair under `results/`. Extra runner options are forwarded, for example
`--fixture medium --repetitions 1 --warmups 0`.
