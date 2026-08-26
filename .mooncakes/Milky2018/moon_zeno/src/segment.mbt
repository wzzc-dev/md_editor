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
/// Path segmentation.
///
/// Ported from upstream `zeno/src/segment.rs` (Apache-2.0 OR MIT).

// This large epsilon trades fidelity for performance, visual continuity
// and numeric stability.
const MERGE_EPSILON : Double = 0.01

///|
const SQRT_2 : Double = 1.4142135623730951

///|
fn sat01(x : Double) -> Double {
  if x < 0.0 {
    0.0
  } else if x > 1.0 {
    1.0
  } else {
    x
  }
}

///|
fn sort3(ts : Array[Double]) -> Unit {
  if ts[0] > ts[1] {
    let tmp = ts[0]
    ts[0] = ts[1]
    ts[1] = tmp
  }
  if ts[1] > ts[2] {
    let tmp = ts[1]
    ts[1] = ts[2]
    ts[2] = tmp
  }
  if ts[0] > ts[1] {
    let tmp = ts[0]
    ts[0] = ts[1]
    ts[1] = tmp
  }
}

///|
/// Represents the time parameter for a specific distance along a segment.
priv struct SegmentTime {
  distance : Double
  time : Double
}

///|
/// Line segment.
priv struct Line {
  a : Point
  b : Point
}

///|
fn Line::Line(a : Point, b : Point) -> Line {
  { a, b }
}

///|
fn Line::length(self : Line) -> Double {
  (self.b - self.a).length()
}

///|
fn Line::slice(self : Line, start : Double, end : Double) -> Line {
  let dir = self.b - self.a
  Line(self.a + dir.scale(start), self.a + dir.scale(end))
}

///|
fn Line::time(self : Line, distance : Double) -> SegmentTime {
  let len = (self.b - self.a).length()
  if distance > len {
    return { distance: len, time: 1.0 }
  }
  { distance, time: distance / len }
}

///|
fn Line::reverse(self : Line) -> Line {
  Line(self.b, self.a)
}

///|
/// Cubic bezier curve.
priv struct Curve {
  a : Point
  b : Point
  c : Point
  d : Point
}

///|
fn Curve::default() -> Curve {
  { a: Vector::zero(), b: Vector::zero(), c: Vector::zero(), d: Vector::zero() }
}

///|
fn Curve::Curve(a : Point, b : Point, c : Point, d : Point) -> Curve {
  { a, b, c, d }
}

///|
fn Curve::from_quadratic(a : Point, b : Point, c : Point) -> Curve {
  {
    a,
    b: Vector(
      a.x() + 2.0 / 3.0 * (b.x() - a.x()),
      a.y() + 2.0 / 3.0 * (b.y() - a.y()),
    ),
    c: Vector(
      c.x() + 2.0 / 3.0 * (b.x() - c.x()),
      c.y() + 2.0 / 3.0 * (b.y() - c.y()),
    ),
    d: c,
  }
}

///|
fn Curve::evaluate(self : Curve, time : Double) -> Point {
  let t = time
  let t0 = 1.0 - t
  self.a.scale(t0 * t0 * t0) +
  self.b.scale(3.0 * t0 * t0 * t) +
  self.c.scale(3.0 * t0 * t * t) +
  self.d.scale(t * t * t)
}

///|
fn Curve::length(self : Curve) -> Double {
  let mut len = 0.0
  let mut prev = self.a
  let steps = 64
  let step = 1.0 / steps.to_double()
  let mut t = 0.0
  for _i in 0..<(steps + 1) {
    t = t + step
    let next = self.evaluate(t)
    len = len + (next - prev).length()
    prev = next
  }
  len
}

