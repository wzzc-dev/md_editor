# Milky2018/moon_zeno

A low level 2D rasterization library with support for rendering paths of various 
styles into alpha or subpixel masks.

## What You Get

- SVG path parsing (`String` implements `PathData`)
- Path evaluation: `length`, `bounds`, `apply` (fill/stroke + optional `Transform`)
- Rendering: `Mask` (`Format::Alpha` / `Format::Subpixel`) and `HitTest`
- Styles: `Fill`, `Stroke`, `Style`, `Join`, `Cap`
- Traversal helpers: `Vertices`, `Walk`

The intended public surface is defined by `src/pkg.generated.mbti` and is kept
aligned with `zeno-reference/src/lib.rs` re-exports.

## PathBuilder Notes

Upstream `zeno` exposes `rel_*`, `arc_to`, and `add_*` as default methods on the
`PathBuilder` trait. MoonBit traits don't support default method bodies, so this
port keeps `PathBuilder` as a minimal sink interface and provides the defaults
as public helper functions:

- `rel_move_to`, `rel_line_to`, `rel_quad_to`, `rel_curve_to`, `rel_arc_to`
- `arc_to`
- `add_rect`, `add_round_rect`, `add_ellipse`, `add_circle`

This means custom sinks only need to implement:
`current_point`, `move_to`, `line_to`, `quad_to`, `curve_to`, `close`.

## PathData Notes

Besides `String` and `Array[Command]`, this port also provides:

- `pub impl PathData for (Array[Point], Array[Verb])`

which matches upstream’s common point+verb representation.

## Examples

```mbt
// SVG path data works directly because `String` implements `PathData`.
let svg : String = "M0,0 L3,4 Z"
let len = length(svg, None)

// Point+verb lists also implement `PathData`.
let data = (
  [@moon_zeno.Vector(1.0, 1.0), @moon_zeno.Vector(6.0, 1.0), @moon_zeno.Vector(3.5, 6.0)],
  [Verb::MoveTo, Verb::LineTo, Verb::LineTo, Verb::Close],
)

let (buf, placement) = @moon_zeno.Mask(data)
  .style(Style::Fill(Fill::NonZero))
  .size(8U, 8U)
  .render()

// `Array[Command]` is both a `PathData` and a `PathBuilder` sink.
let cmds : Array[Command] = []
add_rect(cmds, @moon_zeno.Vector(1.0, 2.0), 3.0, 4.0)
```

## Development

- `moon info && moon fmt`
- `moon check`
- `moon test`
