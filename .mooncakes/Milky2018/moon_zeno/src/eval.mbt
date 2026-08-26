// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
/// Style/transform evaluation utilities (subset).
///
/// Ported from `zeno/src/path_data.rs` + `zeno/src/geometry.rs` eval helpers
/// (Apache-2.0 OR MIT).
priv struct BoundsBuilder {
  mut count : Int
  mut start : Point
  mut current : Point
  mut min : Point
  mut max : Point
}

///|
fn BoundsBuilder::BoundsBuilder() -> BoundsBuilder {
  {
    count: 0,
    start: Vector::zero(),
    current: Vector::zero(),
    min: Vector(1.0e308, 1.0e308),
    max: Vector(-1.0e308, -1.0e308),
  }
}

///|
fn BoundsBuilder::add(self : BoundsBuilder, p : Point) -> Unit {
  let x = p.x()
  let y = p.y()
  if x < self.min.x() {
    self.min = Vector(x, self.min.y())
  }
  if x > self.max.x() {
    self.max = Vector(x, self.max.y())
  }
  if y < self.min.y() {
    self.min = Vector(self.min.x(), y)
  }
  if y > self.max.y() {
    self.max = Vector(self.max.x(), y)
  }
  self.count = self.count + 1
}

///|
fn BoundsBuilder::build(self : BoundsBuilder) -> Bounds {
  if self.count != 0 {
    { min: self.min, max: self.max }
  } else {
    Bounds::default()
  }
}

///|
impl PathBuilder for BoundsBuilder with move_to(self, p) {
  self.add(p)
  self.start = p
  self.current = p
}

///|
impl PathBuilder for BoundsBuilder with line_to(self, p) {
  self.add(p)
  self.current = p
}

///|
impl PathBuilder for BoundsBuilder with quad_to(self, c, p) {
  self.add(c)
  self.add(p)
  self.current = p
}

///|
impl PathBuilder for BoundsBuilder with curve_to(self, c1, c2, p) {
  self.add(c1)
  self.add(c2)
  self.add(p)
  self.current = p
}

///|
impl PathBuilder for BoundsBuilder with close(self) {
  // Match SVG semantics: after close, the current point becomes the subpath start.
  self.current = self.start
}

///|
impl PathBuilder for BoundsBuilder with current_point(self) {
  self.current
}

///|
priv struct TransformSink {
  sink : &PathBuilder
  transform : Transform
}

///|
impl PathBuilder for TransformSink with current_point(self) {
  self.sink.current_point()
}

///|
impl PathBuilder for TransformSink with move_to(self, p) {
  self.sink.move_to(self.transform.transform_point(p))
}

///|
impl PathBuilder for TransformSink with line_to(self, p) {
  self.sink.line_to(self.transform.transform_point(p))
}

///|
impl PathBuilder for TransformSink with quad_to(self, c, p) {
  self.sink.quad_to(
    self.transform.transform_point(c),
    self.transform.transform_point(p),
  )
}

///|
impl PathBuilder for TransformSink with curve_to(self, c1, c2, p) {
  self.sink.curve_to(
    self.transform.transform_point(c1),
    self.transform.transform_point(c2),
    self.transform.transform_point(p),
  )
}

///|
impl PathBuilder for TransformSink with close(self) {
  self.sink.close()
}

///|
/// Applies the style and transform to the path and emits the result to the sink.
pub fn apply(
  data : &PathData,
  style : Style,
  transform : Transform?,
  sink : &PathBuilder,
) -> Fill {
  match style {
    Fill(fill) => {
      if transform is Some(t) {
        let ts = TransformSink::{ sink, transform: t }
        // `&Trait` in MoonBit is a trait constraint, not a borrow operator.
        // So we pass the value directly.
        data.copy_to(ts)
      } else {
        data.copy_to(sink)
      }
      fill
    }
    Stroke(stroke) => {
      fn map_commands(cmds : Iter[Command], t : Transform) -> Iter[Command] {
        let buf : Array[Command] = []
        let it = cmds
        while it.next() is Some(cmd) {
          buf.push(cmd.transform(t))
        }
        let mut i = 0
        Iter::new(fn() {
          if i < buf.length() {
            let v = buf[i]
            i = i + 1
            Some(v)
          } else {
            None
          }
        })
      }

      if transform is Some(t) {
        if stroke.scale {
          let ts = TransformSink::{ sink, transform: t }
          stroke_into(data.commands(), stroke, ts)
        } else {
          stroke_into(map_commands(data.commands(), t), stroke, sink)
        }
      } else {
        stroke_into(data.commands(), stroke, sink)
      }
      NonZero
    }
  }
}

///|
/// Computes the bounding box of the path (style/transform aware; fill-only accurate for now).
pub fn bounds(
  data : &PathData,
  style : Style,
  transform : Transform?,
) -> Bounds {
  let b = BoundsBuilder()
  apply(data, style, transform, b) |> ignore
  b.build()
}