///|
fn Curve::slice(self : Curve, start : Double, end : Double) -> Curve {
  let t0 = start
  let t1 = end
  let u0 = 1.0 - t0
  let u1 = 1.0 - t1
  let v0 = self.a
  let v1 = self.b
  let v2 = self.c
  let v3 = self.d
  Curve(
    v0.scale(u0 * u0 * u0) +
    v1.scale(t0 * u0 * u0 + u0 * t0 * u0 + u0 * u0 * t0) +
    v2.scale(t0 * t0 * u0 + u0 * t0 * t0 + t0 * u0 * t0) +
    v3.scale(t0 * t0 * t0),
    v0.scale(u0 * u0 * u1) +
    v1.scale(t0 * u0 * u1 + u0 * t0 * u1 + u0 * u0 * t1) +
    v2.scale(t0 * t0 * u1 + u0 * t0 * t1 + t0 * u0 * t1) +
    v3.scale(t0 * t0 * t1),
    v0.scale(u0 * u1 * u1) +
    v1.scale(t0 * u1 * u1 + u0 * t1 * u1 + u0 * u1 * t1) +
    v2.scale(t0 * t1 * u1 + u0 * t1 * t1 + t0 * u1 * t1) +
    v3.scale(t0 * t1 * t1),
    v0.scale(u1 * u1 * u1) +
    v1.scale(t1 * u1 * u1 + u1 * t1 * u1 + u1 * u1 * t1) +
    v2.scale(t1 * t1 * u1 + u1 * t1 * t1 + t1 * u1 * t1) +
    v3.scale(t1 * t1 * t1),
  )
}

///|
fn Curve::reverse(self : Curve) -> Curve {
  Curve(self.d, self.c, self.b, self.a)
}

///|
fn Curve::is_line(self : Curve, tolerance : Double) -> Bool {
  let degen_ab = self.a.nearly_eq_by(self.b, tolerance)
  let degen_bc = self.b.nearly_eq_by(self.c, tolerance)
  let degen_cd = self.c.nearly_eq_by(self.d, tolerance)
  (if degen_ab { 1 } else { 0 }) +
  (if degen_bc { 1 } else { 0 }) +
  (if degen_cd { 1 } else { 0 }) >=
  2
}

///|
fn Curve::to_segment(self : Curve, id : SegmentId) -> Segment? {
  if self.is_line(MERGE_EPSILON) {
    if self.a.nearly_eq_by(self.d, MERGE_EPSILON) {
      None
    } else {
      Some(Line(id, Line(self.a, self.d)))
    }
  } else {
    Some(Curve(id, self))
  }
}

///|
fn Curve::split(self : Curve, t : Double) -> (Curve, Curve) {
  (self.slice(0.0, t), self.slice(t, 1.0))
}

///|
fn Curve::time_impl(
  self : Curve,
  distance : Double,
  tolerance : Double,
  t : Double,
  level : Int,
) -> (Double, Double) {
  if level < 5 && self.too_curvy(tolerance) {
    let c0 = self.slice(0.0, 0.5)
    let (dist0, t0) = c0.time_impl(distance, tolerance, t * 0.5, level + 1)
    if dist0 < distance {
      let c1 = self.slice(0.5, 1.0)
      let (dist1, t1) = c1.time_impl(
        distance - dist0,
        tolerance,
        t * 0.5,
        level + 1,
      )
      (dist0 + dist1, t0 + t1)
    } else {
      (dist0, t0)
    }
  } else {
    let dist = (self.d - self.a).length()
    if dist >= distance {
      let s = distance / dist
      (distance, t * s)
    } else {
      (dist, t)
    }
  }
}

///|
fn Curve::time(
  self : Curve,
  distance : Double,
  tolerance : Double,
) -> SegmentTime {
  let (d, t) = self.time_impl(distance, tolerance, 1.0, 0)
  { distance: d, time: t }
}

///|
fn Curve::max_curvature(self : Curve, ts : Array[Double]) -> Int {
  let comps_x = [self.a.x(), self.b.x(), self.c.x(), self.d.x()]
  let comps_y = [self.a.y(), self.b.y(), self.c.y(), self.d.y()]
  fn get_coeffs(src : Array[Double]) -> Array[Double] {
    let a = src[1] - src[0]
    let b = src[2] - 2.0 * src[1] + src[0]
    let c = src[3] + 3.0 * (src[1] - src[2]) - src[0]
    [c * c, 3.0 * b * c, 2.0 * b * b + c * a, a * b]
  }

  let coeffs = get_coeffs(comps_x)
  let coeffs_y = get_coeffs(comps_y)
  for i in 0..<4 {
    coeffs[i] = coeffs[i] + coeffs_y[i]
  }
  Curve::solve(coeffs, ts)
}

