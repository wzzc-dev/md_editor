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
fn[T : Debug] show_via_debug(value : T, logger : &Logger) -> Unit {
  logger.write_string(@debug.to_string(value))
}

///|
pub struct NodeId(TreeIndex, @common.NodeId) derive(Eq, Debug, Hash)

///|
pub impl Show for NodeId with output(self, logger) {
  show_via_debug(self, logger)
}

///|
fn NodeId::with_same_tree(self : NodeId, local_id : @common.NodeId) -> NodeId {
  NodeId(self.0, local_id)
}

///|
pub fn NodeId::to_components(self : NodeId) -> (@common.NodeId, TreeIndex) {
  (self.1, self.0)
}

///|
pub(all) struct ParentAndIndex(NodeId, Int) derive(Eq, Debug)

///|
pub impl Show for ParentAndIndex with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub(all) struct NodeState {
  mut parent_and_index : ParentAndIndex?
  data : @common.Node
}

///|
pub struct Node {
  priv tree_state : State
  priv id : NodeId
}

///|
fn Node::state(self : Node) -> NodeState {
  self.tree_state.nodes.get(self.id).unwrap()
}

///|
pub fn Node::data(self : Node) -> @common.Node {
  self.state().data
}

///|
pub fn Node::id(self : Node) -> NodeId {
  self.id
}

///|
pub fn Node::role(self : Node) -> @common.Role {
  self.data().role()
}

///|
pub fn Node::is_hidden(self : Node) -> Bool {
  let mut current = Some(self)
  while current is Some(node) {
    if node.data().is_hidden() {
      return true
    }
    current = node.parent()
  }
  false
}

///|
pub fn Node::clips_children(self : Node) -> Bool {
  self.data().clips_children()
}

///|
pub fn Node::is_graft(self : Node) -> Bool {
  self.data().tree_id() is Some(_)
}

///|
pub fn Node::is_root(self : Node) -> Bool {
  self.id() == self.tree_state.root_id()
}

///|
pub fn Node::parent_id(self : Node) -> NodeId? {
  self.state().parent_and_index.map(pi => pi.0)
}

///|
pub fn Node::parent(self : Node) -> Node? {
  self.parent_id().map(id => self.tree_state.node_by_id(id).unwrap())
}

///|
pub fn Node::filtered_parent(
  self : Node,
  filter : (Node) -> FilterResult,
) -> Node? {
  match self.parent() {
    None => None
    Some(parent) =>
      if filter(parent) == FilterResult::Include {
        Some(parent)
      } else {
        parent.filtered_parent(filter)
      }
  }
}

///|
pub fn Node::parent_and_index(self : Node) -> (Node, Int)? {
  self.state().parent_and_index.map(pi => {
    (self.tree_state.node_by_id(pi.0).unwrap(), pi.1)
  })
}

///|
pub fn Node::index_path(self : Node) -> Array[Int] {
  self.relative_index_path(self.tree_state.root_id())
}

///|
pub fn Node::relative_index_path(
  self : Node,
  ancestor_id : NodeId,
) -> Array[Int] {
  let reversed : Array[Int] = []
  let mut current = self
  while current.id() != ancestor_id {
    let (parent, index) = current.parent_and_index().unwrap()
    reversed.push(index)
    current = parent
  }
  let out : Array[Int] = []
  let len = reversed.length()
  for i in 0..<len {
    out.push(reversed[len - 1 - i])
  }
  out
}

///|
fn Node::graft_child_id(self : Node) -> NodeId? {
  match self.data().tree_id() {
    None => None
    Some(tree_id) => self.tree_state.subtree_root(tree_id)
  }
}

///|
pub fn Node::child_ids(self : Node) -> Array[NodeId] {
  if self.is_graft() {
    match self.graft_child_id() {
      Some(id) => [id]
      None => []
    }
  } else {
    let ids : Array[NodeId] = []
    for child in self.data().children() {
      ids.push(self.id.with_same_tree(child))
    }
    ids
  }
}

///|
pub fn Node::children(self : Node) -> Array[Node] {
  let out : Array[Node] = []
  for child_id in self.child_ids() {
    out.push(self.tree_state.node_by_id(child_id).unwrap())
  }
  out
}

