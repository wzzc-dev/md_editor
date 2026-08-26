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
fn binary_search_ints(sorted : Array[Int], value : Int) -> Result[Int, Int] {
  let mut lo = 0
  let mut hi = sorted.length()
  while lo < hi {
    let mid = (lo + hi) / 2
    let mid_value = sorted[mid]
    if mid_value == value {
      return Ok(mid)
    } else if mid_value < value {
      lo = mid + 1
    } else {
      hi = mid
    }
  }
  Err(lo)
}

///|
fn sum_ints(values : Array[Int], start : Int, end : Int) -> Int {
  let mut total = 0
  for i in start..<end {
    total = total + values[i]
  }
  total
}

///|
fn count_chars(s : String) -> Int {
  let mut n = 0
  for _ in s {
    n = n + 1
  }
  n
}

///|
fn char_len_utf16(c : Char) -> Int {
  let v = c.to_int()
  if v >= 0x10000 {
    2
  } else {
    1
  }
}

///|
fn utf16_len(s : String) -> Int {
  let mut total = 0
  for c in s {
    total = total + char_len_utf16(c)
  }
  total
}

///|
fn utf8_substring_by_bytes(
  s : String,
  start_byte : Int,
  end_byte : Int,
) -> String {
  if start_byte == end_byte {
    return ""
  }
  let bytes = @utf8.encode(s[:])
  @utf8.decode_lossy(bytes[:][start_byte:end_byte])
}

///|
struct InnerTextPosition {
  node : Node
  character_index : Int
}

///|
fn InnerTextPosition::upgrade(
  tree_state : State,
  weak : @common.TextPosition,
  node_id : NodeId,
) -> InnerTextPosition? {
  let node = tree_state.node_by_id(node_id.with_same_tree(weak.node))
  match node {
    None => None
    Some(node) => {
      if node.role() != @common.Role::TextRun {
        return None
      }
      let character_index = weak.character_index
      if character_index > node.data().character_lengths().length() {
        return None
      }
      Some({ node, character_index })
    }
  }
}

///|
fn InnerTextPosition::clamped_upgrade(
  tree_state : State,
  weak : @common.TextPosition,
  node_id : NodeId,
) -> InnerTextPosition? {
  let node = tree_state.node_by_id(node_id.with_same_tree(weak.node))
  match node {
    None => None
    Some(node) => {
      if node.role() != @common.Role::TextRun {
        return None
      }
      let max_index = node.data().character_lengths().length()
      let character_index = if weak.character_index < max_index {
        weak.character_index
      } else {
        max_index
      }
      Some({ node, character_index })
    }
  }
}

///|
fn InnerTextPosition::is_run_start(self : InnerTextPosition) -> Bool {
  self.character_index == 0
}

///|
fn InnerTextPosition::is_run_end(self : InnerTextPosition) -> Bool {
  self.character_index == self.node.data().character_lengths().length()
}

///|
fn InnerTextPosition::is_line_start(self : InnerTextPosition) -> Bool {
  self.is_run_start() && self.node.data().previous_on_line() is None
}

///|
fn InnerTextPosition::is_line_end(self : InnerTextPosition) -> Bool {
  self.is_run_end() && self.node.data().next_on_line() is None
}

///|
fn InnerTextPosition::is_paragraph_end(self : InnerTextPosition) -> Bool {
  if !self.is_line_end() {
    return false
  }
  match self.node.data().value() {
    Some(v) => v.has_suffix("\n")
    None => false
  }
}

///|
fn InnerTextPosition::is_document_start(
  self : InnerTextPosition,
  root_node : Node,
) -> Bool {
  self.is_run_start() && self.node.preceding_text_runs(root_node).length() == 0
}

///|
fn InnerTextPosition::is_document_end(
  self : InnerTextPosition,
  root_node : Node,
) -> Bool {
  self.is_run_end() && self.node.following_text_runs(root_node).length() == 0
}

///|
fn InnerTextPosition::biased_to_start(
  self : InnerTextPosition,
  root_node : Node,
) -> InnerTextPosition {
  if self.is_run_end() {
    let next = self.node.following_text_runs(root_node)
    if next.length() > 0 {
      return { node: next[0], character_index: 0 }
    }
  }
  self
}

///|
fn InnerTextPosition::biased_to_end(
  self : InnerTextPosition,
  root_node : Node,
) -> InnerTextPosition {
  if self.is_run_start() {
    let prev = self.node.preceding_text_runs(root_node)
    if prev.length() > 0 {
      let node = prev[0]
      return { node, character_index: node.data().character_lengths().length() }
    }
  }
  self
}

///|
fn InnerTextPosition::line_start(self : InnerTextPosition) -> InnerTextPosition {
  let mut node = self.node
  while node.data().previous_on_line() is Some(local_id) {
    node = node.tree_state
      .node_by_id(node.id().with_same_tree(local_id))
      .unwrap()
  }
  { node, character_index: 0 }
}

///|
fn InnerTextPosition::line_end(self : InnerTextPosition) -> InnerTextPosition {
  let mut node = self.node
  while node.data().next_on_line() is Some(local_id) {
    node = node.tree_state
      .node_by_id(node.id().with_same_tree(local_id))
      .unwrap()
  }
  { node, character_index: node.data().character_lengths().length() }
}

///|
fn InnerTextPosition::downgrade(
  self : InnerTextPosition,
) -> @common.TextPosition {
  let (local_node_id, _) = self.node.id().to_components()
  @common.TextPosition(local_node_id, self.character_index)
}

