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
/// Path data abstraction.
///
/// Ported from upstream `zeno/src/path_data.rs` (Apache-2.0 OR MIT).
pub(open) trait PathData {
  commands(Self) -> Iter[Command]
  copy_to(Self, &PathBuilder) -> Unit
}

///|
/// PathData implementation for point/verb list structures.
///
/// Mirrors upstream `impl PathData for (&[Point], &[Verb])`.
pub impl PathData for (Array[Point], Array[Verb]) with commands(self) {
  let (points, verbs) = self
  let it = PointsCommands(points, verbs)
  Iter::new(fn() { it.next() })
}

///|
pub impl PathData for (Array[Point], Array[Verb]) with copy_to(self, sink) {
  let it = PathData::commands(self)
  while it.next() is Some(cmd) {
    match cmd {
      MoveTo(p) => sink.move_to(p)
      LineTo(p) => sink.line_to(p)
      QuadTo(c, p) => sink.quad_to(c, p)
      CurveTo(c1, c2, p) => sink.curve_to(c1, c2, p)
      Close => sink.close()
    }
  }
}

///|
/// PathData implementation for SVG path strings.
pub impl PathData for String with commands(self) {
  let it = SvgCommands(self)
  Iter::new(fn() { it.next() })
}

///|
pub impl PathData for String with copy_to(self, sink) {
  let it = PathData::commands(self)
  while it.next() is Some(cmd) {
    match cmd {
      MoveTo(p) => sink.move_to(p)
      LineTo(p) => sink.line_to(p)
      QuadTo(c, p) => sink.quad_to(c, p)
      CurveTo(c1, c2, p) => sink.curve_to(c1, c2, p)
      Close => sink.close()
    }
  }
}

///|
/// PathData implementation for pre-parsed command buffers.
pub impl PathData for Array[Command] with commands(self) {
  let mut i = 0
  let n = self.length()
  Iter::new(fn() {
    if i >= n {
      None
    } else {
      let v = self[i]
      i = i + 1
      Some(v)
    }
  })
}

///|
pub impl PathData for Array[Command] with copy_to(self, sink) {
  let it = PathData::commands(self)
  while it.next() is Some(cmd) {
    match cmd {
      MoveTo(p) => sink.move_to(p)
      LineTo(p) => sink.line_to(p)
      QuadTo(c, p) => sink.quad_to(c, p)
      CurveTo(c1, c2, p) => sink.curve_to(c1, c2, p)
      Close => sink.close()
    }
  }
}

///|
/// Computes the total length of the path.
///
/// Ported from upstream `zeno/src/path_data.rs::length`.
pub fn length(data : &PathData, transform : Transform?) -> Double {
  let mut sum = 0.0
  let cmds = data.commands()
  if transform is Some(t) {
    let it = cmds
    let mapped = Iter::new(fn() {
      match it.next() {
        Some(cmd) => Some(cmd.transform(t))
        None => None
      }
    })
    let segs = segments(mapped, false)
    let sit = segs
    while sit.next() is Some(seg) {
      sum = sum + seg.length()
    }
  } else {
    let segs = segments(cmds, false)
    let sit = segs
    while sit.next() is Some(seg) {
      sum = sum + seg.length()
    }
  }
  sum
}