///|
fn Node::first_child(self : Node) -> Node? {
  let children = self.children()
  if children.length() == 0 {
    None
  } else {
    Some(children[0])
  }
}

///|
fn Node::last_child(self : Node) -> Node? {
  let children = self.children()
  let len = children.length()
  if len == 0 {
    None
  } else {
    Some(children[len - 1])
  }
}

///|
pub fn Node::deepest_first_child(self : Node) -> Node? {
  let children = self.children()
  if children.length() == 0 {
    None
  } else {
    let mut deepest = children[0]
    let mut next = deepest.first_child()
    while next is Some(child) {
      deepest = child
      next = deepest.first_child()
    }
    Some(deepest)
  }
}

///|
pub fn Node::deepest_last_child(self : Node) -> Node? {
  let children = self.children()
  let len = children.length()
  if len == 0 {
    None
  } else {
    let mut deepest = children[len - 1]
    let mut next = deepest.last_child()
    while next is Some(child) {
      deepest = child
      next = deepest.last_child()
    }
    Some(deepest)
  }
}

///|
pub fn Node::deepest_first_filtered_child(
  self : Node,
  filter : (Node) -> FilterResult,
) -> Node? {
  let mut deepest = match self.first_filtered_child(filter) {
    None => return None
    Some(node) => node
  }
  let mut next = deepest.first_filtered_child(filter)
  while next is Some(child) {
    deepest = child
    next = deepest.first_filtered_child(filter)
  }
  Some(deepest)
}

///|
pub fn Node::deepest_last_filtered_child(
  self : Node,
  filter : (Node) -> FilterResult,
) -> Node? {
  let mut deepest = match self.last_filtered_child(filter) {
    None => return None
    Some(node) => node
  }
  let mut next = deepest.last_filtered_child(filter)
  while next is Some(child) {
    deepest = child
    next = deepest.last_filtered_child(filter)
  }
  Some(deepest)
}

///|
pub fn Node::is_descendant_of(self : Node, other : Node) -> Bool {
  let other_id = other.id()
  let mut current = self.parent()
  while current is Some(node) {
    if node.id() == other_id {
      return true
    }
    current = node.parent()
  }
  false
}

///|
fn Node::next_sibling(self : Node) -> Node? {
  match self.parent_and_index() {
    None => None
    Some((parent, index)) => {
      let siblings = parent.child_ids()
      let next_index = index + 1
      if next_index >= siblings.length() {
        None
      } else {
        self.tree_state.node_by_id(siblings[next_index])
      }
    }
  }
}

///|
fn Node::previous_sibling(self : Node) -> Node? {
  match self.parent_and_index() {
    None => None
    Some((parent, index)) =>
      if index <= 0 {
        None
      } else {
        let siblings = parent.child_ids()
        self.tree_state.node_by_id(siblings[index - 1])
      }
  }
}

///|
pub fn Node::following_sibling_ids(self : Node) -> Array[NodeId] {
  match self.parent_and_index() {
    None => []
    Some((parent, index)) => {
      let siblings = parent.child_ids()
      let out : Array[NodeId] = []
      let start = index + 1
      if start >= siblings.length() {
        out
      } else {
        for i in start..<siblings.length() {
          out.push(siblings[i])
        }
        out
      }
    }
  }
}

///|
pub fn Node::following_siblings(self : Node) -> Array[Node] {
  let out : Array[Node] = []
  for id in self.following_sibling_ids() {
    out.push(self.tree_state.node_by_id(id).unwrap())
  }
  out
}

///|
pub fn Node::preceding_sibling_ids(self : Node) -> Array[NodeId] {
  match self.parent_and_index() {
    None => []
    Some((parent, index)) => {
      let siblings = parent.child_ids()
      let out : Array[NodeId] = []
      if index <= 0 {
        out
      } else {
        for i in 0..<index {
          out.push(siblings[index - 1 - i])
        }
        out
      }
    }
  }
}

