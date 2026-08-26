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
fn assert_filter_result(
  expected : FilterResult,
  tree : Tree,
  id : @common.NodeId,
) -> Unit raise {
  @test.assert_eq(
    expected,
    common_filter(tree.state().node_by_id(nid(id)).unwrap()),
  )
}

///|
test "filters.normal" {
  let update = @common.TreeUpdate(
    @common.TreeId::root(),
    @common.NodeId::from_u64(0UL),
  )
  let root = @common.Node(@common.Role::Window)
  root.set_children([@common.NodeId::from_u64(1UL)])
  update.push_node(@common.NodeId::from_u64(0UL), root)
  update.push_node(
    @common.NodeId::from_u64(1UL),
    @common.Node(@common.Role::Button),
  )
  update.set_tree(@common.Tree(@common.NodeId::from_u64(0UL)))
  let tree = Tree::Tree(update, false)
  assert_filter_result(
    FilterResult::Include,
    tree,
    @common.NodeId::from_u64(1UL),
  )
}

///|
test "filters.hidden" {
  let update = @common.TreeUpdate(
    @common.TreeId::root(),
    @common.NodeId::from_u64(0UL),
  )
  let root = @common.Node(@common.Role::Window)
  root.set_children([@common.NodeId::from_u64(1UL)])
  update.push_node(@common.NodeId::from_u64(0UL), root)
  let child = @common.Node(@common.Role::Button)
  child.set_hidden()
  update.push_node(@common.NodeId::from_u64(1UL), child)
  update.set_tree(@common.Tree(@common.NodeId::from_u64(0UL)))
  let tree = Tree::Tree(update, false)
  assert_filter_result(
    FilterResult::ExcludeSubtree,
    tree,
    @common.NodeId::from_u64(1UL),
  )
}

///|
test "filters.hidden_but_focused" {
  let update = @common.TreeUpdate(
    @common.TreeId::root(),
    @common.NodeId::from_u64(1UL),
  )
  let root = @common.Node(@common.Role::Window)
  root.set_children([@common.NodeId::from_u64(1UL)])
  update.push_node(@common.NodeId::from_u64(0UL), root)
  let child = @common.Node(@common.Role::Button)
  child.set_hidden()
  update.push_node(@common.NodeId::from_u64(1UL), child)
  update.set_tree(@common.Tree(@common.NodeId::from_u64(0UL)))
  let tree = Tree::Tree(update, true)
  assert_filter_result(
    FilterResult::Include,
    tree,
    @common.NodeId::from_u64(1UL),
  )
}

///|
test "filters.generic_container" {
  let update = @common.TreeUpdate(
    @common.TreeId::root(),
    @common.NodeId::from_u64(0UL),
  )
  let root = @common.Node(@common.Role::GenericContainer)
  root.set_children([@common.NodeId::from_u64(1UL)])
  update.push_node(@common.NodeId::from_u64(0UL), root)
  update.push_node(
    @common.NodeId::from_u64(1UL),
    @common.Node(@common.Role::Button),
  )
  update.set_tree(@common.Tree(@common.NodeId::from_u64(0UL)))
  let tree = Tree::Tree(update, false)
  assert_filter_result(
    FilterResult::ExcludeNode,
    tree,
    @common.NodeId::from_u64(0UL),
  )
  @test.assert_eq(
    FilterResult::Include,
    common_filter_with_root_exception(
      tree.state().node_by_id(nid(@common.NodeId::from_u64(0UL))).unwrap(),
    ),
  )
  assert_filter_result(
    FilterResult::Include,
    tree,
    @common.NodeId::from_u64(1UL),
  )
}

