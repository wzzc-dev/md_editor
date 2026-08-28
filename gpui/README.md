# GPUI Markdown Editor

This is the GPUI counterpart of the MoUI editor. The UI, editor state,
Markdown parsing, event dispatch, file operations, and GPUI command tree are
written in MoonBit under `app/` and `cmd/main/`. The submodule
`nakake/gpui-bindings` module is the native Rust bridge to GPUI; it does not
own the application UI.

The binding source is checked out as a Git submodule under
`vendor/gpui-moonbit/` because Moon's dependency schema cannot select a Git
repository subdirectory. The submodule pins the upstream revision; update it
with `git submodule update --remote gpui/vendor/gpui-moonbit` (or by checking
out a specific commit inside the submodule and committing the new git link).

The editor uses a Velotype-style block WYSIWYG interaction: formatted blocks
are shown by default; clicking a block overlays GPUI's native input with
transparent source glyphs while the MoonBit-built formatted layer stays
visible. GPUI still paints the caret and selection, and changes serialize back
to Markdown. The benchmark adapter uses the same MoonBit block parser as the
app and emits the shared JSON protocol.

```shell
./build.sh
python3 ui_benchmark.py ../data/medium.md scroll
```

`build.py` invokes `moon build cmd/main --target native --release`. The
binding's Moon prebuild compiles and links `gpui-sys`, then the script produces
`dist/gpui-markdown-editor` (and a macOS `.app` on macOS).
Unless `CARGO_HOME` is already set, the build uses the ignored
`../.tools/gpui-cargo-home` cache so machine-wide registry replacement settings
cannot make the submodule binding unreproducible.

Hidden Markdown markers still participate in GPUI input hit-testing, so caret
position can be horizontally offset around syntax. This source/display mapping
limit is documented in `docs/limitations.md`.