///|
pub fn Node::preceding_siblings(self : Node) -> Array[Node] {
  let out : Array[Node] = []
  for id in self.preceding_sibling_ids() {
    out.push(self.tree_state.node_by_id(id).unwrap())
  }
  out
}

///|
pub fn Node::filtered_children(
  self : Node,
  filter : (Node) -> FilterResult,
) -> Array[Node] {
  let out : Array[Node] = []
  fn push_filtered(
    out : Array[Node],
    node : Node,
    filter : (Node) -> FilterResult,
  ) -> Unit {
    match filter(node) {
      FilterResult::Include => out.push(node)
      FilterResult::ExcludeNode =>
        for child in node.filtered_children(filter) {
          out.push(child)
        }
      FilterResult::ExcludeSubtree => ()
    }
  }

  for child in self.children() {
    push_filtered(out, child, filter)
  }
  out
}

///|
pub fn Node::first_filtered_child(
  self : Node,
  filter : (Node) -> FilterResult,
) -> Node? {
  for child in self.children() {
    match filter(child) {
      FilterResult::Include => return Some(child)
      FilterResult::ExcludeNode =>
        match child.first_filtered_child(filter) {
          Some(found) => return Some(found)
          None => ()
        }
      FilterResult::ExcludeSubtree => ()
    }
  }
  None
}

///|
pub fn Node::last_filtered_child(
  self : Node,
  filter : (Node) -> FilterResult,
) -> Node? {
  let children = self.children()
  let len = children.length()
  for i in 0..<len {
    let child = children[len - 1 - i]
    match filter(child) {
      FilterResult::Include => return Some(child)
      FilterResult::ExcludeNode =>
        match child.last_filtered_child(filter) {
          Some(found) => return Some(found)
          None => ()
        }
      FilterResult::ExcludeSubtree => ()
    }
  }
  None
}

///|
fn next_filtered_sibling(
  node : Node?,
  filter : (Node) -> FilterResult,
) -> Node? {
  fn step(current : Node?, consider_children : Bool) -> Node? {
    match current {
      None => None
      Some(current) =>
        if consider_children {
          match current.first_child() {
            None => step(Some(current), false)
            Some(child) =>
              match filter(child) {
                FilterResult::Include => Some(child)
                FilterResult::ExcludeNode => step(Some(child), true)
                FilterResult::ExcludeSubtree => step(Some(child), false)
              }
          }
        } else {
          match current.next_sibling() {
            Some(sibling) =>
              match filter(sibling) {
                FilterResult::Include => Some(sibling)
                FilterResult::ExcludeNode => step(Some(sibling), true)
                FilterResult::ExcludeSubtree => step(Some(sibling), false)
              }
            None =>
              match current.parent() {
                None => None
                Some(parent) =>
                  if filter(parent) != FilterResult::ExcludeNode {
                    None
                  } else {
                    step(Some(parent), false)
                  }
              }
          }
        }
    }
  }

  step(node, false)
}

///|
fn previous_filtered_sibling(
  node : Node?,
  filter : (Node) -> FilterResult,
) -> Node? {
  fn step(current : Node?, consider_children : Bool) -> Node? {
    match current {
      None => None
      Some(current) =>
        if consider_children {
          match current.last_child() {
            None => step(Some(current), false)
            Some(child) =>
              match filter(child) {
                FilterResult::Include => Some(child)
                FilterResult::ExcludeNode => step(Some(child), true)
                FilterResult::ExcludeSubtree => step(Some(child), false)
              }
          }
        } else {
          match current.previous_sibling() {
            Some(sibling) =>
              match filter(sibling) {
                FilterResult::Include => Some(sibling)
                FilterResult::ExcludeNode => step(Some(sibling), true)
                FilterResult::ExcludeSubtree => step(Some(sibling), false)
              }
            None =>
              match current.parent() {
                None => None
                Some(parent) =>
                  if filter(parent) != FilterResult::ExcludeNode {
                    None
                  } else {
                    step(Some(parent), false)
                  }
              }
          }
        }
    }
  }

  step(node, false)
}

