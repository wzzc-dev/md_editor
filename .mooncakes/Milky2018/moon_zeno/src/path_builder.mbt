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
/// Path builder sink interface.
///
/// Ported from upstream `zeno/src/path_builder.rs` (Apache-2.0 OR MIT).
pub(open) trait PathBuilder {
  /// Returns the current point of the path.
  current_point(Self) -> Point
  move_to(Self, Point) -> Unit
  line_to(Self, Point) -> Unit
  quad_to(Self, Point, Point) -> Unit
  curve_to(Self, Point, Point, Point) -> Unit
  close(Self) -> Unit
}

///|
/// Convenience operations built on top of the core `PathBuilder` methods.
///
/// Upstream Rust exposes these as default trait methods on `PathBuilder`.
/// MoonBit traits do not support default method bodies, so we provide them as
/// free functions.
pub fn rel_move_to(sink : &PathBuilder, to : Point) -> Unit {
  PathBuilder::move_to(sink, to + PathBuilder::current_point(sink))
}

///|
pub fn rel_line_to(sink : &PathBuilder, to : Point) -> Unit {
  PathBuilder::line_to(sink, to + PathBuilder::current_point(sink))
}

///|
pub fn rel_quad_to(sink : &PathBuilder, c : Point, to : Point) -> Unit {
  let r = PathBuilder::current_point(sink)
  PathBuilder::quad_to(sink, c + r, to + r)
}

///|
pub fn rel_curve_to(
  sink : &PathBuilder,
  c1 : Point,
  c2 : Point,
  to : Point,
) -> Unit {
  let r = PathBuilder::current_point(sink)
  PathBuilder::curve_to(sink, c1 + r, c2 + r, to + r)
}

///|
pub fn arc_to(
  sink : &PathBuilder,
  rx : Double,
  ry : Double,
  angle : Angle,
  size : ArcSize,
  sweep : ArcSweep,
  to : Point,
) -> Unit {
  let from = PathBuilder::current_point(sink)
  arc(sink, from, rx, ry, angle.to_radians(), size, sweep, to)
}

///|
pub fn rel_arc_to(
  sink : &PathBuilder,
  rx : Double,
  ry : Double,
  angle : Angle,
  size : ArcSize,
  sweep : ArcSweep,
  to : Point,
) -> Unit {
  arc_to(
    sink,
    rx,
    ry,
    angle,
    size,
    sweep,
    to + PathBuilder::current_point(sink),
  )
}

///|
pub fn add_rect(
  sink : &PathBuilder,
  xy : Point,
  w : Double,
  h : Double,
) -> Unit {
  let p = xy
  let l = p.x()
  let t = p.y()
  let r = l + w
  let b = t + h
  PathBuilder::move_to(sink, p)
  PathBuilder::line_to(sink, Vector(r, t))
  PathBuilder::line_to(sink, Vector(r, b))
  PathBuilder::line_to(sink, Vector(l, b))
  PathBuilder::close(sink)
}

///|
pub fn add_round_rect(
  sink : &PathBuilder,
  xy : Point,
  w : Double,
  h : Double,
  rx0 : Double,
  ry0 : Double,
) -> Unit {
  let p = xy
  let size = ArcSize::Small
  let sweep = ArcSweep::Positive
  let a = Angle::from_radians(0.0)
  let hw = w * 0.5
  let rx = if rx0 < 0.0 { 0.0 } else if rx0 > hw { hw } else { rx0 }
  let hh = h * 0.5
  let ry = if ry0 < 0.0 { 0.0 } else if ry0 > hh { hh } else { ry0 }
  PathBuilder::move_to(sink, Vector(p.x() + rx, p.y()))
  PathBuilder::line_to(sink, Vector(p.x() + w - rx, p.y()))
  arc_to(sink, rx, ry, a, size, sweep, Vector(p.x() + w, p.y() + ry))
  PathBuilder::line_to(sink, Vector(p.x() + w, p.y() + h - ry))
  arc_to(sink, rx, ry, a, size, sweep, Vector(p.x() + w - rx, p.y() + h))
  PathBuilder::line_to(sink, Vector(p.x() + rx, p.y() + h))
  arc_to(sink, rx, ry, a, size, sweep, Vector(p.x(), p.y() + h - ry))
  PathBuilder::line_to(sink, Vector(p.x(), p.y() + ry))
  arc_to(sink, rx, ry, a, size, sweep, Vector(p.x() + rx, p.y()))
  PathBuilder::close(sink)
}

