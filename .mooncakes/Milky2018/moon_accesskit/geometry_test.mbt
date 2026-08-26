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
fn abs_f64(x : Double) -> Double {
  if x < 0.0 {
    -x
  } else {
    x
  }
}

///|
fn close_f64(actual : Double, expected : Double, eps : Double) -> Bool {
  abs_f64(actual - expected) <= eps
}

///|
fn coeffs_close(
  actual : Array[Double],
  expected : Array[Double],
  eps : Double,
) -> Bool {
  if actual.length() != expected.length() {
    false
  } else {
    let mut ok = true
    for i in 0..<actual.length() {
      if !close_f64(actual[i], expected[i], eps) {
        ok = false
      }
    }
    ok
  }
}

///|
test "Affine scale should set diagonal coefficients" {
  let a = Affine::scale(2.0)
  @test.assert_eq(a.as_coeffs(), [2.0, 0.0, 0.0, 2.0, 0.0, 0.0])
}

///|
test "Affine scale_non_uniform should set diagonal coefficients" {
  let a = Affine::scale_non_uniform(2.0, 3.0)
  @test.assert_eq(a.as_coeffs(), [2.0, 0.0, 0.0, 3.0, 0.0, 0.0])
}

///|
test "Affine translate should set translation coefficients" {
  let a = Affine::translate(Vec2::Vec2(2.0, 3.0))
  @test.assert_eq(a.as_coeffs(), [1.0, 0.0, 0.0, 1.0, 2.0, 3.0])
}

///|
test "Affine determinant should match matrix determinant" {
  let a = Affine::Affine(2.0, 0.0, 0.0, 3.0, 4.0, 5.0)
  @test.assert_eq(a.determinant(), 6.0)
}

///|
test "Affine inverse should invert the transform" {
  let a = Affine::Affine(2.0, 0.0, 0.0, 3.0, 4.0, 5.0)
  let inv = a.inverse()
  assert_true(
    coeffs_close(
      inv.as_coeffs(),
      [0.5, 0.0, 0.0, 1.0 / 3.0, -2.0, -10.0 / 6.0],
      0.000000000001,
    ),
  )
  let roundtrip = a.mul(inv)
  assert_true(
    coeffs_close(
      roundtrip.as_coeffs(),
      [1.0, 0.0, 0.0, 1.0, 0.0, 0.0],
      0.000000000001,
    ),
  )
}

///|
test "Affine transform_point should apply matrix and translation" {
  let a = Affine::Affine(2.0, 0.0, 0.0, 3.0, 4.0, 5.0)
  let p = Point::Point(1.0, 2.0)
  @test.assert_eq(a.transform_point(p), Point::Point(6.0, 11.0))
}

///|
test "Rect abs should make width/height non-negative" {
  let r = Rect::Rect(5.0, 3.0, 1.0, -1.0)
  @test.assert_eq(r.abs(), Rect::Rect(1.0, -1.0, 5.0, 3.0))
}

///|
test "Rect from_points should normalize coordinates" {
  let r = Rect::from_points(Point::Point(5.0, 3.0), Point::Point(1.0, -1.0))
  @test.assert_eq(r, Rect::Rect(1.0, -1.0, 5.0, 3.0))
}

///|
test "Rect union should cover both rectangles" {
  let a = Rect::Rect(0.0, 0.0, 1.0, 1.0)
  let b = Rect::Rect(-2.0, 0.5, 0.5, 3.0)
  @test.assert_eq(a.union(b), Rect::Rect(-2.0, 0.0, 1.0, 3.0))
}

///|
test "Rect contains should treat x1/y1 as exclusive" {
  let r = Rect::Rect(0.0, 0.0, 2.0, 2.0)
  assert_true(r.contains(Point::Point(0.0, 0.0)))
  assert_true(r.contains(Point::Point(1.999, 1.999)))
  assert_false(r.contains(Point::Point(2.0, 1.0)))
  assert_false(r.contains(Point::Point(1.0, 2.0)))
}

///|
test "Rect from_origin_size should build from origin and size" {
  let r = Rect::from_origin_size(Point::Point(1.0, 2.0), Size::Size(3.0, 4.0))
  @test.assert_eq(r, Rect::Rect(1.0, 2.0, 4.0, 6.0))
  @test.assert_eq(r.origin(), Point::Point(1.0, 2.0))
  @test.assert_eq(r.size(), Size::Size(3.0, 4.0))
}

///|
test "Rect with_origin and with_size should preserve other component" {
  let r = Rect::from_origin_size(Point::Point(1.0, 2.0), Size::Size(3.0, 4.0))
  @test.assert_eq(
    r.with_origin(Point::Point(0.0, 0.0)),
    Rect::Rect(0.0, 0.0, 3.0, 4.0),
  )
  @test.assert_eq(
    r.with_size(Size::Size(10.0, 1.0)),
    Rect::Rect(1.0, 2.0, 11.0, 3.0),
  )
}

///|
test "Rect min/max helpers should use coordinate extrema" {
  let r = Rect::Rect(5.0, 3.0, 1.0, -1.0)
  @test.assert_eq(r.min_x(), 1.0)
  @test.assert_eq(r.max_x(), 5.0)
  @test.assert_eq(r.min_y(), -1.0)
  @test.assert_eq(r.max_y(), 3.0)
}

///|
test "Rect is_empty should only check area equals zero" {
  assert_true(Rect::Rect(0.0, 0.0, 0.0, 1.0).is_empty())
  assert_true(Rect::Rect(0.0, 0.0, 1.0, 0.0).is_empty())
  assert_false(Rect::Rect(1.0, 0.0, 0.0, 1.0).is_empty())
}

///|
test "Rect intersect should clamp to non-negative size" {
  let a = Rect::Rect(0.0, 0.0, 1.0, 1.0)
  let b = Rect::Rect(2.0, 2.0, 3.0, 3.0)
  let r = a.intersect(b)
  assert_true(r.is_empty())
  @test.assert_eq(r.width(), 0.0)
  @test.assert_eq(r.height(), 0.0)
}

///|
test "Rect union_pt should include a single point" {
  let r = Rect::zero().union_pt(Point::Point(2.0, 3.0))
  @test.assert_eq(r, Rect::Rect(0.0, 0.0, 2.0, 3.0))
}

///|
test "Rect area should multiply width by height" {
  @test.assert_eq(Rect::Rect(0.0, 0.0, 2.0, 3.0).area(), 6.0)
}

///|
test "Geometry ZERO/IDENTITY helpers should match Rust constants" {
  @test.assert_eq(Affine::identity().as_coeffs(), [1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
  @test.assert_eq(Affine::flip_x().as_coeffs(), [-1.0, 0.0, 0.0, 1.0, 0.0, 0.0])
  @test.assert_eq(Affine::flip_y().as_coeffs(), [1.0, 0.0, 0.0, -1.0, 0.0, 0.0])
  @test.assert_eq(Point::zero(), Point::Point(0.0, 0.0))
  @test.assert_eq(Point::origin(), Point::Point(0.0, 0.0))
  @test.assert_eq(Size::zero(), Size::Size(0.0, 0.0))
  @test.assert_eq(Vec2::zero(), Vec2::Vec2(0.0, 0.0))
  @test.assert_eq(Rect::zero(), Rect::Rect(0.0, 0.0, 0.0, 0.0))
}