///|
pub fn Node::following_filtered_siblings(
  self : Node,
  filter : (Node) -> FilterResult,
) -> Array[Node] {
  let out : Array[Node] = []
  let back = match self.filtered_parent(filter) {
    None => None
    Some(parent) => parent.last_filtered_child(filter)
  }
  match (next_filtered_sibling(Some(self), filter), back) {
    (Some(front), Some(back)) => {
      let back_id = back.id()
      fn collect(current : Node?) -> Unit {
        match current {
          None => ()
          Some(current) => {
            out.push(current)
            if current.id() == back_id {
              ()
            } else {
              collect(next_filtered_sibling(Some(current), filter))
            }
          }
        }
      }

      collect(Some(front))
      out
    }
    _ => out
  }
}

///|
pub fn Node::preceding_filtered_siblings(
  self : Node,
  filter : (Node) -> FilterResult,
) -> Array[Node] {
  let out : Array[Node] = []
  let back = match self.filtered_parent(filter) {
    None => None
    Some(parent) => parent.first_filtered_child(filter)
  }
  match (previous_filtered_sibling(Some(self), filter), back) {
    (Some(front), Some(back)) => {
      let back_id = back.id()
      fn collect(current : Node?) -> Unit {
        match current {
          None => ()
          Some(current) => {
            out.push(current)
            if current.id() == back_id {
              ()
            } else {
              collect(previous_filtered_sibling(Some(current), filter))
            }
          }
        }
      }

      collect(Some(front))
      out
    }
    _ => out
  }
}

///|
fn descendant_label_filter(node : Node) -> FilterResult {
  match node.role() {
    @common.Role::Label | @common.Role::Image => FilterResult::Include
    @common.Role::GenericContainer => FilterResult::ExcludeNode
    _ => FilterResult::ExcludeSubtree
  }
}

///|
pub fn Node::labelled_by(self : Node) -> Array[Node] {
  let explicit = self.data().labelled_by()
  let role = self.role()
  let use_descendants = explicit.length() == 0 &&
    (
      role == @common.Role::Button ||
      role == @common.Role::CheckBox ||
      role == @common.Role::DefaultButton ||
      role == @common.Role::Link ||
      role == @common.Role::MenuItem ||
      role == @common.Role::MenuItemCheckBox ||
      role == @common.Role::MenuItemRadio ||
      role == @common.Role::RadioButton
    )
  if use_descendants {
    self.filtered_children(descendant_label_filter)
  } else {
    let out : Array[Node] = []
    for local_id in explicit {
      let id = self.id.with_same_tree(local_id)
      if self.tree_state.node_by_id(id) is Some(node) {
        out.push(node)
      }
    }
    out
  }
}

///|
fn Node::write_label_direct(self : Node, buf : StringBuilder) -> Bool {
  match self.data().label() {
    Some(label) => {
      buf.write_string(label)
      true
    }
    None => false
  }
}

///|
pub fn Node::write_label(self : Node, buf : StringBuilder) -> Bool {
  if self.write_label_direct(buf) {
    true
  } else {
    let mut wrote_one = false
    for node in self.labelled_by() {
      let tmp = StringBuilder::new()
      let wrote_this_time = if node.label_comes_from_value() {
        node.write_value(tmp)
      } else {
        node.write_label_direct(tmp)
      }
      if wrote_this_time {
        if wrote_one {
          buf.write_string(" ")
        }
        buf.write_string(tmp.to_string())
        wrote_one = true
      }
    }
    wrote_one
  }
}

///|
pub fn Node::label(self : Node) -> String? {
  let buf = StringBuilder::new()
  if self.write_label(buf) {
    Some(buf.to_string())
  } else {
    None
  }
}

///|
pub fn Node::is_text_input(self : Node) -> Bool {
  match self.role() {
    @common.Role::TextInput
    | @common.Role::MultilineTextInput
    | @common.Role::SearchInput
    | @common.Role::DateInput
    | @common.Role::DateTimeInput
    | @common.Role::WeekInput
    | @common.Role::MonthInput
    | @common.Role::TimeInput
    | @common.Role::EmailInput
    | @common.Role::NumberInput
    | @common.Role::PasswordInput
    | @common.Role::PhoneNumberInput
    | @common.Role::UrlInput
    | @common.Role::EditableComboBox
    | @common.Role::SpinButton => true
    _ => false
  }
}