///|
pub fn add_ellipse(
  sink : &PathBuilder,
  center : Point,
  rx : Double,
  ry : Double,
) -> Unit {
  let cx = center.x()
  let cy = center.y()
  let a = 0.551915024494
  let arx = a * rx
  let ary = a * ry
  PathBuilder::move_to(sink, Vector(cx + rx, cy))
  PathBuilder::curve_to(
    sink,
    Vector(cx + rx, cy + ary),
    Vector(cx + arx, cy + ry),
    Vector(cx, cy + ry),
  )
  PathBuilder::curve_to(
    sink,
    Vector(cx - arx, cy + ry),
    Vector(cx - rx, cy + ary),
    Vector(cx - rx, cy),
  )
  PathBuilder::curve_to(
    sink,
    Vector(cx - rx, cy - ary),
    Vector(cx - arx, cy - ry),
    Vector(cx, cy - ry),
  )
  PathBuilder::curve_to(
    sink,
    Vector(cx + arx, cy - ry),
    Vector(cx + rx, cy - ary),
    Vector(cx + rx, cy),
  )
  PathBuilder::close(sink)
}

///|
pub fn add_circle(sink : &PathBuilder, center : Point, r : Double) -> Unit {
  add_ellipse(sink, center, r, r)
}

// NOTE: trig functions are provided by `moonbitlang/core/math` (@coremath).

///|
/// Arc size flag (SVG style).
///
/// Ported from upstream `zeno/src/path_builder.rs`.
pub(all) enum ArcSize {
  Small
  Large
}

///|
/// Arc sweep flag (SVG style).
///
/// Ported from upstream `zeno/src/path_builder.rs`.
pub(all) enum ArcSweep {
  Positive
  Negative
}

///|
fn acos(x : Double) -> Double {
  @coremath.acos(x)
}

///|
fn sin(x : Double) -> Double {
  @coremath.sin(x)
}

///|
fn cos(x : Double) -> Double {
  @coremath.cos(x)
}

///|
/// Iterator that generates cubic Beziers for an arc.
///
/// Ported from upstream `zeno/src/path_builder.rs::Arc`.
priv struct Arc {
  mut count : Int
  center : (Double, Double)
  radii : (Double, Double)
  cosphi : Double
  sinphi : Double
  mut ang1 : Double
  ang2 : Double
  a : Double
}

///|
fn Arc::default() -> Arc {
  {
    count: 0,
    center: (0.0, 0.0),
    radii: (0.0, 0.0),
    cosphi: 1.0,
    sinphi: 0.0,
    ang1: 0.0,
    ang2: 0.0,
    a: 0.0,
  }
}

///|
fn Arc::Arc(
  from : Point,
  rx : Double,
  ry : Double,
  angle : Double,
  size : ArcSize,
  sweep : ArcSweep,
  to : Point,
) -> Arc {
  let px = from.x()
  let py = from.y()
  // NOTE: Keep upstream's slightly imprecise TAU constant.
  let tau = 3.141579 * 2.0
  let sinphi = sin(angle)
  let cosphi = cos(angle)
  let pxp = cosphi * (px - to.x()) / 2.0 + sinphi * (py - to.y()) / 2.0
  let pyp = -sinphi * (px - to.x()) / 2.0 + cosphi * (py - to.y()) / 2.0
  if pxp == 0.0 && pyp == 0.0 {
    return Arc::default()
  }
  let mut rx0 = rx.abs()
  let mut ry0 = ry.abs()
  let lambda = pxp * pxp / (rx0 * rx0) + pyp * pyp / (ry0 * ry0)
  if lambda > 1.0 {
    let s = lambda.sqrt()
    rx0 = rx0 * s
    ry0 = ry0 * s
  }
  let large_arc = match size {
    Large => true
    _ => false
  }
  let sweep_pos = match sweep {
    Positive => true
    _ => false
  }
  fn vec_angle(ux : Double, uy : Double, vx : Double, vy : Double) -> Double {
    let sign = if ux * vy - uy * vx < 0.0 { -1.0 } else { 1.0 }
    let dot0 = ux * vx + uy * vy
    let dot = if dot0 < -1.0 { -1.0 } else if dot0 > 1.0 { 1.0 } else { dot0 }
    sign * acos(dot)
  }

  let rxsq = rx0 * rx0
  let rysq = ry0 * ry0
  let pxpsq = pxp * pxp
  let pypsq = pyp * pyp
  let mut radicant = rxsq * rysq - rxsq * pypsq - rysq * pxpsq
  if radicant < 0.0 {
    radicant = 0.0
  }
  radicant = radicant / (rxsq * pypsq + rysq * pxpsq)
  let sign = if large_arc == sweep_pos { -1.0 } else { 1.0 }
  radicant = radicant.sqrt() * sign
  let cxp = radicant * rx0 / ry0 * pyp
  let cyp = radicant * -ry0 / rx0 * pxp
  let cx = cosphi * cxp - sinphi * cyp + (px + to.x()) / 2.0
  let cy = sinphi * cxp + cosphi * cyp + (py + to.y()) / 2.0
  let vx1 = (pxp - cxp) / rx0
  let vy1 = (pyp - cyp) / ry0
  let vx2 = (-pxp - cxp) / rx0
  let vy2 = (-pyp - cyp) / ry0
  let ang1 = vec_angle(1.0, 0.0, vx1, vy1)
  let mut ang2 = vec_angle(vx1, vy1, vx2, vy2)
  if !sweep_pos && ang2 > 0.0 {
    ang2 = ang2 - tau
  }
  if sweep_pos && ang2 < 0.0 {
    ang2 = ang2 + tau
  }
  let mut ratio = ang2.abs() / (tau / 4.0)
  if (1.0 - ratio).abs() < 0.0000001 {
    ratio = 1.0
  }
  let segments = ratio.ceil()
  let seg0 = if segments < 1.0 { 1.0 } else { segments }
  let count = seg0.to_int()
  ang2 = ang2 / seg0
  let a = if ang2 == @coremath.PI / 2.0 {
    0.551915024494
  } else if ang2 == -(@coremath.PI / 2.0) {
    -0.551915024494
  } else {
    4.0 / 3.0 * @coremath.tan(ang2 / 4.0)
  }
  { count, center: (cx, cy), radii: (rx0, ry0), sinphi, cosphi, ang1, ang2, a }
}