///|
fn Curve::solve(coeff : Array[Double], ts : Array[Double]) -> Int {
  let i = 1.0 / coeff[0]
  let a0 = coeff[1] * i
  let b0 = coeff[2] * i
  let c0 = coeff[3] * i
  let q = (a0 * a0 - b0 * 3.0) / 9.0
  let r = (2.0 * a0 * a0 * a0 - 9.0 * a0 * b0 + 27.0 * c0) / 54.0
  let q3 = q * q * q
  let r2_sub_q3 = r * r - q3
  let adiv3 = a0 / 3.0
  if r2_sub_q3 < 0.0 {
    let theta = @coremath.acos(sat01(r / q3.sqrt()))
    let neg2_root_q = -2.0 * q.sqrt()
    ts[0] = sat01(neg2_root_q * @coremath.cos(theta / 3.0) - adiv3)
    ts[1] = sat01(
      neg2_root_q * @coremath.cos((theta + 2.0 * @coremath.PI) / 3.0) - adiv3,
    )
    ts[2] = sat01(
      neg2_root_q * @coremath.cos((theta - 2.0 * @coremath.PI) / 3.0) - adiv3,
    )
    sort3(ts)
    let mut count = 3
    if ts[0] == ts[1] {
      ts[1] = ts[2]
      count = count - 1
    }
    if ts[1] == ts[2] {
      count = count - 1
    }
    count
  } else {
    let mut a = r.abs() + r2_sub_q3.sqrt()
    // `powf(1/3)` in upstream.
    a = @coremath.pow(a, 0.3333333)
    if r > 0.0 {
      a = -a
    }
    if a != 0.0 {
      a = a + q / a
    }
    ts[0] = sat01(a - adiv3)
    1
  }
}

///|
fn Curve::too_curvy(self : Curve, tolerance : Double) -> Bool {
  (2.0 * self.d.x() - 3.0 * self.c.x() + self.a.x()).abs() > tolerance ||
  (2.0 * self.d.y() - 3.0 * self.c.y() + self.a.y()).abs() > tolerance ||
  (self.d.x() - 3.0 * self.b.x() + 2.0 * self.a.x()).abs() > tolerance ||
  (self.d.y() - 3.0 * self.b.y() + 2.0 * self.a.y()).abs() > tolerance
}

///|
fn Curve::needs_split(self : Curve) -> Bool {
  if self.b.nearly_eq_by(self.c, MERGE_EPSILON) {
    return true
  }
  let normal_ab = normal(self.a, self.b)
  let normal_bc = normal(self.b, self.c)
  fn too_curvy_norm(n0 : Vector, n1 : Vector) -> Bool {
    let flat_enough = SQRT_2 / 2.0 + 1.0 / 10.0
    n0.dot(n1) <= flat_enough
  }

  too_curvy_norm(normal_ab, normal_bc) ||
  too_curvy_norm(normal_bc, normal(self.c, self.d))
}

///|
fn Curve::split_at_max_curvature(self : Curve, out : Array[Curve]) -> Int {
  let tmp : Array[Double] = [0.0, 0.0, 0.0]
  let count1 = self.max_curvature(tmp)
  let mut count = 0
  let ts : Array[Double] = [0.0, 0.0, 0.0, 0.0]
  for i in 0..<count1 {
    let t = tmp[i]
    if t > 0.0 && t < 1.0 {
      ts[count] = t
      count = count + 1
    }
  }
  if count == 0 {
    out[0] = self
  } else {
    let mut i = 0
    let mut last_t = 0.0
    for j in 0..<count {
      let t = ts[j]
      out[i] = self.slice(last_t, t)
      i = i + 1
      last_t = t
    }
    out[i] = self.slice(last_t, 1.0)
  }
  count + 1
}