///|
pub struct TextPosition {
  root_node : Node
  inner : InnerTextPosition
}

///|
pub fn TextPosition::to_raw(self : TextPosition) -> @common.TextPosition {
  self.inner.downgrade()
}

///|
pub fn TextPosition::inner_node(self : TextPosition) -> Node {
  self.inner.node
}

///|
pub fn TextPosition::is_format_start(self : TextPosition) -> Bool {
  self.is_document_start() ||
  (
    self.inner.character_index == 0 &&
    self.inner.node.text_attributes_differ(
      self.inner.node.preceding_text_runs(self.root_node)[0],
    )
  )
}

///|
pub fn TextPosition::is_word_start(self : TextPosition) -> Bool {
  self.is_paragraph_start() ||
  binary_search_ints(
    self.inner.node.data().word_starts(),
    self.inner.character_index,
  )
  is Ok(_)
}

///|
pub fn TextPosition::is_line_start(self : TextPosition) -> Bool {
  self.inner.is_line_start()
}

///|
pub fn TextPosition::is_line_end(self : TextPosition) -> Bool {
  self.inner.is_line_end()
}

///|
pub fn TextPosition::is_paragraph_start(self : TextPosition) -> Bool {
  self.is_document_start() ||
  (
    self.is_line_start() &&
    self.inner.biased_to_end(self.root_node).is_paragraph_end()
  )
}

///|
pub fn TextPosition::is_paragraph_end(self : TextPosition) -> Bool {
  self.is_document_end() || self.inner.is_paragraph_end()
}

///|
pub fn TextPosition::is_paragraph_separator(self : TextPosition) -> Bool {
  if self.is_document_end() {
    return false
  }
  let next = self.forward_to_character_end()
  !next.is_document_end() && next.is_paragraph_end()
}

///|
pub fn TextPosition::is_page_start(self : TextPosition) -> Bool {
  self.is_document_start()
}

///|
pub fn TextPosition::is_document_start(self : TextPosition) -> Bool {
  self.inner.is_document_start(self.root_node)
}

///|
pub fn TextPosition::is_document_end(self : TextPosition) -> Bool {
  self.inner.is_document_end(self.root_node)
}

///|
pub fn TextPosition::to_degenerate_range(self : TextPosition) -> TextRange {
  TextRange::TextRange(self.root_node, self.inner, self.inner)
}

///|
pub fn TextPosition::compare(self : TextPosition, other : TextPosition) -> Int? {
  if self.root_node.id() != other.root_node.id() {
    None
  } else {
    Some(
      compare_comparables(
        self.inner.comparable(self.root_node),
        other.inner.comparable(self.root_node),
      ),
    )
  }
}

///|
pub fn TextPosition::to_global_usv_index(self : TextPosition) -> Int {
  let mut total_length = 0
  for node in self.root_node.text_runs() {
    let node_text = node.data().value().unwrap()
    if node.id() == self.inner.node.id() {
      let character_lengths = node.data().character_lengths()
      let slice_end = sum_ints(character_lengths, 0, self.inner.character_index)
      let prefix = utf8_substring_by_bytes(node_text, 0, slice_end)
      return total_length + count_chars(prefix)
    }
    total_length = total_length + count_chars(node_text)
  }
  abort("invalid text position")
}

///|
pub fn TextPosition::to_global_utf16_index(self : TextPosition) -> Int {
  let mut total_length = 0
  for node in self.root_node.text_runs() {
    let node_text = node.data().value().unwrap()
    if node.id() == self.inner.node.id() {
      let character_lengths = node.data().character_lengths()
      let slice_end = sum_ints(character_lengths, 0, self.inner.character_index)
      let prefix = utf8_substring_by_bytes(node_text, 0, slice_end)
      return total_length + utf16_len(prefix)
    }
    total_length = total_length + utf16_len(node_text)
  }
  abort("invalid text position")
}

///|
pub fn TextPosition::to_line_index(self : TextPosition) -> Int {
  let mut pos = self
  if !pos.is_line_start() {
    pos = pos.backward_to_line_start()
  }
  let mut lines_before_current = 0
  while !pos.is_document_start() {
    pos = pos.backward_to_line_start()
    lines_before_current = lines_before_current + 1
  }
  lines_before_current
}

///|
pub fn TextPosition::biased_to_start(self : TextPosition) -> TextPosition {
  {
    root_node: self.root_node,
    inner: self.inner.biased_to_start(self.root_node),
  }
}

///|
pub fn TextPosition::biased_to_end(self : TextPosition) -> TextPosition {
  { root_node: self.root_node, inner: self.inner.biased_to_end(self.root_node) }
}

///|
pub fn TextPosition::forward_to_character_start(
  self : TextPosition,
) -> TextPosition {
  let pos = self.inner.biased_to_start(self.root_node)
  let next = { node: pos.node, character_index: pos.character_index + 1 }
  { root_node: self.root_node, inner: next.biased_to_start(self.root_node) }
}

///|
pub fn TextPosition::forward_to_character_end(
  self : TextPosition,
) -> TextPosition {
  let pos = self.inner.biased_to_start(self.root_node)
  let next = { node: pos.node, character_index: pos.character_index + 1 }
  { root_node: self.root_node, inner: next }
}

