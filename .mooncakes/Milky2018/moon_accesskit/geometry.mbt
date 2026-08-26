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
pub(all) struct Affine {
  a : Double
  b : Double
  c : Double
  d : Double
  e : Double
  f : Double
} derive(Eq, Debug)

///|
pub fn Affine::Affine(
  a : Double,
  b : Double,
  c : Double,
  d : Double,
  e : Double,
  f : Double,
) -> Affine {
  { a, b, c, d, e, f }
}

///|
pub fn Affine::scale(s : Double) -> Affine {
  Affine::Affine(s, 0.0, 0.0, s, 0.0, 0.0)
}

///|
pub fn Affine::identity() -> Affine {
  Affine::scale(1.0)
}

///|
pub fn Affine::flip_y() -> Affine {
  Affine::Affine(1.0, 0.0, 0.0, -1.0, 0.0, 0.0)
}

///|
pub fn Affine::flip_x() -> Affine {
  Affine::Affine(-1.0, 0.0, 0.0, 1.0, 0.0, 0.0)
}

///|
pub impl ToJson for Affine with to_json(self : Affine) -> Json {
  Json::array([
    self.a.to_json(),
    self.b.to_json(),
    self.c.to_json(),
    self.d.to_json(),
    self.e.to_json(),
    self.f.to_json(),
  ])
}

///|
pub impl @json.FromJson for Affine with from_json(json, path) {
  guard json is Array(arr) else {
    json_decode_error(path, "Affine::from_json: expected array")
  }
  if arr.length() != 6 {
    json_decode_error(path, "Affine::from_json: expected 6 elements")
  }
  let a : Double = @json.FromJson::from_json(arr[0], path.add_index(0))
  let b : Double = @json.FromJson::from_json(arr[1], path.add_index(1))
  let c : Double = @json.FromJson::from_json(arr[2], path.add_index(2))
  let d : Double = @json.FromJson::from_json(arr[3], path.add_index(3))
  let e : Double = @json.FromJson::from_json(arr[4], path.add_index(4))
  let f : Double = @json.FromJson::from_json(arr[5], path.add_index(5))
  Affine::Affine(a, b, c, d, e, f)
}

///|
pub fn Affine::scale_non_uniform(sx : Double, sy : Double) -> Affine {
  Affine::Affine(sx, 0.0, 0.0, sy, 0.0, 0.0)
}

///|
pub fn Affine::translate(v : Vec2) -> Affine {
  Affine::Affine(1.0, 0.0, 0.0, 1.0, v.x, v.y)
}

///|
pub fn Affine::map_unit_square(rect : Rect) -> Affine {
  Affine::Affine(rect.width(), 0.0, 0.0, rect.height(), rect.x0, rect.y0)
}

///|
pub fn Affine::as_coeffs(self : Affine) -> Array[Double] {
  [self.a, self.b, self.c, self.d, self.e, self.f]
}

///|
pub fn Affine::determinant(self : Affine) -> Double {
  self.a * self.d - self.b * self.c
}

///|
pub fn Affine::inverse(self : Affine) -> Affine {
  let inv_det = 1.0 / self.determinant()
  Affine::Affine(
    inv_det * self.d,
    -inv_det * self.b,
    -inv_det * self.c,
    inv_det * self.a,
    inv_det * (self.c * self.f - self.d * self.e),
    inv_det * (self.b * self.e - self.a * self.f),
  )
}

///|
pub fn Affine::mul(self : Affine, other : Affine) -> Affine {
  Affine::Affine(
    self.a * other.a + self.c * other.b,
    self.b * other.a + self.d * other.b,
    self.a * other.c + self.c * other.d,
    self.b * other.c + self.d * other.d,
    self.a * other.e + self.c * other.f + self.e,
    self.b * other.e + self.d * other.f + self.f,
  )
}

///|
pub fn Affine::transform_point(self : Affine, other : Point) -> Point {
  Point::Point(
    self.a * other.x + self.c * other.y + self.e,
    self.b * other.x + self.d * other.y + self.f,
  )
}

///|
pub fn Affine::transform_rect_bbox(self : Affine, rect : Rect) -> Rect {
  let p00 = self.transform_point(Point::Point(rect.x0, rect.y0))
  let p01 = self.transform_point(Point::Point(rect.x0, rect.y1))
  let p10 = self.transform_point(Point::Point(rect.x1, rect.y0))
  let p11 = self.transform_point(Point::Point(rect.x1, rect.y1))
  Rect::from_points(p00, p01).union(Rect::from_points(p10, p11))
}

///|
pub fn Affine::is_nan(self : Affine) -> Bool {
  self.a.is_nan() ||
  self.b.is_nan() ||
  self.c.is_nan() ||
  self.d.is_nan() ||
  self.e.is_nan() ||
  self.f.is_nan()
}

///|
pub fn Affine::is_finite(self : Affine) -> Bool {
  !(self.a.is_nan() ||
  self.a.is_inf() ||
  self.b.is_nan() ||
  self.b.is_inf() ||
  self.c.is_nan() ||
  self.c.is_inf() ||
  self.d.is_nan() ||
  self.d.is_inf() ||
  self.e.is_nan() ||
  self.e.is_inf() ||
  self.f.is_nan() ||
  self.f.is_inf())
}

