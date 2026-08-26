# GPUI Markdown Editor

This is the GPUI counterpart of the MoUI editor. It uses GPUI 0.2.2 for the
window and `gpui-component`'s multi-line `InputState` for native editing,
selection, clipboard, keyboard commands and scrolling. The right pane renders
the same Markdown source as block-level headings, paragraphs, bullet items,
quotes and fenced code, with lightweight inline emphasis and code styling. The
parser intentionally covers only the subset needed by this comparison editor;
unsupported Markdown remains editable source text. The command-line benchmark
uses the same parser and reports `measurement_scope=headless-render`, so it is
not a GPU-present or input-to-present measurement.

```sh
cargo run --release --manifest-path gpui/Cargo.toml -- data/medium.md
cargo run --release --manifest-path gpui/Cargo.toml -- --benchmark data/medium.md scroll
```