///|
test "filters.hidden_parent" {
  let update = @common.TreeUpdate(
    @common.TreeId::root(),
    @common.NodeId::from_u64(0UL),
  )
  let root = @common.Node(@common.Role::GenericContainer)
  root.set_hidden()
  root.set_children([@common.NodeId::from_u64(1UL)])
  update.push_node(@common.NodeId::from_u64(0UL), root)
  update.push_node(
    @common.NodeId::from_u64(1UL),
    @common.Node(@common.Role::Button),
  )
  update.set_tree(@common.Tree(@common.NodeId::from_u64(0UL)))
  let tree = Tree::Tree(update, false)
  assert_filter_result(
    FilterResult::ExcludeSubtree,
    tree,
    @common.NodeId::from_u64(0UL),
  )
  assert_filter_result(
    FilterResult::ExcludeSubtree,
    tree,
    @common.NodeId::from_u64(1UL),
  )
}

///|
test "filters.hidden_parent_but_focused" {
  let update = @common.TreeUpdate(
    @common.TreeId::root(),
    @common.NodeId::from_u64(1UL),
  )
  let root = @common.Node(@common.Role::GenericContainer)
  root.set_hidden()
  root.set_children([@common.NodeId::from_u64(1UL)])
  update.push_node(@common.NodeId::from_u64(0UL), root)
  update.push_node(
    @common.NodeId::from_u64(1UL),
    @common.Node(@common.Role::Button),
  )
  update.set_tree(@common.Tree(@common.NodeId::from_u64(0UL)))
  let tree = Tree::Tree(update, true)
  assert_filter_result(
    FilterResult::ExcludeSubtree,
    tree,
    @common.NodeId::from_u64(0UL),
  )
  assert_filter_result(
    FilterResult::Include,
    tree,
    @common.NodeId::from_u64(1UL),
  )
}

///|
test "filters.text_run" {
  let update = @common.TreeUpdate(
    @common.TreeId::root(),
    @common.NodeId::from_u64(0UL),
  )
  let root = @common.Node(@common.Role::TextInput)
  root.set_children([@common.NodeId::from_u64(1UL)])
  update.push_node(@common.NodeId::from_u64(0UL), root)
  update.push_node(
    @common.NodeId::from_u64(1UL),
    @common.Node(@common.Role::TextRun),
  )
  update.set_tree(@common.Tree(@common.NodeId::from_u64(0UL)))
  let tree = Tree::Tree(update, false)
  assert_filter_result(
    FilterResult::ExcludeNode,
    tree,
    @common.NodeId::from_u64(1UL),
  )
}

///|
fn clipped_children_test_tree() -> Tree {
  let update = @common.TreeUpdate(
    @common.TreeId::root(),
    @common.NodeId::from_u64(0UL),
  )
  let root = @common.Node(@common.Role::ScrollView)
  root.set_clips_children()
  root.set_bounds(@common.Rect(0.0, 0.0, 30.0, 30.0))
  root.set_children([
    @common.NodeId::from_u64(1UL),
    @common.NodeId::from_u64(2UL),
    @common.NodeId::from_u64(3UL),
    @common.NodeId::from_u64(4UL),
    @common.NodeId::from_u64(5UL),
    @common.NodeId::from_u64(6UL),
    @common.NodeId::from_u64(7UL),
    @common.NodeId::from_u64(8UL),
    @common.NodeId::from_u64(9UL),
    @common.NodeId::from_u64(10UL),
    @common.NodeId::from_u64(11UL),
  ])
  update.push_node(@common.NodeId::from_u64(0UL), root)
  fn push_unknown_with_bounds(
    update : @common.TreeUpdate,
    id : UInt64,
    rect : @common.Rect,
  ) -> Unit {
    let node = @common.Node(@common.Role::Unknown)
    node.set_bounds(rect)
    update.push_node(@common.NodeId::from_u64(id), node)
  }

  push_unknown_with_bounds(update, 1UL, @common.Rect(0.0, -30.0, 30.0, -20.0))
  push_unknown_with_bounds(update, 2UL, @common.Rect(0.0, -20.0, 30.0, -10.0))
  push_unknown_with_bounds(update, 3UL, @common.Rect(0.0, -10.0, 30.0, 0.0))
  let node4 = @common.Node(@common.Role::Unknown)
  node4.set_hidden()
  update.push_node(@common.NodeId::from_u64(4UL), node4)
  push_unknown_with_bounds(update, 5UL, @common.Rect(0.0, 0.0, 30.0, 10.0))
  push_unknown_with_bounds(update, 6UL, @common.Rect(0.0, 10.0, 30.0, 20.0))
  push_unknown_with_bounds(update, 7UL, @common.Rect(0.0, 20.0, 30.0, 30.0))
  let node8 = @common.Node(@common.Role::Unknown)
  node8.set_hidden()
  update.push_node(@common.NodeId::from_u64(8UL), node8)
  push_unknown_with_bounds(update, 9UL, @common.Rect(0.0, 30.0, 30.0, 40.0))
  push_unknown_with_bounds(update, 10UL, @common.Rect(0.0, 40.0, 30.0, 50.0))
  push_unknown_with_bounds(update, 11UL, @common.Rect(0.0, 50.0, 30.0, 60.0))
  update.set_tree(@common.Tree(@common.NodeId::from_u64(0UL)))
  Tree::Tree(update, false)
}

