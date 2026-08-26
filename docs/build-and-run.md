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

`moon check moui/app --target native` validates the app without a window. On macOS, `moon run moui/macos_skia --target native` opens
the editor; use `moon run moui/windows_skia --target native` on Windows. Set
`MOUI_SKIA_RENDERER=skia-raster` for Skia Raster or
`MOUI_SKIA_RENDERER=skia-gpu` for Skia GPU. The same environment selection is
available on both native entrypoints. A file can be opened with **Open** and
saved with **Save**. For protocol smoke tests without a window, run
`moon run moui/benchmark --target native -- data/small.md scroll`; this uses
the same runtime view tree and reports `headless-render`.

## GPUI

`cargo run --manifest-path gpui/Cargo.toml --release` opens the GPUI window at
1280x800.
The **Open** button uses a native file dialog, **Save** writes the Markdown
source, and the editor surface accepts keyboard input and wheel scrolling.
`cargo check --manifest-path gpui/Cargo.toml` is sufficient on CI hosts
without a display server.

## Flutter and Electron

Flutter requires a current stable SDK: `flutter pub get && flutter run
--desktop`. Use `--enable-impeller` or `--no-enable-impeller` to select the
renderer and resize the desktop window to 1280x800 before measuring. A pure
Dart headless adapter is available as
`dart run flutter/tool/benchmark.dart data/small.md scroll` for protocol smoke
tests. Electron
requires Node 20+: `npm install --prefix electron && npm run --prefix electron
start` (its default window is 1280x800).

All four UIs intentionally expose the same title, Open, Save, document body,
status line and scrolling behavior. They are comparison implementations, not
feature-complete editors.
