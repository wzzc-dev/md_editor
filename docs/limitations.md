# Interpretation and limitations

## What is comparable

The benchmark fixes document bytes, block count, viewport, warm-up, repetition
count and interaction shape. It is appropriate for identifying regressions in
each implementation and for a coarse renderer comparison when all adapters
report real UI frame timestamps.

## What is not yet a release claim

The checked-in command-line adapters measure deterministic Markdown block
render preparation (`measurement_scope=headless-render`); they do not claim
GPU-present timing. Hardware frame metrics require a GUI automation wrapper on
the target OS to emit actual frame timestamps. The runner preserves that
distinction by retaining adapter commands and raw samples. The included
`results/macos-arm64-headless-3x.json` is a macOS arm64 development capture,
not the required final six-platform performance report.

## Implementation differences

- MoUI uses `controlled_markdown_editor` from `moui_richtext`, which is a
  formatted, source-preserving editing surface with visible-window support.
  The checked-in `moui/benchmark` adapter runs the same runtime tree without a
  native window; its `headless-render` scope is renderer-neutral and should not
  be labeled Skia Raster or Skia GPU frame timing.
- GPUI uses native `InputState` editing plus a deterministic block renderer.
  The benchmark adapter measures the same block parsing and text preparation;
  a full HTML tree is intentionally out of scope for the native GPUI surface.
- Flutter and Electron use native multiline text controls with matching block
  semantics. Flutter's `markdown` dependency remains available for future
  CommonMark extensions, while the checked-in renderer keeps widget structure
  identical across platforms.

The renderer handles headings, paragraphs, bullet lists, blockquotes, fenced
code, emphasis and inline code. Tables, images, HTML and advanced extensions
remain editable source text. This is an intentional minimal-editor boundary,
not a parser conformance claim.

## Required final evidence

Run the full matrix on an idle macOS arm64 16 GB machine and a Windows amd64 16
GB machine. Capture GPU model, OS build, toolchain versions, renderer flags,
three raw repetitions, and GUI frame samples. Only then assess the acceptance
threshold that MoUI and GPUI must not be more than 2x slower than Flutter or
Electron under matching conditions.