///|
test "filters.clipped_children_excluded_above" {
  let tree = clipped_children_test_tree()
  assert_filter_result(
    FilterResult::ExcludeSubtree,
    tree,
    @common.NodeId::from_u64(1UL),
  )
  assert_filter_result(
    FilterResult::ExcludeSubtree,
    tree,
    @common.NodeId::from_u64(2UL),
  )
}

///|
test "filters.clipped_children_included_above" {
  let tree = clipped_children_test_tree()
  assert_filter_result(
    FilterResult::Include,
    tree,
    @common.NodeId::from_u64(3UL),
  )
}

///|
test "filters.clipped_children_hidden" {
  let tree = clipped_children_test_tree()
  assert_filter_result(
    FilterResult::ExcludeSubtree,
    tree,
    @common.NodeId::from_u64(4UL),
  )
  assert_filter_result(
    FilterResult::ExcludeSubtree,
    tree,
    @common.NodeId::from_u64(8UL),
  )
}

///|
test "filters.clipped_children_visible" {
  let tree = clipped_children_test_tree()
  assert_filter_result(
    FilterResult::Include,
    tree,
    @common.NodeId::from_u64(5UL),
  )
  assert_filter_result(
    FilterResult::Include,
    tree,
    @common.NodeId::from_u64(6UL),
  )
  assert_filter_result(
    FilterResult::Include,
    tree,
    @common.NodeId::from_u64(7UL),
  )
}

///|
test "filters.clipped_children_included_below" {
  let tree = clipped_children_test_tree()
  assert_filter_result(
    FilterResult::Include,
    tree,
    @common.NodeId::from_u64(9UL),
  )
}

///|
test "filters.clipped_children_excluded_below" {
  let tree = clipped_children_test_tree()
  assert_filter_result(
    FilterResult::ExcludeSubtree,
    tree,
    @common.NodeId::from_u64(10UL),
  )
  assert_filter_result(
    FilterResult::ExcludeSubtree,
    tree,
    @common.NodeId::from_u64(11UL),
  )
}

///|
test "filters.graft_node" {
  let subtree_id = @common.TreeId({ high: 0UL, low: 1UL })
  let update = @common.TreeUpdate(
    @common.TreeId::root(),
    @common.NodeId::from_u64(0UL),
  )
  let root = @common.Node(@common.Role::Window)
  root.set_children([@common.NodeId::from_u64(1UL)])
  update.push_node(@common.NodeId::from_u64(0UL), root)
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id)
  update.push_node(@common.NodeId::from_u64(1UL), graft)
  update.set_tree(@common.Tree(@common.NodeId::from_u64(0UL)))
  let tree = Tree::Tree(update, false)
  assert_filter_result(
    FilterResult::ExcludeNode,
    tree,
    @common.NodeId::from_u64(1UL),
  )
}