///|
fn Node::is_empty_text_input(self : Node) -> Bool {
  let text_runs = self.filtered_children(node => {
    if node.role() == @common.Role::TextRun {
      FilterResult::Include
    } else {
      FilterResult::ExcludeNode
    }
  })
  if text_runs.length() == 0 {
    true
  } else {
    let first = text_runs[0]
    let value_empty = match first.data().value() {
      None => true
      Some(value) => value.length() == 0
    }
    value_empty && text_runs.length() == 1
  }
}

///|
pub fn Node::placeholder(self : Node) -> String? {
  match self.data().placeholder() {
    None => None
    Some(placeholder) =>
      if self.is_text_input() && self.is_empty_text_input() {
        Some(placeholder)
      } else {
        None
      }
  }
}

///|
fn Node::hit_test(
  self : Node,
  point : @common.Point,
  filter : (Node) -> FilterResult,
) -> Node? {
  let filter_result = filter(self)
  if filter_result == FilterResult::ExcludeSubtree {
    return None
  }
  let children = self.children()
  let len = children.length()
  for i in 0..<len {
    let child = children[len - 1 - i]
    let child_point = child.direct_transform().inverse().transform_point(point)
    match child.hit_test(child_point, filter) {
      Some(found) => return Some(found)
      None => ()
    }
  }
  if filter_result == FilterResult::Include {
    match self.raw_bounds() {
      Some(rect) if rect.contains(point) => return Some(self)
      _ => ()
    }
  }
  None
}

///|
pub fn Node::node_at_point(
  self : Node,
  point : @common.Point,
  filter : (Node) -> FilterResult,
) -> Node? {
  self.hit_test(point, filter)
}

///|
pub fn Node::direct_transform(self : Node) -> @common.Affine {
  match self.data().transform() {
    Some(value) => value
    None => @common.Affine::scale(1.0)
  }
}

///|
pub fn Node::transform(self : Node) -> @common.Affine {
  match self.parent() {
    Some(parent) => parent.transform().mul(self.direct_transform())
    None => self.direct_transform()
  }
}

///|
fn Node::relative_transform(self : Node, stop_at : Node) -> @common.Affine {
  let parent_transform = match self.parent() {
    None => @common.Affine::scale(1.0)
    Some(parent) =>
      if parent.id() == stop_at.id() {
        @common.Affine::scale(1.0)
      } else {
        parent.relative_transform(stop_at)
      }
  }
  parent_transform.mul(self.direct_transform())
}

///|
pub fn Node::raw_bounds(self : Node) -> @common.Rect? {
  self.data().bounds()
}

///|
pub fn Node::has_bounds(self : Node) -> Bool {
  self.raw_bounds() is Some(_)
}

///|
pub fn Node::bounding_box(self : Node) -> @common.Rect? {
  self.raw_bounds().map(rect => self.transform().transform_rect_bbox(rect))
}

///|
fn Node::bounding_box_in_coordinate_space(
  self : Node,
  other : Node,
) -> @common.Rect? {
  self
  .raw_bounds()
  .map(rect => self.relative_transform(other).transform_rect_bbox(rect))
}

///|
pub fn Node::is_focused_in_tree(self : Node) -> Bool {
  self.tree_state.focus_id_in_tree() == self.id()
}

///|
pub fn Node::active_descendant(self : Node) -> Node? {
  self
  .data()
  .active_descendant()
  .map(id => self.tree_state.node_by_id(self.id.with_same_tree(id)).unwrap())
}

///|
pub fn Node::is_focused(self : Node) -> Bool {
  // Ported from Rust: handle active_descendant dominance.
  fn dominated_by_active_descendant(node_id : NodeId) -> Bool {
    match self.tree_state.node_by_id(node_id) {
      Some(node) => node.active_descendant() is Some(_)
      None => false
    }
  }

  match self.tree_state.focus_id() {
    Some(focus_id) if focus_id == self.id() =>
      !dominated_by_active_descendant(focus_id)
    Some(focus_id) =>
      match self.tree_state.node_by_id(focus_id) {
        None => false
        Some(focused) =>
          focused
          .active_descendant()
          .map(ad => ad.id() == self.id())
          .unwrap_or(false)
      }
    None => false
  }
}