///|
pub fn TextPosition::backward_to_character_start(
  self : TextPosition,
) -> TextPosition {
  let pos = self.inner.biased_to_end(self.root_node)
  let prev = { node: pos.node, character_index: pos.character_index - 1 }
  { root_node: self.root_node, inner: prev.biased_to_start(self.root_node) }
}

///|
pub fn TextPosition::forward_to_format_start(
  self : TextPosition,
) -> TextPosition {
  for node in self.inner.node.following_text_runs(self.root_node) {
    if self.inner.node.text_attributes_differ(node) {
      return { root_node: self.root_node, inner: { node, character_index: 0 } }
    }
  }
  self.document_end()
}

///|
pub fn TextPosition::forward_to_format_end(self : TextPosition) -> TextPosition {
  self.forward_to_format_start().biased_to_end()
}

///|
pub fn TextPosition::backward_to_format_start(
  self : TextPosition,
) -> TextPosition {
  if self.inner.character_index != 0 {
    let test_pos = {
      root_node: self.root_node,
      inner: { node: self.inner.node, character_index: 0 },
    }
    if test_pos.is_format_start() {
      return test_pos
    }
  }
  for node in self.inner.node.preceding_text_runs(self.root_node) {
    let test_pos = {
      root_node: self.root_node,
      inner: { node, character_index: 0 },
    }
    if test_pos.is_format_start() {
      return test_pos
    }
  }
  self.document_start()
}

///|
pub fn TextPosition::forward_to_word_start(self : TextPosition) -> TextPosition {
  let pos = self.inner.biased_to_start(self.root_node)
  let word_starts = pos.node.data().word_starts()
  let index = match binary_search_ints(word_starts, pos.character_index) {
    Ok(i) => i + 1
    Err(i) => i
  }
  if index < word_starts.length() {
    return {
      root_node: self.root_node,
      inner: { node: pos.node, character_index: word_starts[index] },
    }
  }
  for node in pos.node.following_text_runs(self.root_node) {
    let start_pos : TextPosition = {
      root_node: self.root_node,
      inner: { node, character_index: 0 },
    }
    if start_pos.is_paragraph_start() {
      return start_pos
    }
    let next_word_starts = node.data().word_starts()
    if next_word_starts.length() > 0 {
      return {
        root_node: self.root_node,
        inner: { node, character_index: next_word_starts[0] },
      }
    }
  }
  self.document_end()
}

///|
pub fn TextPosition::forward_to_word_end(self : TextPosition) -> TextPosition {
  self.forward_to_word_start().biased_to_end()
}

///|
pub fn TextPosition::backward_to_word_start(
  self : TextPosition,
) -> TextPosition {
  let word_starts = self.inner.node.data().word_starts()
  let index = match
    binary_search_ints(word_starts, self.inner.character_index) {
    Ok(i) => i
    Err(i) => i
  }
  if index - 1 >= 0 {
    return {
      root_node: self.root_node,
      inner: { node: self.inner.node, character_index: word_starts[index - 1] },
    }
  }
  if self.inner.character_index != 0 {
    let start_pos = {
      root_node: self.root_node,
      inner: { node: self.inner.node, character_index: 0 },
    }
    if start_pos.is_paragraph_start() {
      return start_pos
    }
  }
  for node in self.inner.node.preceding_text_runs(self.root_node) {
    let starts = node.data().word_starts()
    if starts.length() > 0 {
      return {
        root_node: self.root_node,
        inner: { node, character_index: starts[starts.length() - 1] },
      }
    }
    let start_pos = {
      root_node: self.root_node,
      inner: { node, character_index: 0 },
    }
    if start_pos.is_paragraph_start() {
      return start_pos
    }
  }
  self.document_start()
}

///|
pub fn TextPosition::forward_to_line_start(self : TextPosition) -> TextPosition {
  {
    root_node: self.root_node,
    inner: self.inner.line_end().biased_to_start(self.root_node),
  }
}

///|
pub fn TextPosition::forward_to_line_end(self : TextPosition) -> TextPosition {
  let pos = self.inner.biased_to_start(self.root_node)
  { root_node: self.root_node, inner: pos.line_end() }
}

///|
pub fn TextPosition::backward_to_line_start(
  self : TextPosition,
) -> TextPosition {
  let pos = self.inner.biased_to_end(self.root_node)
  {
    root_node: self.root_node,
    inner: pos.line_start().biased_to_start(self.root_node),
  }
}

///|
pub fn TextPosition::forward_to_paragraph_start(
  self : TextPosition,
) -> TextPosition {
  let mut current = self
  while true {
    current = current.forward_to_line_start()
    if current.is_document_end() ||
      current.inner.biased_to_end(self.root_node).is_paragraph_end() {
      break
    }
  }
  current
}

///|
pub fn TextPosition::forward_to_paragraph_end(
  self : TextPosition,
) -> TextPosition {
  let mut current = self
  while true {
    current = current.forward_to_line_end()
    if current.is_document_end() || current.inner.is_paragraph_end() {
      break
    }
  }
  current
}

///|
pub fn TextPosition::backward_to_paragraph_start(
  self : TextPosition,
) -> TextPosition {
  let mut current = self
  while true {
    current = current.backward_to_line_start()
    if current.is_paragraph_start() {
      break
    }
  }
  current
}

///|
pub fn TextPosition::forward_to_page_start(self : TextPosition) -> TextPosition {
  self.document_end()
}

///|
pub fn TextPosition::forward_to_page_end(self : TextPosition) -> TextPosition {
  self.document_end()
}