///|
/// Marker that allows regrouping of previously split segments due to simplification.
type SegmentId = Int

///|
/// Segment of a path.
priv enum Segment {
  Line(SegmentId, Line)
  Curve(SegmentId, Curve)
  End(Bool)
}

///|
fn Segment::default() -> Segment {
  End(false)
}

///|
fn Segment::length(self : Segment) -> Double {
  match self {
    Line(_, l) => l.length()
    Curve(_, c) => c.length()
    End(_) => 0.0
  }
}

///|
fn Segment::slice(self : Segment, start : Double, end : Double) -> Segment {
  match self {
    Line(id, l) => Line(id, l.slice(start, end))
    Curve(id, c) => Curve(id, c.slice(start, end))
    End(closed) => End(closed)
  }
}

///|
fn Segment::reverse(self : Segment) -> Segment {
  match self {
    Line(id, l) => Line(id, l.reverse())
    Curve(id, c) => Curve(id, c.reverse())
    End(closed) => End(closed)
  }
}

///|
fn Segment::time(
  self : Segment,
  distance : Double,
  tolerance : Double,
) -> SegmentTime {
  match self {
    Line(_, l) => l.time(distance)
    Curve(_, c) => c.time(distance, tolerance)
    End(_) => { distance: 0.0, time: 0.0 }
  }
}

///|
fn Segment::point_normal(self : Segment, time : Double) -> (Point, Vector) {
  match self {
    Line(_, l) => {
      let dir = l.b - l.a
      let p = l.a + dir.scale(time)
      let n = normal(l.a, l.b)
      (p, n)
    }
    Curve(_, c) => {
      let p = c.evaluate(time)
      let a = c.evaluate(time - 0.05)
      let b = c.evaluate(time + 0.05)
      let n = normal(a, b)
      (p, n)
    }
    End(_) => (Vector::zero(), Vector::zero())
  }
}

///|
/// Creates a segment iterator from a command iterator, optionally producing simplified curves.
fn segments(commands : Iter[Command], simplify_curves : Bool) -> Segments {
  let buf : Array[Command] = []
  let it = commands
  while it.next() is Some(cmd) {
    buf.push(cmd)
  }
  Segments(simplify_curves, buf)
}

///|
/// Iterator over path segments.
priv struct Segments {
  commands : Array[Command]
  mut index : Int
  mut start : Vector
  mut prev : Vector
  mut close : Bool
  split : Bool
  splits : Array[Curve]
  mut split_count : Int
  mut split_index : Int
  mut last_was_end : Bool
  mut id : SegmentId
  mut count : UInt
}

///|
fn Segments::Segments(split : Bool, commands : Array[Command]) -> Segments {
  let splits : Array[Curve] = []
  for _i in 0..<16 {
    splits.push(Curve::default())
  }
  {
    commands,
    index: 0,
    start: Vector::zero(),
    prev: Vector::zero(),
    close: false,
    split,
    splits,
    split_count: 0,
    split_index: 0,
    last_was_end: true,
    id: 0,
    count: 0U,
  }
}

///|
fn Segments::inc_id(self : Segments) -> Unit {
  if self.id == 254 {
    self.id = 0
  } else {
    self.id = self.id + 1
  }
}

///|
fn Segments::split_curve(
  self : Segments,
  id : SegmentId,
  c : Curve,
) -> Segment? {
  if c.is_line(MERGE_EPSILON) {
    if c.a.nearly_eq_by(c.d, MERGE_EPSILON) {
      return None
    }
    return Some(Line(id, Line(c.a, c.d)))
  }
  let splits : Array[Curve] = []
  for _i in 0..<4 {
    splits.push(Curve::default())
  }
  let count = c.split_at_max_curvature(splits)
  let mut i = 0
  for j in 0..<count {
    let curve = splits[j]
    if curve.needs_split() {
      let (a, b) = curve.split(0.5)
      if a.needs_split() {
        let (c1, d1) = a.split(0.5)
        self.splits[i] = c1
        self.splits[i + 1] = d1
        i = i + 2
      } else {
        self.splits[i] = a
        i = i + 1
      }
      if b.needs_split() {
        let (c2, d2) = b.split(0.5)
        self.splits[i] = c2
        self.splits[i + 1] = d2
        i = i + 2
      } else {
        self.splits[i] = b
        i = i + 1
      }
    } else {
      self.splits[i] = curve
      i = i + 1
    }
  }
  self.split_count = i
  self.split_index = 1
  self.splits[0].to_segment(id)
}