///|
fn Arc::next(self : Arc) -> Command? {
  if self.count <= 0 {
    return None
  }
  self.count = self.count - 1
  let y1 = sin(self.ang1)
  let x1 = cos(self.ang1)
  let y2 = sin(self.ang1 + self.ang2)
  let x2 = cos(self.ang1 + self.ang2)
  let a = self.a
  let (cx, cy) = self.center
  let (rx, ry) = self.radii
  let sinphi = self.sinphi
  let cosphi = self.cosphi
  let c1 = Vector((x1 - y1 * a) * rx, (y1 + x1 * a) * ry)
  let c1 = Vector(
    cx + (cosphi * c1.x() - sinphi * c1.y()),
    cy + (sinphi * c1.x() + cosphi * c1.y()),
  )
  let c2 = Vector((x2 + y2 * a) * rx, (y2 - x2 * a) * ry)
  let c2 = Vector(
    cx + (cosphi * c2.x() - sinphi * c2.y()),
    cy + (sinphi * c2.x() + cosphi * c2.y()),
  )
  let p2 = Vector(x2 * rx, y2 * ry)
  let p2 = Vector(
    cx + (cosphi * p2.x() - sinphi * p2.y()),
    cy + (sinphi * p2.x() + cosphi * p2.y()),
  )
  self.ang1 = self.ang1 + self.ang2
  Some(CurveTo(c1, c2, p2))
}