///|
pub(all) struct Point {
  x : Double
  y : Double
} derive(Eq, Debug)

///|
pub fn Point::Point(x : Double, y : Double) -> Point {
  { x, y }
}

///|
pub fn Point::zero() -> Point {
  Point::Point(0.0, 0.0)
}

///|
pub fn Point::origin() -> Point {
  Point::Point(0.0, 0.0)
}

///|
pub fn Point::to_vec2(self : Point) -> Vec2 {
  Vec2::Vec2(self.x, self.y)
}

///|
pub(all) struct Rect {
  x0 : Double
  y0 : Double
  x1 : Double
  y1 : Double
} derive(Eq, Debug)

///|
pub fn Rect::Rect(x0 : Double, y0 : Double, x1 : Double, y1 : Double) -> Rect {
  { x0, y0, x1, y1 }
}

///|
pub fn Rect::zero() -> Rect {
  Rect::Rect(0.0, 0.0, 0.0, 0.0)
}

///|
fn min_f64(a : Double, b : Double) -> Double {
  if a < b {
    a
  } else {
    b
  }
}

///|
fn max_f64(a : Double, b : Double) -> Double {
  if a > b {
    a
  } else {
    b
  }
}

///|
pub fn Rect::from_points(p0 : Point, p1 : Point) -> Rect {
  Rect::Rect(p0.x, p0.y, p1.x, p1.y).abs()
}

///|
pub fn Rect::from_origin_size(origin : Point, size : Size) -> Rect {
  Rect::from_points(
    origin,
    Point::Point(origin.x + size.width, origin.y + size.height),
  )
}

///|
pub fn Rect::with_origin(self : Rect, origin : Point) -> Rect {
  Rect::from_origin_size(origin, self.size())
}

///|
pub fn Rect::with_size(self : Rect, size : Size) -> Rect {
  Rect::from_origin_size(self.origin(), size)
}

///|
pub fn Rect::width(self : Rect) -> Double {
  self.x1 - self.x0
}

///|
pub fn Rect::height(self : Rect) -> Double {
  self.y1 - self.y0
}

///|
pub fn Rect::min_x(self : Rect) -> Double {
  min_f64(self.x0, self.x1)
}

///|
pub fn Rect::max_x(self : Rect) -> Double {
  max_f64(self.x0, self.x1)
}

///|
pub fn Rect::min_y(self : Rect) -> Double {
  min_f64(self.y0, self.y1)
}

///|
pub fn Rect::max_y(self : Rect) -> Double {
  max_f64(self.y0, self.y1)
}

///|
pub fn Rect::origin(self : Rect) -> Point {
  Point::Point(self.x0, self.y0)
}

///|
pub fn Rect::size(self : Rect) -> Size {
  Size::Size(self.width(), self.height())
}

///|
pub fn Rect::abs(self : Rect) -> Rect {
  Rect::Rect(
    min_f64(self.x0, self.x1),
    min_f64(self.y0, self.y1),
    max_f64(self.x0, self.x1),
    max_f64(self.y0, self.y1),
  )
}

///|
pub fn Rect::union(self : Rect, other : Rect) -> Rect {
  Rect::Rect(
    min_f64(self.x0, other.x0),
    min_f64(self.y0, other.y0),
    max_f64(self.x1, other.x1),
    max_f64(self.y1, other.y1),
  )
}

///|
pub fn Rect::union_pt(self : Rect, pt : Point) -> Rect {
  Rect::Rect(
    min_f64(self.x0, pt.x),
    min_f64(self.y0, pt.y),
    max_f64(self.x1, pt.x),
    max_f64(self.y1, pt.y),
  )
}

///|
pub fn Rect::intersect(self : Rect, other : Rect) -> Rect {
  let x0 = max_f64(self.x0, other.x0)
  let y0 = max_f64(self.y0, other.y0)
  let x1 = min_f64(self.x1, other.x1)
  let y1 = min_f64(self.y1, other.y1)
  Rect::Rect(x0, y0, max_f64(x1, x0), max_f64(y1, y0))
}

///|
pub fn Rect::area(self : Rect) -> Double {
  self.width() * self.height()
}

///|
pub fn Rect::is_empty(self : Rect) -> Bool {
  self.area() == 0.0
}

///|
pub fn Rect::contains(self : Rect, point : Point) -> Bool {
  point.x >= self.x0 &&
  point.x < self.x1 &&
  point.y >= self.y0 &&
  point.y < self.y1
}

///|
pub(all) struct Size {
  width : Double
  height : Double
} derive(Eq, Debug)

///|
pub fn Size::Size(width : Double, height : Double) -> Size {
  { width, height }
}

///|
pub fn Size::zero() -> Size {
  Size::Size(0.0, 0.0)
}

///|
pub fn Size::to_vec2(self : Size) -> Vec2 {
  Vec2::Vec2(self.width, self.height)
}