///|
pub fn Node::is_focusable(
  self : Node,
  parent_filter : (Node) -> FilterResult,
) -> Bool {
  self.supports_action(@common.Action::Focus, parent_filter) ||
  self.is_focused_in_tree()
}

///|
pub fn Node::role_description(self : Node) -> String? {
  self.data().role_description()
}

///|
pub fn Node::has_role_description(self : Node) -> Bool {
  self.role_description() is Some(_)
}

///|
pub fn Node::is_live_atomic(self : Node) -> Bool {
  self.data().is_live_atomic()
}

///|
pub fn Node::is_busy(self : Node) -> Bool {
  self.data().is_busy()
}

///|
pub fn Node::column_index_text(self : Node) -> String? {
  self.data().column_index_text()
}

///|
pub fn Node::row_index_text(self : Node) -> String? {
  self.data().row_index_text()
}

///|
pub fn Node::braille_label(self : Node) -> String? {
  self.data().braille_label()
}

///|
pub fn Node::has_braille_label(self : Node) -> Bool {
  self.braille_label() is Some(_)
}

///|
pub fn Node::braille_role_description(self : Node) -> String? {
  self.data().braille_role_description()
}

///|
pub fn Node::has_braille_role_description(self : Node) -> Bool {
  self.braille_role_description() is Some(_)
}

///|
pub fn Node::aria_current(self : Node) -> @common.AriaCurrent? {
  self.data().aria_current()
}

///|
pub fn Node::has_popup(self : Node) -> @common.HasPopup? {
  self.data().has_popup()
}

///|
pub fn Node::level(self : Node) -> Int? {
  self.data().level()
}

///|
pub fn Node::is_disabled(self : Node) -> Bool {
  self.data().is_disabled()
}

///|
pub fn Node::is_read_only(self : Node) -> Bool {
  self.data().is_read_only()
}

///|
pub fn Node::is_read_only_or_disabled(self : Node) -> Bool {
  self.is_read_only() || self.is_disabled()
}

///|
pub fn Node::toggled(self : Node) -> @common.Toggled? {
  self.data().toggled()
}

///|
pub fn Node::numeric_value(self : Node) -> Double? {
  self.data().numeric_value()
}

///|
pub fn Node::min_numeric_value(self : Node) -> Double? {
  self.data().min_numeric_value()
}

///|
pub fn Node::max_numeric_value(self : Node) -> Double? {
  self.data().max_numeric_value()
}

///|
pub fn Node::numeric_value_step(self : Node) -> Double? {
  self.data().numeric_value_step()
}

///|
pub fn Node::numeric_value_jump(self : Node) -> Double? {
  self.data().numeric_value_jump()
}

///|
pub fn Node::scroll_x(self : Node) -> Double? {
  self.data().scroll_x()
}

///|
pub fn Node::scroll_x_min(self : Node) -> Double? {
  self.data().scroll_x_min()
}

///|
pub fn Node::scroll_x_max(self : Node) -> Double? {
  self.data().scroll_x_max()
}

///|
pub fn Node::scroll_y(self : Node) -> Double? {
  self.data().scroll_y()
}

///|
pub fn Node::scroll_y_min(self : Node) -> Double? {
  self.data().scroll_y_min()
}

///|
pub fn Node::scroll_y_max(self : Node) -> Double? {
  self.data().scroll_y_max()
}

///|
pub fn Node::is_multiline(self : Node) -> Bool {
  self.role() == @common.Role::MultilineTextInput
}

///|
pub fn Node::orientation(self : Node) -> @common.Orientation? {
  match self.data().orientation() {
    Some(o) => Some(o)
    None =>
      if self.role() == @common.Role::ListBox {
        Some(@common.Orientation::Vertical)
      } else if self.role() == @common.Role::TabList {
        Some(@common.Orientation::Horizontal)
      } else {
        None
      }
  }
}

