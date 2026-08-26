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
test "Transform::identity transforms points" {
  let p = @moon_zeno.Vector(1.0, 2.0)
  let t = Transform::identity()
  let q = t.transform_point(p)
  inspect(q.x(), content="1")
  inspect(q.y(), content="2")
}

///|
test "Bounds::from_points covers all points" {
  let b = Bounds::from_points([
    Vector(0.0, 0.0),
    Vector(2.0, 3.0),
    Vector(-1.0, 1.0),
  ])
  inspect(b.is_empty(), content="false")
}

///|
test "Bounds::contains uses strict interior checks" {
  let b = @moon_zeno.Bounds(Vector(0.0, 0.0), Vector(10.0, 10.0))
  inspect(b.contains(Vector(5.0, 5.0)), content="true")
  inspect(b.contains(Vector(0.0, 5.0)), content="false")
  inspect(b.contains(Vector(10.0, 5.0)), content="false")
}

///|
test "Angle converts degrees to radians" {
  let a = Angle::from_degrees(180.0).to_radians()
  inspect((a - @coremath.PI).abs() < 1.0e-12, content="true")
}

///|
test "Transform::invert round-trips a point" {
  let t = Transform::translation(3.0, 4.0).then_scale(2.0, 3.0)
  let p = @moon_zeno.Vector(1.0, 2.0)
  let q = t.transform_point(p)
  match t.invert() {
    Some(inv) => {
      let r = inv.transform_point(q)
      inspect(r.nearly_eq_by(p, 1.0e-9), content="true")
    }
    None => inspect(false, content="true")
  }
}

///|
test "PathBuilder builds rects and current_point handles Close" {
  let path : Array[Command] = []
  add_rect(path, Vector(1.0, 2.0), 3.0, 4.0)
  inspect(path.length(), content="5")
  let cur = PathBuilder::current_point(path)
  inspect(cur.x(), content="1")
  inspect(cur.y(), content="2")
}

///|
test "length sums segment lengths with optional transform" {
  let path : Array[Command] = []
  PathBuilder::move_to(path, Vector(0.0, 0.0))
  PathBuilder::line_to(path, Vector(3.0, 4.0))
  let len0 = length(path, None)
  inspect((len0 - 5.0).abs() < 1.0e-12, content="true")
  let len1 = length(path, Some(Transform::scale(2.0, 2.0)))
  inspect((len1 - 10.0).abs() < 1.0e-12, content="true")
}

///|
test "HitTest matches upstream docs examples" {
  let ht = @moon_zeno.HitTest("M10,0 10,10 20,10 20,0 Z")
  inspect(ht.hit(Vector(15.0, 5.0)), content="true")
  inspect(ht.hit(Vector(5.0, 5.0)), content="false")
  let ht2 = @moon_zeno.HitTest("M2.5,0 2.5,2 5,2 5,0 Z").threshold(0xFF)
  inspect(ht2.hit(Vector(2.0, 0.0)), content="false")
  let ht3 = @moon_zeno.HitTest("M2.5,0 2.5,2 5,2 5,0 Z").threshold(0)
  inspect(ht3.hit(Vector(2.0, 0.0)), content="true")
}

///|
test "Mask::render_into draws a filled triangle (alpha)" {
  let data = (
    [@moon_zeno.Vector(1.0, 1.0), Vector(6.0, 1.0), Vector(3.5, 6.0)],
    [Verb::MoveTo, LineTo, LineTo, Close],
  )
  let buffer : Array[Byte] = []
  for _ in 0..<(8 * 8) {
    buffer.push(0)
  }
  let placement = @moon_zeno.Mask(data)
    .style(Fill(NonZero))
    .size(8U, 8U)
    .render_into(buffer)
  inspect(placement.width, content="8")
  inspect(placement.height, content="8")
  inspect(buffer[0].to_int(), content="0")
  inspect(buffer[3 + 3 * 8].to_int() > 0, content="true")
}

///|
test "Mask::render_into draws a filled triangle (subpixel rgb)" {
  let data = (
    [@moon_zeno.Vector(1.0, 1.0), Vector(6.0, 1.0), Vector(3.5, 6.0)],
    [Verb::MoveTo, LineTo, LineTo, Close],
  )
  let buffer : Array[Byte] = []
  for _ in 0..<(8 * 8 * 4) {
    buffer.push(0)
  }
  let _placement = @moon_zeno.Mask(data)
    .style(Fill(NonZero))
    .format(Subpixel)
    .size(8U, 8U)
    .render_into(buffer)
  let i = (3 + 3 * 8) * 4
  let r = buffer[i + 0].to_int()
  let g = buffer[i + 1].to_int()
  let b = buffer[i + 2].to_int()
  inspect(r + g + b > 0, content="true")
}

///|
test "Mask::render allocates correct buffer size" {
  let data = (
    [@moon_zeno.Vector(1.0, 1.0), Vector(6.0, 1.0), Vector(3.5, 6.0)],
    [Verb::MoveTo, LineTo, LineTo, Close],
  )
  let (buf_a, placement_a) = @moon_zeno.Mask(data)
    .format(Alpha)
    .size(8U, 8U)
    .render()
  inspect(placement_a.width, content="8")
  inspect(buf_a.length(), content="64")
  let (buf_s, placement_s) = @moon_zeno.Mask(data)
    .format(Subpixel)
    .size(8U, 8U)
    .render()
  inspect(placement_s.height, content="8")
  inspect(buf_s.length(), content="256")
}

///|
test "Stroke: dashed triangle matches upstream sample points" {
  let data = (
    [@moon_zeno.Vector(8.0, 56.0), Vector(32.0, 8.0), Vector(56.0, 56.0)],
    [Verb::MoveTo, LineTo, LineTo, Close],
  )
  let buf : Array[Byte] = []
  for _i in 0..<(64 * 64) {
    buf.push(0)
  }
  let stroke = @moon_zeno.Stroke::Stroke(4.0)
    .join(Round)
    .cap(Round)
    .dash([10.0, 12.0, 0.0], 0.0)
  let placement = @moon_zeno.Mask(data)
    .style(Stroke(stroke))
    .size(64U, 64U)
    .render_into(buf)
  inspect(placement.left, content="0")
  inspect(placement.top, content="0")
  inspect(placement.width, content="64")
  inspect(placement.height, content="64")
  fn at(buf : Array[Byte], x : Int, y : Int) -> Int {
    buf[y * 64 + x].to_int()
  }

  inspect(at(buf, 32, 8), content="255")
  inspect(at(buf, 32, 32), content="0")
  inspect(at(buf, 8, 56), content="255")
  inspect(at(buf, 56, 56), content="0")
  inspect(at(buf, 20, 40), content="0")
  inspect(at(buf, 44, 40), content="0")
  let mut sum = 0
  for b in buf {
    sum = sum + b.to_int()
  }
  // NOTE: Upstream uses f32 math; MoonBit uses Double, which can cause tiny AA
  // differences in aggregate sums. We still pin the output to keep this port
  // deterministic.
  inspect(sum, content="100052")
}