///|
pub fn TextPosition::backward_to_page_start(
  self : TextPosition,
) -> TextPosition {
  self.document_start()
}

///|
pub fn TextPosition::document_end(self : TextPosition) -> TextPosition {
  self.root_node.document_end()
}

///|
pub fn TextPosition::document_start(self : TextPosition) -> TextPosition {
  self.root_node.document_start()
}

///|
pub enum RangePropertyValue[T] {
  Single(T)
  Mixed
} derive(Eq, Debug)

///|
pub impl[T : Debug] Show for RangePropertyValue[T] with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub fn[T, U] RangePropertyValue::map(
  self : RangePropertyValue[T?],
  f : (T) -> U,
) -> RangePropertyValue[U?] {
  match self {
    Single(value) => Single(value.map(f))
    Mixed => Mixed
  }
}

///|
fn compare_paths(a : Array[Int], b : Array[Int]) -> Int {
  let len_a = a.length()
  let len_b = b.length()
  let min_len = if len_a < len_b { len_a } else { len_b }
  for i in 0..<min_len {
    if a[i] < b[i] {
      return -1
    } else if a[i] > b[i] {
      return 1
    }
  }
  if len_a < len_b {
    -1
  } else if len_a > len_b {
    1
  } else {
    0
  }
}

///|
fn compare_comparables(a : (Array[Int], Int), b : (Array[Int], Int)) -> Int {
  let path_cmp = compare_paths(a.0, b.0)
  if path_cmp != 0 {
    return path_cmp
  }
  if a.1 < b.1 {
    -1
  } else if a.1 > b.1 {
    1
  } else {
    0
  }
}

///|
fn InnerTextPosition::comparable(
  self : InnerTextPosition,
  root_node : Node,
) -> (Array[Int], Int) {
  let normalized = self.biased_to_start(root_node)
  (
    normalized.node.relative_index_path(root_node.id()),
    normalized.character_index,
  )
}

///|
pub struct TextRange {
  node : Node
  mut start : InnerTextPosition
  mut end : InnerTextPosition
}

///|
fn TextRange::TextRange(
  node : Node,
  start : InnerTextPosition,
  end : InnerTextPosition,
) -> TextRange {
  let start_cmp = start.comparable(node)
  let end_cmp = end.comparable(node)
  if compare_comparables(start_cmp, end_cmp) <= 0 {
    { node, start, end }
  } else {
    { node, start: end, end: start }
  }
}

///|
pub fn TextRange::node(self : TextRange) -> Node {
  self.node
}

///|
pub fn TextRange::start(self : TextRange) -> TextPosition {
  { root_node: self.node, inner: self.start }
}

///|
pub fn TextRange::end(self : TextRange) -> TextPosition {
  { root_node: self.node, inner: self.end }
}

///|
pub fn TextRange::is_degenerate(self : TextRange) -> Bool {
  compare_comparables(
    self.start.comparable(self.node),
    self.end.comparable(self.node),
  ) ==
  0
}

///|
fn[T] TextRange::walk(self : TextRange, f : (Node) -> T?) -> T? {
  let (start, end) = if self.is_degenerate() {
    (self.start, self.start)
  } else {
    (self.start.biased_to_start(self.node), self.end.biased_to_end(self.node))
  }
  match f(start.node) {
    Some(result) => return Some(result)
    None => ()
  }
  if start.node.id() == end.node.id() {
    return None
  }
  for node in start.node.following_text_runs(self.node) {
    match f(node) {
      Some(result) => return Some(result)
      None => ()
    }
    if node.id() == end.node.id() {
      break
    }
  }
  None
}

///|
pub fn TextRange::text(self : TextRange) -> String {
  let buf = StringBuilder::new()
  self.write_text(buf)
  buf.to_string()
}

///|
pub fn TextRange::write_text(self : TextRange, buf : StringBuilder) -> Unit {
  self.walk(node => {
    let character_lengths = node.data().character_lengths()
    let start_index = if node.id() == self.start.node.id() {
      self.start.character_index
    } else {
      0
    }
    let end_index = if node.id() == self.end.node.id() {
      self.end.character_index
    } else {
      character_lengths.length()
    }
    let value = node.data().value().unwrap()
    let s = if start_index == end_index {
      ""
    } else if start_index == 0 && end_index == character_lengths.length() {
      value
    } else {
      let slice_start = sum_ints(character_lengths, 0, start_index)
      let slice_end = slice_start +
        sum_ints(character_lengths, start_index, end_index)
      utf8_substring_by_bytes(value, slice_start, slice_end)
    }
    buf.write_string(s)
    (None : Unit?)
  })
  |> ignore
}