///|
pub fn Node::is_dialog(self : Node) -> Bool {
  let role = self.role()
  role == @common.Role::AlertDialog || role == @common.Role::Dialog
}

///|
pub fn Node::is_modal(self : Node) -> Bool {
  self.data().is_modal()
}

///|
pub fn Node::is_clickable(
  self : Node,
  parent_filter : (Node) -> FilterResult,
) -> Bool {
  self.supports_action(@common.Action::Click, parent_filter)
}

///|
pub fn Node::is_selectable(self : Node) -> Bool {
  self.is_selected() is Some(_) && !self.is_disabled()
}

///|
pub fn Node::is_multiselectable(self : Node) -> Bool {
  self.data().is_multiselectable()
}

///|
pub fn Node::size_of_set_from_container(
  self : Node,
  filter : (Node) -> FilterResult,
) -> Int? {
  match self.selection_container(filter) {
    None => None
    Some(container) => container.size_of_set()
  }
}

///|
pub fn Node::size_of_set(self : Node) -> Int? {
  self.data().size_of_set()
}

///|
pub fn Node::position_in_set(self : Node) -> Int? {
  self.data().position_in_set()
}

///|
pub fn Node::sort_direction(self : Node) -> @common.SortDirection? {
  self.data().sort_direction()
}

///|
pub fn Node::supports_toggle(self : Node) -> Bool {
  self.toggled() is Some(_)
}

///|
pub fn Node::supports_expand_collapse(self : Node) -> Bool {
  self.data().is_expanded() is Some(_)
}

///|
pub fn Node::is_invocable(
  self : Node,
  parent_filter : (Node) -> FilterResult,
) -> Bool {
  self.is_clickable(parent_filter) &&
  !self.is_text_input() &&
  (
    self.role() != @common.Role::Document &&
    self.role() != @common.Role::Terminal
  ) &&
  !self.supports_toggle() &&
  !self.supports_expand_collapse() &&
  self.is_selected() is None
}

///|
pub fn Node::supports_action(
  self : Node,
  action : @common.Action,
  parent_filter : (Node) -> FilterResult,
) -> Bool {
  if self.data().supports_action(action) {
    return true
  }
  match self.filtered_parent(parent_filter) {
    None => false
    Some(parent) => parent.data().child_supports_action(action)
  }
}

///|
pub fn Node::supports_increment(
  self : Node,
  parent_filter : (Node) -> FilterResult,
) -> Bool {
  self.supports_action(@common.Action::Increment, parent_filter)
}

///|
pub fn Node::supports_decrement(
  self : Node,
  parent_filter : (Node) -> FilterResult,
) -> Bool {
  self.supports_action(@common.Action::Decrement, parent_filter)
}

///|
pub fn Node::label_comes_from_value(self : Node) -> Bool {
  self.role() == @common.Role::Label
}

///|
pub fn Node::description(self : Node) -> String? {
  self.data().description()
}

///|
pub fn Node::url(self : Node) -> String? {
  self.data().url()
}

///|
pub fn Node::supports_url(self : Node) -> Bool {
  let role = self.role()
  (
    role == @common.Role::Link ||
    role == @common.Role::DocBackLink ||
    role == @common.Role::DocBiblioRef ||
    role == @common.Role::DocGlossRef ||
    role == @common.Role::DocNoteRef
  ) &&
  self.url() is Some(_)
}

///|
pub fn Node::write_value(self : Node, buf : StringBuilder) -> Bool {
  match self.data().value() {
    Some(value) => {
      buf.write_string(value)
      true
    }
    None =>
      if self.supports_text_ranges() && !self.is_multiline() {
        self.document_range().write_text(buf)
        true
      } else {
        false
      }
  }
}

///|
pub fn Node::value(self : Node) -> String? {
  let buf = StringBuilder::new()
  if self.write_value(buf) {
    Some(buf.to_string())
  } else {
    None
  }
}

///|
pub fn Node::has_value(self : Node) -> Bool {
  self.data().value() is Some(_) ||
  (self.supports_text_ranges() && !self.is_multiline())
}

