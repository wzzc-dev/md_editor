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
fn nid(id : @common.NodeId) -> NodeId {
  NodeId(TreeIndex(0), id)
}

///|
fn lid(value : UInt64) -> @common.NodeId {
  @common.NodeId::from_u64(value)
}

///|
const ROOT_ID : UInt64 = 0UL

///|
const PARAGRAPH_0_ID : UInt64 = 1UL

///|
const LABEL_0_0_IGNORED_ID : UInt64 = 2UL

///|
const PARAGRAPH_1_IGNORED_ID : UInt64 = 3UL

///|
const BUTTON_1_0_HIDDEN_ID : UInt64 = 4UL

///|
const CONTAINER_1_0_0_HIDDEN_ID : UInt64 = 5UL

///|
const LABEL_1_1_ID : UInt64 = 6UL

///|
const BUTTON_1_2_HIDDEN_ID : UInt64 = 7UL

///|
const CONTAINER_1_2_0_HIDDEN_ID : UInt64 = 8UL

///|
const PARAGRAPH_2_ID : UInt64 = 9UL

///|
const LABEL_2_0_ID : UInt64 = 10UL

///|
const PARAGRAPH_3_IGNORED_ID : UInt64 = 11UL

///|
const EMPTY_CONTAINER_3_0_IGNORED_ID : UInt64 = 12UL

///|
const LINK_3_1_IGNORED_ID : UInt64 = 13UL

///|
const LABEL_3_1_0_ID : UInt64 = 14UL

///|
const BUTTON_3_2_ID : UInt64 = 15UL

///|
const EMPTY_CONTAINER_3_3_IGNORED_ID : UInt64 = 16UL