///|
pub fn TextRange::bounding_boxes(self : TextRange) -> Array[@common.Rect] {
  let result : Array[@common.Rect] = []
  let fallback : Array[@common.Rect] = []
  match
    self.walk(node => {
      let rect0 = match node.data().bounds() {
        Some(r) => r
        None => return Some(fallback)
      }
      let positions = match node.data().character_positions() {
        Some(p) => p
        None => return Some(fallback)
      }
      let widths = match node.data().character_widths() {
        Some(w) => w
        None => return Some(fallback)
      }
      let direction = match node.text_direction() {
        Some(d) => d
        None => return Some(fallback)
      }
      let mut x0 = rect0.x0
      let mut y0 = rect0.y0
      let mut x1 = rect0.x1
      let mut y1 = rect0.y1
      let character_lengths = node.data().character_lengths()
      let start_index = if node.id() == self.start.node.id() {
        self.start.character_index
      } else {
        0
      }
      let end_index = if node.id() == self.end.node.id() {
        self.end.character_index
      } else {
        character_lengths.length()
      }
      if start_index != 0 || end_index != character_lengths.length() {
        let pixel_start : Float = if start_index < character_lengths.length() {
          positions[start_index]
        } else {
          positions[start_index - 1] + widths[start_index - 1]
        }
        let pixel_end : Float = if end_index == start_index {
          pixel_start
        } else {
          positions[end_index - 1] + widths[end_index - 1]
        }
        let ps = pixel_start.to_double()
        let pe = pixel_end.to_double()
        match direction {
          @common.TextDirection::LeftToRight => {
            let orig_left = x0
            x0 = orig_left + ps
            x1 = orig_left + pe
          }
          @common.TextDirection::RightToLeft => {
            let orig_right = x1
            x1 = orig_right - ps
            x0 = orig_right - pe
          }
          @common.TextDirection::TopToBottom => {
            let orig_top = y0
            y0 = orig_top + ps
            y1 = orig_top + pe
          }
          @common.TextDirection::BottomToTop => {
            let orig_bottom = y1
            y1 = orig_bottom - ps
            y0 = orig_bottom - pe
          }
        }
      }
      let rect = @common.Rect(x0, y0, x1, y1)
      result.push(node.transform().transform_rect_bbox(rect))
      None
    }) {
    Some(v) => v
    None => result
  }
}

///|
fn[T : Eq] TextRange::fetch_property(
  self : TextRange,
  getter : (Node) -> T,
) -> RangePropertyValue[T] {
  let mut value : T? = None
  match
    self.walk(node => {
      let current = getter(node)
      match value {
        Some(v) => if v != current { return Some(RangePropertyValue::Mixed) }
        None => value = Some(current)
      }
      None
    }) {
    Some(v) => v
    None => RangePropertyValue::Single(value.unwrap())
  }
}

///|
fn TextRange::fix_start_bias(self : TextRange) -> Unit {
  if !self.is_degenerate() {
    self.start = self.start.biased_to_start(self.node)
  }
}

///|
pub fn TextRange::set_start(self : TextRange, pos : TextPosition) -> Unit raise {
  assert_eq(pos.root_node.id(), self.node.id())
  self.start = pos.inner
  if compare_comparables(
      self.start.comparable(self.node),
      self.end.comparable(self.node),
    ) >=
    0 {
    self.end = self.start
  }
  self.fix_start_bias()
}

///|
pub fn TextRange::set_end(self : TextRange, pos : TextPosition) -> Unit raise {
  assert_eq(pos.root_node.id(), self.node.id())
  self.end = pos.inner
  if compare_comparables(
      self.start.comparable(self.node),
      self.end.comparable(self.node),
    ) >=
    0 {
    self.start = self.end
  }
  self.fix_start_bias()
}

///|
pub fn TextRange::to_text_selection(self : TextRange) -> @common.TextSelection {
  @common.TextSelection(self.start.downgrade(), self.end.downgrade())
}

///|
pub fn TextRange::downgrade(self : TextRange) -> WeakTextRange {
  WeakTextRange::{
    node_id: self.node.id(),
    start: self.start.downgrade(),
    end: self.end.downgrade(),
    start_comparable: self.start.comparable(self.node),
    end_comparable: self.end.comparable(self.node),
  }
}

///|
pub struct WeakTextRange {
  node_id : NodeId
  start : @common.TextPosition
  end : @common.TextPosition
  start_comparable : (Array[Int], Int)
  end_comparable : (Array[Int], Int)
} derive(Eq, Debug)

///|
pub impl Show for WeakTextRange with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub fn WeakTextRange::node_id(self : WeakTextRange) -> NodeId {
  self.node_id
}

///|
pub fn WeakTextRange::start_comparable(
  self : WeakTextRange,
) -> (Array[Int], Int) {
  self.start_comparable
}

///|
pub fn WeakTextRange::end_comparable(self : WeakTextRange) -> (Array[Int], Int) {
  self.end_comparable
}

///|
pub fn WeakTextRange::upgrade_node(
  self : WeakTextRange,
  tree_state : State,
) -> Node? {
  tree_state.node_by_id(self.node_id).filter(Node::supports_text_ranges)
}

///|
pub fn WeakTextRange::upgrade(
  self : WeakTextRange,
  tree_state : State,
) -> TextRange? {
  let node = match self.upgrade_node(tree_state) {
    None => return None
    Some(node) => node
  }
  let start = match
    InnerTextPosition::upgrade(tree_state, self.start, self.node_id) {
    None => return None
    Some(v) => v
  }
  let end = match
    InnerTextPosition::upgrade(tree_state, self.end, self.node_id) {
    None => return None
    Some(v) => v
  }
  Some({ node, start, end })
}

///|
fn text_node_filter(root_id : NodeId, node : Node) -> FilterResult {
  if node.id() == root_id || node.role() == @common.Role::TextRun {
    FilterResult::Include
  } else {
    FilterResult::ExcludeNode
  }
}