///|
pub fn Node::is_read_only_supported(self : Node) -> Bool {
  if self.is_text_input() {
    true
  } else {
    match self.role() {
      @common.Role::CheckBox
      | @common.Role::ColorWell
      | @common.Role::ComboBox
      | @common.Role::Grid
      | @common.Role::ListBox
      | @common.Role::MenuItemCheckBox
      | @common.Role::MenuItemRadio
      | @common.Role::MenuListPopup
      | @common.Role::RadioButton
      | @common.Role::RadioGroup
      | @common.Role::Slider
      | @common.Role::Switch
      | @common.Role::TreeGrid => true
      _ => false
    }
  }
}

///|
pub fn Node::should_have_read_only_state_by_default(self : Node) -> Bool {
  match self.role() {
    @common.Role::Article
    | @common.Role::Definition
    | @common.Role::DescriptionList
    | @common.Role::Document
    | @common.Role::GraphicsDocument
    | @common.Role::Image
    | @common.Role::List
    | @common.Role::ListItem
    | @common.Role::PdfRoot
    | @common.Role::ProgressIndicator
    | @common.Role::RootWebArea
    | @common.Role::Term
    | @common.Role::Timer
    | @common.Role::Toolbar
    | @common.Role::Tooltip => true
    _ => false
  }
}

///|
pub fn Node::is_required(self : Node) -> Bool {
  self.data().is_required()
}

///|
pub fn Node::live(self : Node) -> @common.Live {
  match self.data().live() {
    Some(live) => live
    None =>
      match self.parent() {
        None => @common.Live::Off
        Some(parent) => parent.live()
      }
  }
}

///|
pub fn Node::is_selected(self : Node) -> Bool? {
  self.data().is_selected()
}

///|
pub fn Node::is_item_like(self : Node) -> Bool {
  match self.role() {
    @common.Role::Article
    | @common.Role::Comment
    | @common.Role::ListItem
    | @common.Role::MenuItem
    | @common.Role::MenuItemRadio
    | @common.Role::Tab
    | @common.Role::MenuItemCheckBox
    | @common.Role::TreeItem
    | @common.Role::ListBoxOption
    | @common.Role::MenuListOption
    | @common.Role::RadioButton
    | @common.Role::Term => true
    _ => false
  }
}

///|
pub fn Node::is_container_with_selectable_children(self : Node) -> Bool {
  match self.role() {
    @common.Role::ComboBox
    | @common.Role::EditableComboBox
    | @common.Role::Grid
    | @common.Role::ListBox
    | @common.Role::ListGrid
    | @common.Role::Menu
    | @common.Role::MenuBar
    | @common.Role::MenuListPopup
    | @common.Role::RadioGroup
    | @common.Role::TabList
    | @common.Role::Toolbar
    | @common.Role::Tree
    | @common.Role::TreeGrid => true
    _ => false
  }
}

///|
pub fn Node::controls(self : Node) -> Array[Node] {
  let out : Array[Node] = []
  for control_id in self.data().controls() {
    out.push(
      self.tree_state.node_by_id(self.id.with_same_tree(control_id)).unwrap(),
    )
  }
  out
}

///|
pub fn Node::raw_text_selection(self : Node) -> @common.TextSelection? {
  self.data().text_selection()
}

///|
pub fn Node::raw_value(self : Node) -> String? {
  self.data().value()
}

///|
pub fn Node::author_id(self : Node) -> String? {
  self.data().author_id()
}

///|
pub fn Node::class_name(self : Node) -> String? {
  self.data().class_name()
}

///|
pub fn Node::selection_container(
  self : Node,
  filter : (Node) -> FilterResult,
) -> Node? {
  self.filtered_parent(parent => {
    match filter(parent) {
      FilterResult::Include if parent.is_container_with_selectable_children() =>
        FilterResult::Include
      FilterResult::Include => FilterResult::ExcludeNode
      other => other
    }
  })
}

///|
pub fn Node::items(self : Node, filter : (Node) -> FilterResult) -> Array[Node] {
  self.filtered_children(child => {
    match filter(child) {
      FilterResult::Include if child.is_item_like() => FilterResult::Include
      FilterResult::Include => FilterResult::ExcludeNode
      other => other
    }
  })
}
