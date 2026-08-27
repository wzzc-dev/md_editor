# GPUI Markdown Editor

This is the GPUI counterpart of the MoUI editor. The application layer is
MoonBit (`app/` and `cmd/main/`), while a small Rust `staticlib` (`src/lib.rs`)
owns the GPUI window and native input bridge. `gpui/build.py` compiles the
static library, injects its platform linker flags into a temporary MoonBit
manifest, and produces `dist/gpui-markdown-editor` (or a macOS `.app`).

The editor uses a Velotype-style block WYSIWYG interaction: formatted blocks
are shown by default; clicking a block overlays a native multiline input with
transparent source glyphs while the formatted block stays visible. GPUI still
paints the caret and selection, and changes serialize back to Markdown. Long
documents use GPUI's `uniform_list` virtual list. The benchmark adapter uses
the same MoonBit block counter as the app and emits the shared JSON protocol.

```sh
./build.sh
python3 ui_benchmark.py ../data/medium.md scroll
```

Hidden Markdown markers still participate in GPUI input hit-testing, so caret
position can be horizontally offset around syntax. This source/display mapping
limit is documented in `docs/limitations.md`.