///|
/// Emits an elliptical arc as one or more cubic Beziers into the sink.
///
/// Ported from upstream `zeno/src/path_builder.rs::arc`.
fn arc(
  sink : &PathBuilder,
  from : Point,
  rx : Double,
  ry : Double,
  angle : Double,
  size : ArcSize,
  sweep : ArcSweep,
  to : Point,
) -> Unit {
  let p = from
  let px = p.x()
  let py = p.y()
  let tau = @coremath.PI * 2.0
  let sinphi = sin(angle)
  let cosphi = cos(angle)
  let pxp = cosphi * (px - to.x()) / 2.0 + sinphi * (py - to.y()) / 2.0
  let pyp = -sinphi * (px - to.x()) / 2.0 + cosphi * (py - to.y()) / 2.0
  if pxp == 0.0 && pyp == 0.0 {
    return
  }
  let mut rx0 = rx.abs()
  let mut ry0 = ry.abs()
  let lambda = pxp * pxp / (rx0 * rx0) + pyp * pyp / (ry0 * ry0)
  if lambda > 1.0 {
    let s = lambda.sqrt()
    rx0 = rx0 * s
    ry0 = ry0 * s
  }
  let large_arc = match size {
    Large => true
    _ => false
  }
  let sweep_pos = match sweep {
    Positive => true
    _ => false
  }
  fn vec_angle(ux : Double, uy : Double, vx : Double, vy : Double) -> Double {
    let sign = if ux * vy - uy * vx < 0.0 { -1.0 } else { 1.0 }
    let dot0 = ux * vx + uy * vy
    let dot = if dot0 < -1.0 { -1.0 } else if dot0 > 1.0 { 1.0 } else { dot0 }
    sign * acos(dot)
  }

  let rxsq = rx0 * rx0
  let rysq = ry0 * ry0
  let pxpsq = pxp * pxp
  let pypsq = pyp * pyp
  let mut radicant = rxsq * rysq - rxsq * pypsq - rysq * pxpsq
  if radicant < 0.0 {
    radicant = 0.0
  }
  radicant = radicant / (rxsq * pypsq + rysq * pxpsq)
  let sign = if large_arc == sweep_pos { -1.0 } else { 1.0 }
  radicant = radicant.sqrt() * sign
  let cxp = radicant * rx0 / ry0 * pyp
  let cyp = radicant * -ry0 / rx0 * pxp
  let cx = cosphi * cxp - sinphi * cyp + (px + to.x()) / 2.0
  let cy = sinphi * cxp + cosphi * cyp + (py + to.y()) / 2.0
  let vx1 = (pxp - cxp) / rx0
  let vy1 = (pyp - cyp) / ry0
  let vx2 = (-pxp - cxp) / rx0
  let vy2 = (-pyp - cyp) / ry0
  let mut ang1 = vec_angle(1.0, 0.0, vx1, vy1)
  let mut ang2 = vec_angle(vx1, vy1, vx2, vy2)
  if !sweep_pos && ang2 > 0.0 {
    ang2 = ang2 - tau
  }
  if sweep_pos && ang2 < 0.0 {
    ang2 = ang2 + tau
  }
  let mut ratio = ang2.abs() / (tau / 4.0)
  if (1.0 - ratio).abs() < 0.0000001 {
    ratio = 1.0
  }
  let segments0 = ratio.ceil()
  let segments = if segments0 < 1.0 { 1.0 } else { segments0 }
  let seg_count = segments.to_int()
  ang2 = ang2 / segments
  let a = if ang2 == @coremath.PI / 2.0 {
    0.551915024494
  } else if ang2 == -(@coremath.PI / 2.0) {
    -0.551915024494
  } else {
    4.0 / 3.0 * @coremath.tan(ang2 / 4.0)
  }
  for _i in 0..<seg_count {
    let y1 = sin(ang1)
    let x1 = cos(ang1)
    let y2 = sin(ang1 + ang2)
    let x2 = cos(ang1 + ang2)
    let c1 = Vector((x1 - y1 * a) * rx0, (y1 + x1 * a) * ry0)
    let c1 = Vector(
      cx + (cosphi * c1.x() - sinphi * c1.y()),
      cy + (sinphi * c1.x() + cosphi * c1.y()),
    )
    let c2 = Vector((x2 + y2 * a) * rx0, (y2 - x2 * a) * ry0)
    let c2 = Vector(
      cx + (cosphi * c2.x() - sinphi * c2.y()),
      cy + (sinphi * c2.x() + cosphi * c2.y()),
    )
    let p2 = Vector(x2 * rx0, y2 * ry0)
    let p2 = Vector(
      cx + (cosphi * p2.x() - sinphi * p2.y()),
      cy + (sinphi * p2.x() + cosphi * p2.y()),
    )
    sink.curve_to(c1, c2, p2)
    ang1 = ang1 + ang2
  }
}

///|
/// PathBuilder implementation for command buffers.
///
/// This mirrors upstream `impl PathBuilder for Vec<Command>`.
pub impl PathBuilder for Array[Command] with current_point(self) {
  let n = self.length()
  if n == 0 {
    return Vector::zero()
  }
  match self[n - 1] {
    MoveTo(p) => p
    LineTo(p) => p
    QuadTo(_, p) => p
    CurveTo(_, _, p) => p
    Close => {
      // Find the start point of the current subpath.
      if n <= 1 {
        return Vector::zero()
      }
      let mut i = n - 2
      while i >= 0 {
        match self[i] {
          MoveTo(p) => return p
          _ => ()
        }
        if i == 0 {
          break
        }
        i = i - 1
      }
      Vector::zero()
    }
  }
}

///|
pub impl PathBuilder for Array[Command] with move_to(self, to) {
  self.push(MoveTo(to))
}

///|
pub impl PathBuilder for Array[Command] with line_to(self, to) {
  self.push(LineTo(to))
}

///|
pub impl PathBuilder for Array[Command] with quad_to(self, c, to) {
  self.push(QuadTo(c, to))
}

///|
pub impl PathBuilder for Array[Command] with curve_to(self, c1, c2, to) {
  self.push(CurveTo(c1, c2, to))
}

///|
pub impl PathBuilder for Array[Command] with close(self) {
  self.push(Close)
}