///|
fn character_index_at_point(node : Node, point : @common.Point) -> Int {
  let rect = node.data().bounds().unwrap()
  let character_lengths = node.data().character_lengths()
  let positions = match node.data().character_positions() {
    Some(p) => p
    None => return 0
  }
  let widths = match node.data().character_widths() {
    Some(w) => w
    None => return 0
  }
  let direction = match node.text_direction() {
    Some(d) => d
    None => return 0
  }
  let len = positions.length()
  for i in 0..<len {
    let idx = len - 1 - i
    let position = positions[idx].to_double()
    let width = widths[idx].to_double()
    let relative_pos = match direction {
      @common.TextDirection::LeftToRight => point.x - rect.x0
      @common.TextDirection::RightToLeft => rect.x1 - point.x
      @common.TextDirection::TopToBottom => point.y - rect.y0
      @common.TextDirection::BottomToTop => rect.y1 - point.y
    }
    if relative_pos >= position && relative_pos < position + width {
      return idx
    }
  }
  character_lengths.length()
}

///|
fn hit_test_with_point(
  node : Node,
  point : @common.Point,
  filter : (Node) -> FilterResult,
) -> (Node, @common.Point)? {
  let filter_result = filter(node)
  if filter_result == FilterResult::ExcludeSubtree {
    return None
  }
  let children = node.children()
  let len = children.length()
  for i in 0..<len {
    let child = children[len - 1 - i]
    let child_point = child.direct_transform().inverse().transform_point(point)
    match hit_test_with_point(child, child_point, filter) {
      Some(v) => return Some(v)
      None => ()
    }
  }
  if filter_result == FilterResult::Include {
    match node.raw_bounds() {
      Some(rect) if rect.contains(point) => Some((node, point))
      _ => None
    }
  } else {
    None
  }
}

///|
fn[T] Node::fetch_inherited_property(
  self : Node,
  getter : (@common.Node) -> T?,
) -> T? {
  match getter(self.data()) {
    Some(v) => Some(v)
    None =>
      match self.parent() {
        Some(parent) => parent.fetch_inherited_property(getter)
        None => None
      }
  }
}

///|
fn Node::fetch_inherited_flag(
  self : Node,
  getter : (@common.Node) -> Bool,
) -> Bool {
  if getter(self.data()) {
    true
  } else {
    match self.parent() {
      Some(parent) => parent.fetch_inherited_flag(getter)
      None => false
    }
  }
}

///|
pub fn Node::text_direction(self : Node) -> @common.TextDirection? {
  self.fetch_inherited_property(node => node.text_direction())
}

///|
pub fn Node::font_family(self : Node) -> String? {
  self.fetch_inherited_property(node => node.font_family())
}

///|
pub fn Node::language(self : Node) -> String? {
  self.fetch_inherited_property(node => node.language())
}

///|
pub fn Node::font_size(self : Node) -> Float? {
  self.fetch_inherited_property(node => node.font_size())
}

///|
pub fn Node::font_weight(self : Node) -> Float? {
  self.fetch_inherited_property(node => node.font_weight())
}

///|
pub fn Node::background_color(self : Node) -> @common.Color? {
  self.fetch_inherited_property(node => node.background_color())
}

///|
pub fn Node::foreground_color(self : Node) -> @common.Color? {
  self.fetch_inherited_property(node => node.foreground_color())
}

///|
pub fn Node::overline(self : Node) -> @common.TextDecoration? {
  self.fetch_inherited_property(node => node.overline())
}

///|
pub fn Node::strikethrough(self : Node) -> @common.TextDecoration? {
  self.fetch_inherited_property(node => node.strikethrough())
}

///|
pub fn Node::underline(self : Node) -> @common.TextDecoration? {
  self.fetch_inherited_property(node => node.underline())
}

///|
pub fn Node::text_align(self : Node) -> @common.TextAlign? {
  self.fetch_inherited_property(node => node.text_align())
}

///|
pub fn Node::vertical_offset(self : Node) -> @common.VerticalOffset? {
  self.fetch_inherited_property(node => node.vertical_offset())
}

///|
pub fn Node::is_italic(self : Node) -> Bool {
  self.fetch_inherited_flag(node => node.is_italic())
}

///|
fn Node::text_attributes_differ(self : Node, other : Node) -> Bool {
  self.font_family() != other.font_family() ||
  self.language() != other.language() ||
  self.font_size() != other.font_size() ||
  self.font_weight() != other.font_weight() ||
  self.background_color() != other.background_color() ||
  self.foreground_color() != other.foreground_color() ||
  self.overline() != other.overline() ||
  self.strikethrough() != other.strikethrough() ||
  self.underline() != other.underline() ||
  self.text_align() != other.text_align() ||
  self.vertical_offset() != other.vertical_offset()
}

///|
pub fn Node::text_runs(self : Node) -> Array[Node] {
  let id = self.id()
  self.filtered_children(node => text_node_filter(id, node))
}

///|
fn Node::following_text_runs(self : Node, root_node : Node) -> Array[Node] {
  let id = root_node.id()
  self.following_filtered_siblings(node => text_node_filter(id, node))
}

///|
fn Node::preceding_text_runs(self : Node, root_node : Node) -> Array[Node] {
  let id = root_node.id()
  self.preceding_filtered_siblings(node => text_node_filter(id, node))
}

///|
pub fn Node::supports_text_ranges(self : Node) -> Bool {
  let role = self.role()
  let supported = self.is_text_input() ||
    role == @common.Role::Label ||
    role == @common.Role::Document ||
    role == @common.Role::Terminal
  supported && self.text_runs().length() > 0
}

