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
/// Path styles.
///
/// Ported from upstream `zeno/src/style.rs` (Apache-2.0 OR MIT).
pub(all) enum Fill {
  NonZero
  EvenOdd
}

///|
pub(all) enum Join {
  Bevel
  Miter
  Round
}

///|
pub(all) enum Cap {
  Butt
  Square
  Round
}

///|
pub struct Stroke {
  mut width : Double
  mut join : Join
  mut miter_limit : Double
  mut start_cap : Cap
  mut end_cap : Cap
  mut dashes : Array[Double]
  mut offset : Double
  mut scale : Bool
}

///|
pub fn Stroke::default() -> Stroke {
  {
    width: 1.0,
    join: Miter,
    miter_limit: 4.0,
    start_cap: Butt,
    end_cap: Butt,
    dashes: [],
    offset: 0.0,
    scale: true,
  }
}

///|
pub fn Stroke::Stroke(width : Double) -> Stroke {
  let s = Stroke::default()
  s.width = width
  s
}

///|
pub fn Stroke::width(self : Stroke, width : Double) -> Stroke {
  self.width = width
  self
}

///|
pub fn Stroke::join(self : Stroke, join : Join) -> Stroke {
  self.join = join
  self
}

///|
pub fn Stroke::miter_limit(self : Stroke, limit : Double) -> Stroke {
  self.miter_limit = limit
  self
}

///|
pub fn Stroke::cap(self : Stroke, cap : Cap) -> Stroke {
  self.start_cap = cap
  self.end_cap = cap
  self
}

///|
pub fn Stroke::caps(self : Stroke, start : Cap, end : Cap) -> Stroke {
  self.start_cap = start
  self.end_cap = end
  self
}

///|
pub fn Stroke::dash(
  self : Stroke,
  dashes : Array[Double],
  offset : Double,
) -> Stroke {
  self.dashes = dashes
  self.offset = offset
  self
}

///|
pub fn Stroke::scale(self : Stroke, scale : Bool) -> Stroke {
  self.scale = scale
  self
}

///|
pub(all) enum Style {
  Fill(Fill)
  Stroke(Stroke)
}

///|
pub fn Style::default() -> Style {
  Fill(NonZero)
}

///|
pub fn Style::is_stroke(self : Style) -> Bool {
  match self {
    Stroke(_) => true
    _ => false
  }
}

///|
test "Stroke builder mutates fields" {
  let s = Stroke::Stroke(2.0)
    .join(Round)
    .cap(Square)
    .dash([1.0, 2.0], 0.5)
    .scale(false)
  inspect(s.width, content="2")
  inspect(s.scale, content="false")
  debug_inspect(s.dashes, content="[1, 2]")
}