///|
fn Segments::next(self : Segments) -> Segment? {
  if self.close {
    self.close = false
    self.last_was_end = true
    return Some(End(true))
  }
  if self.split {
    while true {
      if self.split_index < self.split_count {
        let curve = self.splits[self.split_index]
        self.split_index = self.split_index + 1
        match curve.to_segment(self.id) {
          Some(seg) => {
            self.count = self.count + 1
            self.last_was_end = false
            self.prev = curve.d
            return Some(seg)
          }
          None => continue
        }
      }
      self.inc_id()
      let id = self.id
      let from = self.prev
      if self.index >= self.commands.length() {
        return None
      }
      let cmd = self.commands[self.index]
      self.index = self.index + 1
      match cmd {
        MoveTo(to) => {
          self.start = to
          self.prev = to
          self.count = 0U
          if !self.last_was_end {
            self.last_was_end = true
            return Some(End(false))
          }
        }
        LineTo(to) =>
          if !from.nearly_eq_by(to, MERGE_EPSILON) {
            self.count = self.count + 1
            self.prev = to
            self.last_was_end = false
            return Some(Line(id, Line(from, to)))
          }
        CurveTo(c1, c2, to) =>
          match self.split_curve(id, Curve(from, c1, c2, to)) {
            Some(seg) => {
              self.count = self.count + 1
              self.prev = to
              self.last_was_end = false
              return Some(seg)
            }
            None => ()
          }
        QuadTo(c, to) =>
          match self.split_curve(id, Curve::from_quadratic(from, c, to)) {
            Some(seg) => {
              self.count = self.count + 1
              self.prev = to
              self.last_was_end = false
              return Some(seg)
            }
            None => ()
          }
        Close => {
          self.prev = self.start
          if self.count == 0U || !from.nearly_eq_by(self.start, MERGE_EPSILON) {
            self.close = true
            return Some(Line(id, Line(from, self.start)))
          } else {
            self.count = 0U
            self.last_was_end = true
            return Some(End(true))
          }
        }
      }
    }
  } else {
    let id = self.id
    self.inc_id()
    while true {
      let from = self.prev
      if self.index >= self.commands.length() {
        return None
      }
      let cmd = self.commands[self.index]
      self.index = self.index + 1
      match cmd {
        MoveTo(to) => {
          self.start = to
          self.prev = to
          self.count = 0U
          if !self.last_was_end {
            self.last_was_end = true
            return Some(End(false))
          }
        }
        LineTo(to) =>
          if !from.nearly_eq_by(to, MERGE_EPSILON) {
            self.count = self.count + 1
            self.prev = to
            self.last_was_end = false
            return Some(Line(id, Line(from, to)))
          }
        CurveTo(c1, c2, to) => {
          self.count = self.count + 1
          self.prev = to
          self.last_was_end = false
          return Some(Curve(id, Curve(from, c1, c2, to)))
        }
        QuadTo(c, to) => {
          self.count = self.count + 1
          self.prev = to
          self.last_was_end = false
          return Some(Curve(id, Curve::from_quadratic(from, c, to)))
        }
        Close => {
          self.prev = self.start
          if self.count == 0U || !from.nearly_eq_by(self.start, MERGE_EPSILON) {
            self.close = true
            return Some(Line(id, Line(from, self.start)))
          } else {
            self.count = 0U
            self.last_was_end = true
            return Some(End(true))
          }
        }
      }
    }
  }
  None
}