///|
fn Node::document_start_inner(self : Node) -> InnerTextPosition {
  let node = self.text_runs()[0]
  { node, character_index: 0 }
}

///|
pub fn Node::document_start(self : Node) -> TextPosition {
  { root_node: self, inner: self.document_start_inner() }
}

///|
fn Node::document_end_inner(self : Node) -> InnerTextPosition {
  let runs = self.text_runs()
  let node = runs[runs.length() - 1]
  { node, character_index: node.data().character_lengths().length() }
}

///|
pub fn Node::document_end(self : Node) -> TextPosition {
  { root_node: self, inner: self.document_end_inner() }
}

///|
pub fn Node::document_range(self : Node) -> TextRange {
  TextRange::TextRange(
    self,
    self.document_start_inner(),
    self.document_end_inner(),
  )
}

///|
pub fn Node::has_text_selection(self : Node) -> Bool {
  self.data().text_selection() is Some(_)
}

///|
pub fn Node::text_selection(self : Node) -> TextRange? {
  let id = self.id()
  self
  .data()
  .text_selection()
  .map(sel => {
    let anchor = InnerTextPosition::clamped_upgrade(
      self.tree_state,
      sel.anchor,
      id,
    ).unwrap()
    let focus = InnerTextPosition::clamped_upgrade(
      self.tree_state,
      sel.focus,
      id,
    ).unwrap()
    TextRange::TextRange(self, anchor, focus)
  })
}

///|
pub fn Node::text_selection_anchor(self : Node) -> TextPosition? {
  let id = self.id()
  self
  .data()
  .text_selection()
  .map(sel => {
    let anchor = InnerTextPosition::clamped_upgrade(
      self.tree_state,
      sel.anchor,
      id,
    ).unwrap()
    { root_node: self, inner: anchor }
  })
}

///|
pub fn Node::text_selection_focus(self : Node) -> TextPosition? {
  let id = self.id()
  self
  .data()
  .text_selection()
  .map(sel => {
    let focus = InnerTextPosition::clamped_upgrade(
      self.tree_state,
      sel.focus,
      id,
    ).unwrap()
    { root_node: self, inner: focus }
  })
}

///|
pub fn Node::text_position_at_point(
  self : Node,
  point : @common.Point,
) -> TextPosition {
  let id = self.id()
  match hit_test_with_point(self, point, node => text_node_filter(id, node)) {
    Some((node, p)) =>
      if node.role() == @common.Role::TextRun {
        let pos = { node, character_index: character_index_at_point(node, p) }
        return { root_node: self, inner: pos }
      }
    None => ()
  }
  let runs0 = self.text_runs()
  if runs0.length() > 0 {
    let first = runs0[0]
    match first.bounding_box_in_coordinate_space(self) {
      Some(rect) =>
        if point.x < rect.x0 || point.y < rect.y0 {
          return self.document_start()
        }
      None => ()
    }
  }
  let runs = self.text_runs()
  let len = runs.length()
  for i in 0..<len {
    let node = runs[len - 1 - i]
    match node.bounding_box_in_coordinate_space(self) {
      None => ()
      Some(rect) =>
        match node.text_direction() {
          None => ()
          Some(direction) => {
            let is_past_end = match direction {
              @common.TextDirection::LeftToRight =>
                point.y >= rect.y0 && point.y < rect.y1 && point.x >= rect.x1
              @common.TextDirection::RightToLeft =>
                point.y >= rect.y0 && point.y < rect.y1 && point.x < rect.x0
              @common.TextDirection::TopToBottom =>
                point.x >= rect.x0 && point.x < rect.x1 && point.y >= rect.y1
              @common.TextDirection::BottomToTop =>
                point.x >= rect.x0 && point.x < rect.x1 && point.y < rect.y0
            }
            if is_past_end {
              return {
                root_node: self,
                inner: {
                  node,
                  character_index: node.data().character_lengths().length(),
                },
              }
            }
          }
        }
    }
  }
  self.document_end()
}

///|
pub fn Node::line_range_from_index(self : Node, line_index : Int) -> TextRange? {
  let mut pos = self.document_start()
  if line_index > 0 {
    if pos.is_document_end() || pos.forward_to_line_end().is_document_end() {
      return None
    }
    for _ in 0..<line_index {
      if pos.is_document_end() {
        return None
      }
      pos = pos.forward_to_line_start()
    }
  }
  let end = if pos.is_document_end() { pos } else { pos.forward_to_line_end() }
  Some(TextRange::TextRange(self, pos.inner, end.inner))
}

///|
pub fn Node::text_position_from_global_usv_index(
  self : Node,
  index : Int,
) -> TextPosition? {
  let mut total_length = 0
  for node in self.text_runs() {
    let node_text = node.data().value().unwrap()
    let node_text_length = count_chars(node_text)
    let new_total_length = total_length + node_text_length
    if index >= total_length && index < new_total_length {
      let mut utf8_length = 0
      let mut usv_length = 0
      let target = index - total_length
      let lengths = node.data().character_lengths()
      let node_bytes = @utf8.encode(node_text[:])
      for character_index in 0..<lengths.length() {
        let utf8_char_length = lengths[character_index]
        let new_utf8_length = utf8_length + utf8_char_length
        let char_str = @utf8.decode_lossy(
          node_bytes[:][utf8_length:new_utf8_length],
        )
        let usv_char_length = count_chars(char_str)
        let new_usv_length = usv_length + usv_char_length
        if target >= usv_length && target < new_usv_length {
          return Some({ root_node: self, inner: { node, character_index } })
        }
        utf8_length = new_utf8_length
        usv_length = new_usv_length
      }
      abort("index out of range")
    }
    total_length = new_total_length
  }
  if index == total_length {
    Some(self.document_end())
  } else {
    None
  }
}