///|
pub(all) struct Vec2 {
  x : Double
  y : Double
} derive(Eq, Debug)

///|
pub fn Vec2::Vec2(x : Double, y : Double) -> Vec2 {
  { x, y }
}

///|
pub fn Vec2::zero() -> Vec2 {
  Vec2::Vec2(0.0, 0.0)
}

///|
pub fn Vec2::to_point(self : Vec2) -> Point {
  Point::Point(self.x, self.y)
}

///|
pub fn Vec2::to_size(self : Vec2) -> Size {
  Size::Size(self.x, self.y)
}

///|
pub impl Show for Affine with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for Point with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for Rect with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for Size with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for Vec2 with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl ToJson for Point with to_json(self : Point) -> Json {
  Json::object({ "x": self.x.to_json(), "y": self.y.to_json() })
}

///|
pub impl @json.FromJson for Point with from_json(json, path) {
  guard json is Object(obj) else {
    json_decode_error(path, "Point::from_json: expected object")
  }
  for key, _ in obj {
    if key != "x" && key != "y" {
      json_decode_error(path, "Point::from_json: unknown field \{key}")
    }
  }
  guard obj.get("x") is Some(x_json) else {
    json_decode_error(path, "Point::from_json: missing field x")
  }
  guard obj.get("y") is Some(y_json) else {
    json_decode_error(path, "Point::from_json: missing field y")
  }
  let x : Double = @json.FromJson::from_json(x_json, path.add_key("x"))
  let y : Double = @json.FromJson::from_json(y_json, path.add_key("y"))
  Point::Point(x, y)
}

///|
pub impl ToJson for Rect with to_json(self : Rect) -> Json {
  Json::object({
    "x0": self.x0.to_json(),
    "y0": self.y0.to_json(),
    "x1": self.x1.to_json(),
    "y1": self.y1.to_json(),
  })
}

///|
pub impl @json.FromJson for Rect with from_json(json, path) {
  guard json is Object(obj) else {
    json_decode_error(path, "Rect::from_json: expected object")
  }
  for key, _ in obj {
    if key != "x0" && key != "y0" && key != "x1" && key != "y1" {
      json_decode_error(path, "Rect::from_json: unknown field \{key}")
    }
  }
  guard obj.get("x0") is Some(x0_json) else {
    json_decode_error(path, "Rect::from_json: missing field x0")
  }
  guard obj.get("y0") is Some(y0_json) else {
    json_decode_error(path, "Rect::from_json: missing field y0")
  }
  guard obj.get("x1") is Some(x1_json) else {
    json_decode_error(path, "Rect::from_json: missing field x1")
  }
  guard obj.get("y1") is Some(y1_json) else {
    json_decode_error(path, "Rect::from_json: missing field y1")
  }
  let x0 : Double = @json.FromJson::from_json(x0_json, path.add_key("x0"))
  let y0 : Double = @json.FromJson::from_json(y0_json, path.add_key("y0"))
  let x1 : Double = @json.FromJson::from_json(x1_json, path.add_key("x1"))
  let y1 : Double = @json.FromJson::from_json(y1_json, path.add_key("y1"))
  Rect::Rect(x0, y0, x1, y1)
}

///|
pub impl ToJson for Size with to_json(self : Size) -> Json {
  Json::object({
    "width": self.width.to_json(),
    "height": self.height.to_json(),
  })
}

///|
pub impl @json.FromJson for Size with from_json(json, path) {
  guard json is Object(obj) else {
    json_decode_error(path, "Size::from_json: expected object")
  }
  for key, _ in obj {
    if key != "width" && key != "height" {
      json_decode_error(path, "Size::from_json: unknown field \{key}")
    }
  }
  guard obj.get("width") is Some(w_json) else {
    json_decode_error(path, "Size::from_json: missing field width")
  }
  guard obj.get("height") is Some(h_json) else {
    json_decode_error(path, "Size::from_json: missing field height")
  }
  let width : Double = @json.FromJson::from_json(w_json, path.add_key("width"))
  let height : Double = @json.FromJson::from_json(
    h_json,
    path.add_key("height"),
  )
  Size::Size(width, height)
}

///|
pub impl ToJson for Vec2 with to_json(self : Vec2) -> Json {
  Json::object({ "x": self.x.to_json(), "y": self.y.to_json() })
}

///|
pub impl @json.FromJson for Vec2 with from_json(json, path) {
  guard json is Object(obj) else {
    json_decode_error(path, "Vec2::from_json: expected object")
  }
  for key, _ in obj {
    if key != "x" && key != "y" {
      json_decode_error(path, "Vec2::from_json: unknown field \{key}")
    }
  }
  guard obj.get("x") is Some(x_json) else {
    json_decode_error(path, "Vec2::from_json: missing field x")
  }
  guard obj.get("y") is Some(y_json) else {
    json_decode_error(path, "Vec2::from_json: missing field y")
  }
  let x : Double = @json.FromJson::from_json(x_json, path.add_key("x"))
  let y : Double = @json.FromJson::from_json(y_json, path.add_key("y"))
  Vec2::Vec2(x, y)
}
