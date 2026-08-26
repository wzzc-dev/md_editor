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
/// 2D affine transform.
///
/// Ported from upstream `zeno/src/geometry.rs` (Apache-2.0 OR MIT).
pub struct Transform {
  xx : Double
  xy : Double
  yx : Double
  yy : Double
  x : Double
  y : Double
}

///|
pub fn Transform::Transform(
  xx : Double,
  xy : Double,
  yx : Double,
  yy : Double,
  x : Double,
  y : Double,
) -> Transform {
  { xx, xy, yx, yy, x, y }
}

///|
pub fn Transform::identity() -> Transform {
  Transform(1.0, 0.0, 0.0, 1.0, 0.0, 0.0)
}

///|
pub fn Transform::translation(x : Double, y : Double) -> Transform {
  Transform(1.0, 0.0, 0.0, 1.0, x, y)
}

///|
pub fn Transform::translate(x : Double, y : Double) -> Transform {
  // Back-compat alias.
  Transform::translation(x, y)
}

///|
pub fn Transform::rotation(angle : Angle) -> Transform {
  let radians = angle.to_radians()
  let sinv = @coremath.sin(radians)
  let cosv = @coremath.cos(radians)
  { xx: cosv, xy: sinv, yx: -sinv, yy: cosv, x: 0.0, y: 0.0 }
}

///|
pub fn Transform::rotation_about(point : Point, angle : Angle) -> Transform {
  Transform::translation(point.x(), point.y())
  .then_rotate(angle)
  .then_translate(-point.x(), -point.y())
}

///|
pub fn Transform::scale(x : Double, y : Double) -> Transform {
  Transform(x, 0.0, 0.0, y, 0.0, 0.0)
}

///|
pub fn Transform::skew(x : Angle, y : Angle) -> Transform {
  {
    xx: 1.0,
    xy: @coremath.tan(y.to_radians()),
    yx: @coremath.tan(x.to_radians()),
    yy: 1.0,
    x: 0.0,
    y: 0.0,
  }
}

///|
fn combine(a : Transform, b : Transform) -> Transform {
  let xx = a.xx * b.xx + a.yx * b.xy
  let yx = a.xx * b.yx + a.yx * b.yy
  let xy = a.xy * b.xx + a.yy * b.xy
  let yy = a.xy * b.yx + a.yy * b.yy
  let x = a.x * b.xx + a.y * b.xy + b.x
  let y = a.x * b.yx + a.y * b.yy + b.y
  { xx, yx, xy, yy, x, y }
}

///|
/// Returns a new transform that represents the application of this transform
/// followed by other.
pub fn Transform::then(self : Transform, other : Transform) -> Transform {
  combine(self, other)
}

///|
/// Returns a new transform that represents a translation followed by this transform.
pub fn Transform::pre_translate(
  self : Transform,
  x : Double,
  y : Double,
) -> Transform {
  combine(Transform::translation(x, y), self)
}

///|
/// Returns a new transform that represents this transform followed by a translation.
pub fn Transform::then_translate(
  self : Transform,
  x : Double,
  y : Double,
) -> Transform {
  {
    xx: self.xx,
    xy: self.xy,
    yx: self.yx,
    yy: self.yy,
    x: self.x + x,
    y: self.y + y,
  }
}

///|
/// Returns a new transform that represents a rotation followed by this transform.
pub fn Transform::pre_rotate(self : Transform, angle : Angle) -> Transform {
  combine(Transform::rotation(angle), self)
}

///|
/// Returns a new transform that represents this transform followed by a rotation.
pub fn Transform::then_rotate(self : Transform, angle : Angle) -> Transform {
  combine(self, Transform::rotation(angle))
}

///|
/// Returns a new transform that represents a scale followed by this transform.
pub fn Transform::pre_scale(
  self : Transform,
  x : Double,
  y : Double,
) -> Transform {
  combine(Transform::scale(x, y), self)
}

///|
/// Returns a new transform that represents this transform followed by a scale.
pub fn Transform::then_scale(
  self : Transform,
  x : Double,
  y : Double,
) -> Transform {
  combine(self, Transform::scale(x, y))
}

///|
pub fn Transform::determinant(self : Transform) -> Double {
  self.xx * self.yy - self.yx * self.xy
}

///|
pub fn Transform::invert(self : Transform) -> Transform? {
  let det = self.determinant()
  if det == 0.0 || det.is_nan() || det.is_inf() {
    return None
  }
  let s = 1.0 / det
  let a = self.xx
  let b = self.xy
  let c = self.yx
  let d = self.yy
  let x = self.x
  let y = self.y
  Some({
    xx: d * s,
    xy: -b * s,
    yx: -c * s,
    yy: a * s,
    x: (b * y - d * x) * s,
    y: (c * x - a * y) * s,
  })
}

///|
pub fn Transform::transform_point(self : Transform, point : Point) -> Point {
  Vector(
    point.x() * self.xx + point.y() * self.yx + self.x,
    point.x() * self.xy + point.y() * self.yy + self.y,
  )
}

///|
pub fn Transform::transform_vector(self : Transform, vector : Vector) -> Vector {
  Vector(
    vector.x() * self.xx + vector.y() * self.yx,
    vector.x() * self.xy + vector.y() * self.yy,
  )
}