///|
fn test_tree() -> Tree {
  let root = @common.Node(@common.Role::RootWebArea)
  root.set_children([
    lid(PARAGRAPH_0_ID),
    lid(PARAGRAPH_1_IGNORED_ID),
    lid(PARAGRAPH_2_ID),
    lid(PARAGRAPH_3_IGNORED_ID),
  ])
  let paragraph_0 = @common.Node(@common.Role::Paragraph)
  paragraph_0.set_children([lid(LABEL_0_0_IGNORED_ID)])
  let label_0_0_ignored = @common.Node(@common.Role::Label)
  label_0_0_ignored.set_value("label_0_0_ignored")
  let paragraph_1_ignored = @common.Node(@common.Role::Paragraph)
  paragraph_1_ignored.set_transform(
    @common.Affine::translate(@common.Vec2(10.0, 40.0)),
  )
  paragraph_1_ignored.set_bounds(@common.Rect(0.0, 0.0, 800.0, 40.0))
  paragraph_1_ignored.set_children([
    lid(BUTTON_1_0_HIDDEN_ID),
    lid(LABEL_1_1_ID),
    lid(BUTTON_1_2_HIDDEN_ID),
  ])
  let button_1_0_hidden = @common.Node(@common.Role::Button)
  button_1_0_hidden.set_label("button_1_0_hidden")
  button_1_0_hidden.set_hidden()
  button_1_0_hidden.set_children([lid(CONTAINER_1_0_0_HIDDEN_ID)])
  let container_1_0_0_hidden = @common.Node(@common.Role::GenericContainer)
  container_1_0_0_hidden.set_hidden()
  let label_1_1 = @common.Node(@common.Role::Label)
  label_1_1.set_bounds(@common.Rect(10.0, 10.0, 90.0, 30.0))
  label_1_1.set_value("label_1_1")
  let button_1_2_hidden = @common.Node(@common.Role::Button)
  button_1_2_hidden.set_label("button_1_2_hidden")
  button_1_2_hidden.set_hidden()
  button_1_2_hidden.set_children([lid(CONTAINER_1_2_0_HIDDEN_ID)])
  let container_1_2_0_hidden = @common.Node(@common.Role::GenericContainer)
  container_1_2_0_hidden.set_hidden()
  let paragraph_2 = @common.Node(@common.Role::Paragraph)
  paragraph_2.set_children([lid(LABEL_2_0_ID)])
  let label_2_0 = @common.Node(@common.Role::Label)
  label_2_0.set_label("label_2_0")
  let paragraph_3_ignored = @common.Node(@common.Role::Paragraph)
  paragraph_3_ignored.set_children([
    lid(EMPTY_CONTAINER_3_0_IGNORED_ID),
    lid(LINK_3_1_IGNORED_ID),
    lid(BUTTON_3_2_ID),
    lid(EMPTY_CONTAINER_3_3_IGNORED_ID),
  ])
  let empty_container_3_0_ignored = @common.Node(@common.Role::GenericContainer)
  let link_3_1_ignored = @common.Node(@common.Role::Link)
  link_3_1_ignored.set_children([lid(LABEL_3_1_0_ID)])
  let label_3_1_0 = @common.Node(@common.Role::Label)
  label_3_1_0.set_value("label_3_1_0")
  let button_3_2 = @common.Node(@common.Role::Button)
  button_3_2.set_label("button_3_2")
  let empty_container_3_3_ignored = @common.Node(@common.Role::GenericContainer)
  let initial_update = @common.TreeUpdate(@common.TreeId::root(), lid(ROOT_ID))
  initial_update.push_node(lid(ROOT_ID), root)
  initial_update.push_node(lid(PARAGRAPH_0_ID), paragraph_0)
  initial_update.push_node(lid(LABEL_0_0_IGNORED_ID), label_0_0_ignored)
  initial_update.push_node(lid(PARAGRAPH_1_IGNORED_ID), paragraph_1_ignored)
  initial_update.push_node(lid(BUTTON_1_0_HIDDEN_ID), button_1_0_hidden)
  initial_update.push_node(
    lid(CONTAINER_1_0_0_HIDDEN_ID),
    container_1_0_0_hidden,
  )
  initial_update.push_node(lid(LABEL_1_1_ID), label_1_1)
  initial_update.push_node(lid(BUTTON_1_2_HIDDEN_ID), button_1_2_hidden)
  initial_update.push_node(
    lid(CONTAINER_1_2_0_HIDDEN_ID),
    container_1_2_0_hidden,
  )
  initial_update.push_node(lid(PARAGRAPH_2_ID), paragraph_2)
  initial_update.push_node(lid(LABEL_2_0_ID), label_2_0)
  initial_update.push_node(lid(PARAGRAPH_3_IGNORED_ID), paragraph_3_ignored)
  initial_update.push_node(
    lid(EMPTY_CONTAINER_3_0_IGNORED_ID),
    empty_container_3_0_ignored,
  )
  initial_update.push_node(lid(LINK_3_1_IGNORED_ID), link_3_1_ignored)
  initial_update.push_node(lid(LABEL_3_1_0_ID), label_3_1_0)
  initial_update.push_node(lid(BUTTON_3_2_ID), button_3_2)
  initial_update.push_node(
    lid(EMPTY_CONTAINER_3_3_IGNORED_ID),
    empty_container_3_3_ignored,
  )
  initial_update.set_tree(@common.Tree(lid(ROOT_ID)))
  Tree::Tree(initial_update, false)
}

///|
fn test_tree_filter(node : Node) -> FilterResult {
  let id = node.id()
  let ignored = id == nid(lid(LABEL_0_0_IGNORED_ID)) ||
    id == nid(lid(PARAGRAPH_1_IGNORED_ID)) ||
    id == nid(lid(PARAGRAPH_3_IGNORED_ID)) ||
    id == nid(lid(EMPTY_CONTAINER_3_0_IGNORED_ID)) ||
    id == nid(lid(LINK_3_1_IGNORED_ID)) ||
    id == nid(lid(EMPTY_CONTAINER_3_3_IGNORED_ID))
  if node.is_hidden() {
    FilterResult::ExcludeSubtree
  } else if ignored {
    FilterResult::ExcludeNode
  } else {
    FilterResult::Include
  }
}