///|
pub fn Node::text_position_from_global_utf16_index(
  self : Node,
  index : Int,
) -> TextPosition? {
  let mut total_length = 0
  for node in self.text_runs() {
    let node_text = node.data().value().unwrap()
    let node_text_length = utf16_len(node_text)
    let new_total_length = total_length + node_text_length
    if index >= total_length && index < new_total_length {
      let mut utf8_length = 0
      let mut utf16_length = 0
      let target = index - total_length
      let lengths = node.data().character_lengths()
      let node_bytes = @utf8.encode(node_text[:])
      for character_index in 0..<lengths.length() {
        let utf8_char_length = lengths[character_index]
        let new_utf8_length = utf8_length + utf8_char_length
        let char_str = @utf8.decode_lossy(
          node_bytes[:][utf8_length:new_utf8_length],
        )
        let utf16_char_length = utf16_len(char_str)
        let new_utf16_length = utf16_length + utf16_char_length
        if target >= utf16_length && target < new_utf16_length {
          return Some({ root_node: self, inner: { node, character_index } })
        }
        utf8_length = new_utf8_length
        utf16_length = new_utf16_length
      }
      abort("index out of range")
    }
    total_length = new_total_length
  }
  if index == total_length {
    Some(self.document_end())
  } else {
    None
  }
}

///|
pub fn TextRange::text_direction(
  self : TextRange,
) -> RangePropertyValue[@common.TextDirection?] {
  self.fetch_property(Node::text_direction)
}

///|
pub fn TextRange::font_family(self : TextRange) -> RangePropertyValue[String?] {
  self.fetch_property(Node::font_family)
}

///|
pub fn TextRange::language(self : TextRange) -> RangePropertyValue[String?] {
  self.fetch_property(Node::language)
}

///|
pub fn TextRange::font_size(self : TextRange) -> RangePropertyValue[Float?] {
  self.fetch_property(Node::font_size)
}

///|
pub fn TextRange::font_weight(self : TextRange) -> RangePropertyValue[Float?] {
  self.fetch_property(Node::font_weight)
}

///|
pub fn TextRange::background_color(
  self : TextRange,
) -> RangePropertyValue[@common.Color?] {
  self.fetch_property(Node::background_color)
}

///|
pub fn TextRange::foreground_color(
  self : TextRange,
) -> RangePropertyValue[@common.Color?] {
  self.fetch_property(Node::foreground_color)
}

///|
pub fn TextRange::overline(
  self : TextRange,
) -> RangePropertyValue[@common.TextDecoration?] {
  self.fetch_property(Node::overline)
}

///|
pub fn TextRange::strikethrough(
  self : TextRange,
) -> RangePropertyValue[@common.TextDecoration?] {
  self.fetch_property(Node::strikethrough)
}

///|
pub fn TextRange::underline(
  self : TextRange,
) -> RangePropertyValue[@common.TextDecoration?] {
  self.fetch_property(Node::underline)
}

///|
pub fn TextRange::text_align(
  self : TextRange,
) -> RangePropertyValue[@common.TextAlign?] {
  self.fetch_property(Node::text_align)
}

///|
pub fn TextRange::vertical_offset(
  self : TextRange,
) -> RangePropertyValue[@common.VerticalOffset?] {
  self.fetch_property(Node::vertical_offset)
}

///|
pub fn TextRange::is_italic(self : TextRange) -> RangePropertyValue[Bool] {
  self.fetch_property(Node::is_italic)
}

///|
pub fn TextPosition::text_direction(
  self : TextPosition,
) -> @common.TextDirection? {
  self.inner.node.text_direction()
}

///|
pub fn TextPosition::font_family(self : TextPosition) -> String? {
  self.inner.node.font_family()
}

///|
pub fn TextPosition::language(self : TextPosition) -> String? {
  self.inner.node.language()
}

///|
pub fn TextPosition::font_size(self : TextPosition) -> Float? {
  self.inner.node.font_size()
}

///|
pub fn TextPosition::font_weight(self : TextPosition) -> Float? {
  self.inner.node.font_weight()
}

///|
pub fn TextPosition::background_color(self : TextPosition) -> @common.Color? {
  self.inner.node.background_color()
}

///|
pub fn TextPosition::foreground_color(self : TextPosition) -> @common.Color? {
  self.inner.node.foreground_color()
}

///|
pub fn TextPosition::overline(self : TextPosition) -> @common.TextDecoration? {
  self.inner.node.overline()
}

///|
pub fn TextPosition::strikethrough(
  self : TextPosition,
) -> @common.TextDecoration? {
  self.inner.node.strikethrough()
}

///|
pub fn TextPosition::underline(self : TextPosition) -> @common.TextDecoration? {
  self.inner.node.underline()
}

///|
pub fn TextPosition::text_align(self : TextPosition) -> @common.TextAlign? {
  self.inner.node.text_align()
}

///|
pub fn TextPosition::vertical_offset(
  self : TextPosition,
) -> @common.VerticalOffset? {
  self.inner.node.vertical_offset()
}

///|
pub fn TextPosition::is_italic(self : TextPosition) -> Bool {
  self.inner.node.is_italic()
}
