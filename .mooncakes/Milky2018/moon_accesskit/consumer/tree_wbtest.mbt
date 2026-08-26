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
fn node_id(n : UInt64) -> NodeId {
  NodeId(TreeIndex(0), lid(n))
}

///|
fn subtree_id() -> @common.TreeId {
  @common.TreeId(@common.Uuid::{ high: 0UL, low: 1UL })
}

///|
fn nested_subtree_id() -> @common.TreeId {
  @common.TreeId(@common.Uuid::{ high: 0UL, low: 2UL })
}

///|
fn subtree_node_id(id : UInt64) -> NodeId {
  NodeId(TreeIndex(1), lid(id))
}

///|
fn nested_subtree_node_id(id : UInt64) -> NodeId {
  NodeId(TreeIndex(2), lid(id))
}

///|
struct NoOpHandler {}

///|
struct TreeTestNodeSnapshot {
  id : NodeId
  parent_id : NodeId?
  child_ids : Array[NodeId]
  data_children : Array[@common.NodeId]
  label : String?
  is_focused : Bool
}

///|
fn TreeTestNodeSnapshot::of(node : Node) -> TreeTestNodeSnapshot {
  {
    id: node.id(),
    parent_id: node.parent_id(),
    child_ids: node.child_ids(),
    data_children: node.data().children(),
    label: node.label(),
    is_focused: node.is_focused(),
  }
}

///|
struct TreeTestNodeUpdate {
  old : TreeTestNodeSnapshot
  new : TreeTestNodeSnapshot
}

///|
struct TreeTestHandler {
  added : Array[TreeTestNodeSnapshot]
  updated : Array[TreeTestNodeUpdate]
  removed : Array[TreeTestNodeSnapshot]
  focus_moves : Array[(NodeId?, NodeId?)]
}

///|
fn TreeTestHandler::TreeTestHandler() -> TreeTestHandler {
  { added: [], updated: [], removed: [], focus_moves: [] }
}

///|
fn TreeTestHandler::added_ids(self : TreeTestHandler) -> Array[NodeId] {
  let ids : Array[NodeId] = []
  for n in self.added {
    ids.push(n.id)
  }
  ids
}

///|
fn TreeTestHandler::updated_ids(self : TreeTestHandler) -> Array[NodeId] {
  let ids : Array[NodeId] = []
  for u in self.updated {
    ids.push(u.new.id)
  }
  ids
}

///|
fn TreeTestHandler::removed_ids(self : TreeTestHandler) -> Array[NodeId] {
  let ids : Array[NodeId] = []
  for n in self.removed {
    ids.push(n.id)
  }
  ids
}

///|
fn find_update(
  updates : Array[TreeTestNodeUpdate],
  id : NodeId,
) -> TreeTestNodeUpdate? {
  for u in updates {
    if u.new.id == id {
      return Some(u)
    }
  }
  None
}

///|
fn expect_id_set_eq(
  actual : Array[NodeId],
  expected : Array[NodeId],
) -> Unit raise {
  let set : Map[NodeId, Unit] = Map([])
  for id in actual {
    set[id] = ()
  }
  @test.assert_eq(actual.length(), expected.length())
  @test.assert_eq(set.length(), expected.length())
  for id in expected {
    expect(set.contains(id))
  }
}

///|
fn expect_id_set_contains(
  actual : Array[NodeId],
  expected : NodeId,
) -> Unit raise {
  let set : Map[NodeId, Unit] = Map([])
  for id in actual {
    set[id] = ()
  }
  expect(set.contains(expected))
}

///|
fn expect_id_set_not_contains(
  actual : Array[NodeId],
  expected : NodeId,
) -> Unit raise {
  let set : Map[NodeId, Unit] = Map([])
  for id in actual {
    set[id] = ()
  }
  expect(!set.contains(expected))
}

///|
impl ChangeHandler for TreeTestHandler with node_added(self, node) {
  self.added.push(TreeTestNodeSnapshot::of(node))
}

///|
impl ChangeHandler for TreeTestHandler with node_updated(
  self,
  old_node,
  new_node,
) {
  self.updated.push({
    old: TreeTestNodeSnapshot::of(old_node),
    new: TreeTestNodeSnapshot::of(new_node),
  })
}

///|
impl ChangeHandler for TreeTestHandler with focus_moved(
  self,
  old_focus,
  new_focus,
) {
  self.focus_moves.push(
    (old_focus.map(n => n.id()), new_focus.map(n => n.id())),
  )
}

///|
impl ChangeHandler for TreeTestHandler with node_removed(self, node) {
  self.removed.push(TreeTestNodeSnapshot::of(node))
}

///|
impl ChangeHandler for NoOpHandler with node_added(_, _) {
  ()
}

///|
impl ChangeHandler for NoOpHandler with node_updated(_, _, _) {
  ()
}

///|
impl ChangeHandler for NoOpHandler with focus_moved(_, _, _) {
  ()
}

///|
impl ChangeHandler for NoOpHandler with node_removed(_, _) {
  ()
}

///|
test "tree.tree_index_map_assigns_sequential_indices" {
  let map = TreeIndexMap::TreeIndexMap()
  let id1 = @common.TreeId::root()
  let id2 = @common.TreeId(@common.Uuid::{ high: 0UL, low: 1UL })
  let id3 = @common.TreeId(@common.Uuid::{ high: 0UL, low: 2UL })
  let index1 = map.get_index(id1)
  let index2 = map.get_index(id2)
  let index3 = map.get_index(id3)
  @test.assert_eq(index1, TreeIndex(0))
  @test.assert_eq(index2, TreeIndex(1))
  @test.assert_eq(index3, TreeIndex(2))
}

///|
test "tree.tree_index_map_returns_same_index_for_same_id" {
  let map = TreeIndexMap::TreeIndexMap()
  let id = @common.TreeId::root()
  let index1 = map.get_index(id)
  let index2 = map.get_index(id)
  @test.assert_eq(index1, index2)
}

///|
test "tree.tree_index_map_get_id_returns_correct_id" {
  let map = TreeIndexMap::TreeIndexMap()
  let id1 = @common.TreeId::root()
  let id2 = @common.TreeId(@common.Uuid::{ high: 0UL, low: 1UL })
  let index1 = map.get_index(id1)
  let index2 = map.get_index(id2)
  @test.assert_eq(map.get_id(index1), Some(id1))
  @test.assert_eq(map.get_id(index2), Some(id2))
}

///|
test "tree.tree_index_map_get_id_returns_none_for_unknown_index" {
  let map = TreeIndexMap::TreeIndexMap()
  @test.assert_eq(map.get_id(TreeIndex(0)), None)
  @test.assert_eq(map.get_id(TreeIndex(999)), None)
}

///|
test "tree.init_tree_with_root_node" {
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), @common.Node(@common.Role::Window))
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  @test.assert_eq(node_id(0UL), tree.state().root().id())
  @test.assert_eq(@common.Role::Window, tree.state().root().role())
  expect(tree.state().root().parent() is None)
}

///|
test "panic tree.init_tree_with_non_root_tree_id_panics" {
  let update = @common.TreeUpdate(
    @common.TreeId(@common.Uuid::{ high: 0UL, low: 1UL }),
    lid(0UL),
  )
  update.push_node(lid(0UL), @common.Node(@common.Role::Window))
  update.set_tree(@common.Tree(lid(0UL)))
  Tree::Tree(update, false) |> ignore
}

///|
test "tree.root_node_has_children" {
  let root_node = @common.Node(@common.Role::Window)
  root_node.set_children([lid(1UL), lid(2UL)])
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root_node)
  update.push_node(lid(1UL), @common.Node(@common.Role::Button))
  update.push_node(lid(2UL), @common.Node(@common.Role::Button))
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let state = tree.state()
  @test.assert_eq(
    node_id(0UL),
    state.node_by_id(node_id(1UL)).unwrap().parent().unwrap().id(),
  )
  @test.assert_eq(
    node_id(0UL),
    state.node_by_id(node_id(2UL)).unwrap().parent().unwrap().id(),
  )
  @test.assert_eq(2, state.root().children().length())
}

///|
test "tree.add_child_to_root_node" {
  let root_node_first = @common.Node(@common.Role::Window)
  let first_update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  first_update.push_node(lid(0UL), root_node_first)
  first_update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(first_update, false)
  @test.assert_eq(0, tree.state().root().children().length())
  let root_node_second = @common.Node(@common.Role::Window)
  root_node_second.set_children([lid(1UL)])
  let second_update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  second_update.push_node(lid(0UL), root_node_second)
  second_update.push_node(lid(1UL), @common.Node(@common.Role::RootWebArea))
  let handler = TreeTestHandler::TreeTestHandler()
  tree.update_and_process_changes(second_update, handler)
  expect_id_set_eq(handler.added_ids(), [node_id(1UL)])
  expect_id_set_eq(handler.updated_ids(), [node_id(0UL)])
  expect_id_set_eq(handler.removed_ids(), [])
  @test.assert_eq(0, handler.focus_moves.length())
  let root_update = find_update(handler.updated, node_id(0UL)).unwrap()
  @test.assert_eq(0, root_update.old.data_children.length())
  @test.assert_eq([lid(1UL)], root_update.new.data_children)
  let state = tree.state()
  @test.assert_eq(1, state.root().children().length())
  @test.assert_eq(node_id(1UL), state.root().children()[0].id())
  @test.assert_eq(
    node_id(0UL),
    state.node_by_id(node_id(1UL)).unwrap().parent().unwrap().id(),
  )
}

///|
test "tree.remove_child_from_root_node" {
  let root_node_first = @common.Node(@common.Role::Window)
  root_node_first.set_children([lid(1UL)])
  let first_update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  first_update.push_node(lid(0UL), root_node_first)
  first_update.push_node(lid(1UL), @common.Node(@common.Role::RootWebArea))
  first_update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(first_update, false)
  @test.assert_eq(1, tree.state().root().children().length())
  let root_node_second = @common.Node(@common.Role::Window)
  let second_update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  second_update.push_node(lid(0UL), root_node_second)
  let handler = TreeTestHandler::TreeTestHandler()
  tree.update_and_process_changes(second_update, handler)
  expect_id_set_eq(handler.added_ids(), [])
  expect_id_set_eq(handler.updated_ids(), [node_id(0UL)])
  expect_id_set_eq(handler.removed_ids(), [node_id(1UL)])
  @test.assert_eq(0, handler.focus_moves.length())
  let root_update = find_update(handler.updated, node_id(0UL)).unwrap()
  @test.assert_eq([lid(1UL)], root_update.old.data_children)
  @test.assert_eq(0, root_update.new.data_children.length())
  @test.assert_eq(0, tree.state().root().children().length())
  expect(tree.state().node_by_id(node_id(1UL)) is None)
}

///|
test "tree.move_focus_between_siblings" {
  let root_node = @common.Node(@common.Role::Window)
  root_node.set_children([lid(1UL), lid(2UL)])
  let first_update = @common.TreeUpdate(@common.TreeId::root(), lid(1UL))
  first_update.push_node(lid(0UL), root_node)
  first_update.push_node(lid(1UL), @common.Node(@common.Role::Button))
  first_update.push_node(lid(2UL), @common.Node(@common.Role::Button))
  first_update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(first_update, true)
  expect(tree.state().node_by_id(node_id(1UL)).unwrap().is_focused())
  let second_update = @common.TreeUpdate(@common.TreeId::root(), lid(2UL))
  let handler = TreeTestHandler::TreeTestHandler()
  tree.update_and_process_changes(second_update, handler)
  expect_id_set_eq(handler.added_ids(), [])
  expect_id_set_eq(handler.updated_ids(), [node_id(1UL), node_id(2UL)])
  expect_id_set_eq(handler.removed_ids(), [])
  @test.assert_eq(1, handler.focus_moves.length())
  @test.assert_eq(
    (Some(node_id(1UL)), Some(node_id(2UL))),
    handler.focus_moves[0],
  )
  let u1 = find_update(handler.updated, node_id(1UL)).unwrap()
  expect(u1.old.is_focused)
  expect(!u1.new.is_focused)
  let u2 = find_update(handler.updated, node_id(2UL)).unwrap()
  expect(!u2.old.is_focused)
  expect(u2.new.is_focused)
}

///|
test "tree.update_node" {
  let root_node = @common.Node(@common.Role::Window)
  root_node.set_children([lid(1UL)])
  let child_node_first = @common.Node(@common.Role::Button)
  child_node_first.set_label("foo")
  let first_update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  first_update.push_node(lid(0UL), root_node)
  first_update.push_node(lid(1UL), child_node_first)
  first_update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(first_update, false)
  @test.assert_eq(
    Some("foo"),
    tree.state().node_by_id(node_id(1UL)).unwrap().label(),
  )
  let child_node_second = @common.Node(@common.Role::Button)
  child_node_second.set_label("bar")
  let second_update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  second_update.push_node(lid(1UL), child_node_second)
  let handler = TreeTestHandler::TreeTestHandler()
  tree.update_and_process_changes(second_update, handler)
  expect_id_set_eq(handler.added_ids(), [])
  expect_id_set_eq(handler.updated_ids(), [node_id(1UL)])
  expect_id_set_eq(handler.removed_ids(), [])
  @test.assert_eq(0, handler.focus_moves.length())
  let u = find_update(handler.updated, node_id(1UL)).unwrap()
  @test.assert_eq(Some("foo"), u.old.label)
  @test.assert_eq(Some("bar"), u.new.label)
  @test.assert_eq(
    Some("bar"),
    tree.state().node_by_id(node_id(1UL)).unwrap().label(),
  )
}

///|
test "tree.no_change_update" {
  let root_node = @common.Node(@common.Role::Window)
  root_node.set_children([lid(1UL)])
  let child_node = @common.Node(@common.Role::Button)
  child_node.set_label("foo")
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root_node)
  update.push_node(lid(1UL), child_node)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let handler = TreeTestHandler::TreeTestHandler()
  // Construct a fresh update that is identical to the original.
  let root_node_2 = @common.Node(@common.Role::Window)
  root_node_2.set_children([lid(1UL)])
  let child_node_2 = @common.Node(@common.Role::Button)
  child_node_2.set_label("foo")
  let update_2 = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update_2.push_node(lid(0UL), root_node_2)
  update_2.push_node(lid(1UL), child_node_2)
  update_2.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(update_2, handler)
  expect_id_set_eq(handler.added_ids(), [])
  expect_id_set_eq(handler.updated_ids(), [])
  expect_id_set_eq(handler.removed_ids(), [])
  @test.assert_eq(0, handler.focus_moves.length())
}

///|
test "tree.move_node" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let container = @common.Node(@common.Role::GenericContainer)
  container.set_children([lid(2UL)])
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), container)
  update.push_node(lid(2UL), @common.Node(@common.Role::Button))
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let root2 = @common.Node(@common.Role::Window)
  root2.set_children([lid(2UL)])
  let update2 = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update2.push_node(lid(0UL), root2)
  let handler = TreeTestHandler::TreeTestHandler()
  tree.update_and_process_changes(update2, handler)
  expect_id_set_eq(handler.added_ids(), [])
  expect_id_set_eq(handler.updated_ids(), [node_id(0UL), node_id(2UL)])
  expect_id_set_eq(handler.removed_ids(), [node_id(1UL)])
  @test.assert_eq(0, handler.focus_moves.length())
  let root_update = find_update(handler.updated, node_id(0UL)).unwrap()
  @test.assert_eq([node_id(1UL)], root_update.old.child_ids)
  @test.assert_eq([node_id(2UL)], root_update.new.child_ids)
  let child_update = find_update(handler.updated, node_id(2UL)).unwrap()
  @test.assert_eq(Some(node_id(1UL)), child_update.old.parent_id)
  @test.assert_eq(Some(node_id(0UL)), child_update.new.parent_id)
  @test.assert_eq(tree.state().node_by_id(node_id(0UL)).unwrap().child_ids(), [
    node_id(2UL),
  ])
  expect(tree.state().node_by_id(node_id(1UL)) is None)
  @test.assert_eq(
    tree.state().node_by_id(node_id(2UL)).unwrap().parent_id(),
    Some(node_id(0UL)),
  )
}

///|
test "tree.graft_node_tracks_subtree" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  @test.assert_eq(tree.state().graft_parent(subtree_id()), Some(node_id(1UL)))
}

///|
test "panic tree.duplicate_graft_parent_panics" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL), lid(2UL)])
  let graft1 = @common.Node(@common.Role::GenericContainer)
  graft1.set_tree_id(subtree_id())
  let graft2 = @common.Node(@common.Role::GenericContainer)
  graft2.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft1)
  update.push_node(lid(2UL), graft2)
  update.set_tree(@common.Tree(lid(0UL)))
  Tree::Tree(update, false) |> ignore
}

///|
test "tree.reparent_subtree_by_removing_old_graft" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL), lid(2UL)])
  let graft1 = @common.Node(@common.Role::GenericContainer)
  graft1.set_tree_id(subtree_id())
  let container2 = @common.Node(@common.Role::GenericContainer)
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft1)
  update.push_node(lid(2UL), container2)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  @test.assert_eq(tree.state().graft_parent(subtree_id()), Some(node_id(1UL)))
  let root2 = @common.Node(@common.Role::Window)
  root2.set_children([lid(2UL)])
  let graft2 = @common.Node(@common.Role::GenericContainer)
  graft2.set_tree_id(subtree_id())
  let update2 = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update2.push_node(lid(0UL), root2)
  update2.push_node(lid(2UL), graft2)
  tree.update_and_process_changes(update2, NoOpHandler::{  })
  @test.assert_eq(tree.state().graft_parent(subtree_id()), Some(node_id(2UL)))
}

///|
test "tree.reparent_subtree_by_clearing_old_graft_tree_id" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL), lid(2UL)])
  let graft1 = @common.Node(@common.Role::GenericContainer)
  graft1.set_tree_id(subtree_id())
  let container2 = @common.Node(@common.Role::GenericContainer)
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft1)
  update.push_node(lid(2UL), container2)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  @test.assert_eq(tree.state().graft_parent(subtree_id()), Some(node_id(1UL)))
  let cleared = @common.Node(@common.Role::GenericContainer)
  let graft2 = @common.Node(@common.Role::GenericContainer)
  graft2.set_tree_id(subtree_id())
  let update2 = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update2.push_node(lid(1UL), cleared)
  update2.push_node(lid(2UL), graft2)
  tree.update_and_process_changes(update2, NoOpHandler::{  })
  @test.assert_eq(tree.state().graft_parent(subtree_id()), Some(node_id(2UL)))
}

///|
test "panic tree.duplicate_graft_parent_on_update_panics" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL), lid(2UL)])
  let graft1 = @common.Node(@common.Role::GenericContainer)
  graft1.set_tree_id(subtree_id())
  let container2 = @common.Node(@common.Role::GenericContainer)
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft1)
  update.push_node(lid(2UL), container2)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let graft2 = @common.Node(@common.Role::GenericContainer)
  graft2.set_tree_id(subtree_id())
  let update2 = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update2.push_node(lid(2UL), graft2)
  tree.update_and_process_changes(update2, NoOpHandler::{  })
}

///|
test "panic tree.graft_root_tree_panics" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(@common.TreeId::root())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  Tree::Tree(update, false) |> ignore
}

///|
test "panic tree.graft_root_tree_on_update_panics" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let graft2 = @common.Node(@common.Role::GenericContainer)
  graft2.set_tree_id(@common.TreeId::root())
  let update2 = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update2.push_node(lid(1UL), graft2)
  tree.update_and_process_changes(update2, NoOpHandler::{  })
}

///|
test "tree.subtree_root_parent_is_graft_when_graft_exists_first" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update.push_node(lid(0UL), @common.Node(@common.Role::Document))
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  let subtree_root = tree.state().node_by_id(subtree_node_id(0UL)).unwrap()
  @test.assert_eq(subtree_root.parent_id(), Some(node_id(1UL)))
  let graft_node = tree.state().node_by_id(node_id(1UL)).unwrap()
  let children = graft_node.child_ids()
  @test.assert_eq(children.length(), 1)
  @test.assert_eq(children[0], subtree_node_id(0UL))
}

///|
test "panic tree.subtree_push_without_graft_panics" {
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), @common.Node(@common.Role::Window))
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update.push_node(lid(0UL), @common.Node(@common.Role::Document))
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
}

///|
test "panic tree.subtree_update_without_tree_data_panics" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update.push_node(lid(0UL), @common.Node(@common.Role::Document))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
}

///|
test "tree.subtree_nodes_removed_when_graft_removed" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let subtree_root = @common.Node(@common.Role::Document)
  subtree_root.set_children([lid(1UL)])
  let nested_graft = @common.Node(@common.Role::GenericContainer)
  nested_graft.set_tree_id(nested_subtree_id())
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update.push_node(lid(0UL), subtree_root)
  subtree_update.push_node(lid(1UL), nested_graft)
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  let nested_root = @common.Node(@common.Role::Document)
  nested_root.set_children([lid(1UL)])
  let nested_child = @common.Node(@common.Role::Paragraph)
  let nested_update = @common.TreeUpdate(nested_subtree_id(), lid(0UL))
  nested_update.push_node(lid(0UL), nested_root)
  nested_update.push_node(lid(1UL), nested_child)
  nested_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(nested_update, NoOpHandler::{  })
  expect(tree.state().node_by_id(subtree_node_id(0UL)) is Some(_))
  expect(tree.state().node_by_id(subtree_node_id(1UL)) is Some(_))
  expect(tree.state().node_by_id(nested_subtree_node_id(0UL)) is Some(_))
  expect(tree.state().node_by_id(nested_subtree_node_id(1UL)) is Some(_))
  let root2 = @common.Node(@common.Role::Window)
  root2.set_children([])
  let update2 = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update2.push_node(lid(0UL), root2)
  tree.update_and_process_changes(update2, NoOpHandler::{  })
  expect(tree.state().node_by_id(subtree_node_id(0UL)) is None)
  expect(tree.state().node_by_id(subtree_node_id(1UL)) is None)
  expect(tree.state().node_by_id(nested_subtree_node_id(0UL)) is None)
  expect(tree.state().node_by_id(nested_subtree_node_id(1UL)) is None)
  expect(tree.state().subtree_state(subtree_id()) is None)
  expect(tree.state().subtree_state(nested_subtree_id()) is None)
}

///|
test "tree.subtree_nodes_removed_when_graft_tree_id_cleared" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let subtree_root = @common.Node(@common.Role::Document)
  subtree_root.set_children([lid(1UL)])
  let subtree_child = @common.Node(@common.Role::Paragraph)
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update.push_node(lid(0UL), subtree_root)
  subtree_update.push_node(lid(1UL), subtree_child)
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  expect(tree.state().node_by_id(subtree_node_id(0UL)) is Some(_))
  expect(tree.state().node_by_id(subtree_node_id(1UL)) is Some(_))
  let cleared_graft = @common.Node(@common.Role::GenericContainer)
  let root_update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  root_update.push_node(lid(1UL), cleared_graft)
  tree.update_and_process_changes(root_update, NoOpHandler::{  })
  expect(tree.state().node_by_id(subtree_node_id(0UL)) is None)
  expect(tree.state().node_by_id(subtree_node_id(1UL)) is None)
  expect(tree.state().subtree_state(subtree_id()) is None)
}

///|
test "tree.graft_node_has_no_children_when_subtree_not_pushed" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let graft_node = tree.state().node_by_id(node_id(1UL)).unwrap()
  @test.assert_eq(graft_node.child_ids().length(), 0)
  @test.assert_eq(graft_node.children().length(), 0)
}

///|
test "panic tree.graft_node_with_children_panics" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  graft.set_children([lid(2UL)])
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.push_node(lid(2UL), @common.Node(@common.Role::Button))
  update.set_tree(@common.Tree(lid(0UL)))
  Tree::Tree(update, false) |> ignore
}

///|
test "tree.node_added_called_when_subtree_pushed" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let handler = TreeTestHandler::TreeTestHandler()
  let subtree_root = @common.Node(@common.Role::Document)
  subtree_root.set_children([lid(1UL), lid(2UL)])
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update.push_node(lid(0UL), subtree_root)
  subtree_update.push_node(lid(1UL), @common.Node(@common.Role::Paragraph))
  subtree_update.push_node(lid(2UL), @common.Node(@common.Role::Button))
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, handler)
  let added_ids = handler.added_ids()
  @test.assert_eq(3, added_ids.length())
  expect_id_set_eq(added_ids, [
    subtree_node_id(0UL),
    subtree_node_id(1UL),
    subtree_node_id(2UL),
  ])
}

///|
test "tree.node_removed_called_when_graft_removed" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let subtree_root = @common.Node(@common.Role::Document)
  subtree_root.set_children([lid(1UL)])
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update.push_node(lid(0UL), subtree_root)
  subtree_update.push_node(lid(1UL), @common.Node(@common.Role::Paragraph))
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  expect(tree.state().node_by_id(subtree_node_id(0UL)) is Some(_))
  expect(tree.state().node_by_id(subtree_node_id(1UL)) is Some(_))
  let handler = TreeTestHandler::TreeTestHandler()
  let root2 = @common.Node(@common.Role::Window)
  root2.set_children([])
  let update2 = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update2.push_node(lid(0UL), root2)
  tree.update_and_process_changes(update2, handler)
  let removed_ids = handler.removed_ids()
  @test.assert_eq(3, removed_ids.length())
  expect_id_set_eq(removed_ids, [
    node_id(1UL),
    subtree_node_id(0UL),
    subtree_node_id(1UL),
  ])
}

///|
test "tree.node_updated_called_when_subtree_reparented" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL), lid(2UL)])
  let graft1 = @common.Node(@common.Role::GenericContainer)
  graft1.set_tree_id(subtree_id())
  let container2 = @common.Node(@common.Role::GenericContainer)
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft1)
  update.push_node(lid(2UL), container2)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update.push_node(lid(0UL), @common.Node(@common.Role::Document))
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  let subtree_root = tree.state().node_by_id(subtree_node_id(0UL)).unwrap()
  @test.assert_eq(subtree_root.parent().unwrap().id(), node_id(1UL))
  let handler = TreeTestHandler::TreeTestHandler()
  let cleared_graft = @common.Node(@common.Role::GenericContainer)
  let graft2 = @common.Node(@common.Role::GenericContainer)
  graft2.set_tree_id(subtree_id())
  let update2 = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update2.push_node(lid(1UL), cleared_graft)
  update2.push_node(lid(2UL), graft2)
  tree.update_and_process_changes(update2, handler)
  expect_id_set_contains(handler.updated_ids(), subtree_node_id(0UL))
  let subtree_root2 = tree.state().node_by_id(subtree_node_id(0UL)).unwrap()
  @test.assert_eq(subtree_root2.parent().unwrap().id(), node_id(2UL))
}

///|
test "tree.focus_moved_called_when_focus_moves_to_subtree" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, true)
  let subtree_root = @common.Node(@common.Role::Document)
  subtree_root.set_children([lid(1UL)])
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update.push_node(lid(0UL), subtree_root)
  subtree_update.push_node(lid(1UL), @common.Node(@common.Role::Button))
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  let handler = TreeTestHandler::TreeTestHandler()
  let root_update = @common.TreeUpdate(@common.TreeId::root(), lid(1UL))
  tree.update_and_process_changes(root_update, handler)
  @test.assert_eq(handler.focus_moves.length(), 1)
  let (old_focus, new_focus) = handler.focus_moves[0]
  @test.assert_eq(old_focus, Some(node_id(0UL)))
  @test.assert_eq(new_focus, Some(subtree_node_id(0UL)))
}

///|
test "tree.focus_moved_called_when_subtree_focus_changes" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, true)
  let subtree_root = @common.Node(@common.Role::Document)
  subtree_root.set_children([lid(1UL)])
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update.push_node(lid(0UL), subtree_root)
  subtree_update.push_node(lid(1UL), @common.Node(@common.Role::Button))
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  let root_update = @common.TreeUpdate(@common.TreeId::root(), lid(1UL))
  tree.update_and_process_changes(root_update, NoOpHandler::{  })
  let handler = TreeTestHandler::TreeTestHandler()
  let subtree_focus_update = @common.TreeUpdate(subtree_id(), lid(1UL))
  tree.update_and_process_changes(subtree_focus_update, handler)
  @test.assert_eq(handler.focus_moves.length(), 1)
  let (old_focus, new_focus) = handler.focus_moves[0]
  @test.assert_eq(old_focus, Some(subtree_node_id(0UL)))
  @test.assert_eq(new_focus, Some(subtree_node_id(1UL)))
}

///|
test "tree.nested_subtree_focus_follows_graft_chain" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, true)
  let subtree_root = @common.Node(@common.Role::Document)
  subtree_root.set_children([lid(1UL)])
  let nested_graft = @common.Node(@common.Role::GenericContainer)
  nested_graft.set_tree_id(nested_subtree_id())
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update.push_node(lid(0UL), subtree_root)
  subtree_update.push_node(lid(1UL), nested_graft)
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  let nested_root = @common.Node(@common.Role::Group)
  nested_root.set_children([lid(1UL)])
  let nested_update = @common.TreeUpdate(nested_subtree_id(), lid(1UL))
  nested_update.push_node(lid(0UL), nested_root)
  nested_update.push_node(lid(1UL), @common.Node(@common.Role::Button))
  nested_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(nested_update, NoOpHandler::{  })
  let root_focus_update = @common.TreeUpdate(@common.TreeId::root(), lid(1UL))
  tree.update_and_process_changes(root_focus_update, NoOpHandler::{  })
  let subtree_focus_update = @common.TreeUpdate(subtree_id(), lid(1UL))
  tree.update_and_process_changes(subtree_focus_update, NoOpHandler::{  })
  @test.assert_eq(tree.state().focus_id(), Some(nested_subtree_node_id(1UL)))
}

///|
test "tree.nested_subtree_focus_update_changes_effective_focus" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, true)
  let subtree_root = @common.Node(@common.Role::Document)
  subtree_root.set_children([lid(1UL)])
  let nested_graft = @common.Node(@common.Role::GenericContainer)
  nested_graft.set_tree_id(nested_subtree_id())
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(1UL))
  subtree_update.push_node(lid(0UL), subtree_root)
  subtree_update.push_node(lid(1UL), nested_graft)
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  let nested_root = @common.Node(@common.Role::Group)
  nested_root.set_children([lid(1UL), lid(2UL)])
  let nested_update = @common.TreeUpdate(nested_subtree_id(), lid(1UL))
  nested_update.push_node(lid(0UL), nested_root)
  nested_update.push_node(lid(1UL), @common.Node(@common.Role::Button))
  nested_update.push_node(lid(2UL), @common.Node(@common.Role::Button))
  nested_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(nested_update, NoOpHandler::{  })
  let root_focus_update = @common.TreeUpdate(@common.TreeId::root(), lid(1UL))
  tree.update_and_process_changes(root_focus_update, NoOpHandler::{  })
  @test.assert_eq(tree.state().focus_id(), Some(nested_subtree_node_id(1UL)))
  let nested_focus_update = @common.TreeUpdate(nested_subtree_id(), lid(2UL))
  tree.update_and_process_changes(nested_focus_update, NoOpHandler::{  })
  @test.assert_eq(tree.state().focus_id(), Some(nested_subtree_node_id(2UL)))
}

///|
test "panic tree.removing_nested_subtree_while_intermediate_focus_on_graft_panics" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(1UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, true)
  let subtree_root = @common.Node(@common.Role::Document)
  subtree_root.set_children([lid(1UL)])
  let nested_graft = @common.Node(@common.Role::GenericContainer)
  nested_graft.set_tree_id(nested_subtree_id())
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(1UL))
  subtree_update.push_node(lid(0UL), subtree_root)
  subtree_update.push_node(lid(1UL), nested_graft)
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  let nested_update = @common.TreeUpdate(nested_subtree_id(), lid(0UL))
  nested_update.push_node(lid(0UL), @common.Node(@common.Role::Button))
  nested_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(nested_update, NoOpHandler::{  })
  let clear_nested_graft = @common.Node(@common.Role::GenericContainer)
  let update2 = @common.TreeUpdate(subtree_id(), lid(1UL))
  update2.push_node(lid(1UL), clear_nested_graft)
  tree.update_and_process_changes(update2, NoOpHandler::{  })
}

///|
test "tree.nested_subtree_root_lookup_for_focus_only_update" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, true)
  let subtree_root = @common.Node(@common.Role::Document)
  subtree_root.set_children([lid(1UL), lid(2UL)])
  let nested_graft = @common.Node(@common.Role::GenericContainer)
  nested_graft.set_tree_id(nested_subtree_id())
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update.push_node(lid(0UL), subtree_root)
  subtree_update.push_node(lid(1UL), nested_graft)
  subtree_update.push_node(lid(2UL), @common.Node(@common.Role::Button))
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  let nested_root = @common.Node(@common.Role::Group)
  nested_root.set_children([lid(1UL)])
  let nested_update = @common.TreeUpdate(nested_subtree_id(), lid(0UL))
  nested_update.push_node(lid(0UL), nested_root)
  nested_update.push_node(lid(1UL), @common.Node(@common.Role::Button))
  nested_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(nested_update, NoOpHandler::{  })
  let subtree_focus_update = @common.TreeUpdate(subtree_id(), lid(2UL))
  tree.update_and_process_changes(subtree_focus_update, NoOpHandler::{  })
  @test.assert_eq(
    tree.state().subtree_state(subtree_id()).unwrap().focus,
    subtree_node_id(2UL),
  )
}

///|
test "tree.subtree_root_change_updates_graft_and_parent" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let subtree_root = @common.Node(@common.Role::Document)
  subtree_root.set_children([lid(1UL)])
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update.push_node(lid(0UL), subtree_root)
  subtree_update.push_node(lid(1UL), @common.Node(@common.Role::Paragraph))
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  let handler = TreeTestHandler::TreeTestHandler()
  let new_root = @common.Node(@common.Role::Article)
  new_root.set_children([lid(3UL)])
  let subtree_update2 = @common.TreeUpdate(subtree_id(), lid(2UL))
  subtree_update2.push_node(lid(2UL), new_root)
  subtree_update2.push_node(lid(3UL), @common.Node(@common.Role::Button))
  subtree_update2.set_tree(@common.Tree(lid(2UL)))
  tree.update_and_process_changes(subtree_update2, handler)
  let graft_node = tree.state().node_by_id(node_id(1UL)).unwrap()
  let children = graft_node.child_ids()
  @test.assert_eq(children.length(), 1)
  @test.assert_eq(children[0], subtree_node_id(2UL))
  let new_subtree_root = tree.state().node_by_id(subtree_node_id(2UL)).unwrap()
  @test.assert_eq(new_subtree_root.parent_id(), Some(node_id(1UL)))
  @test.assert_eq(new_subtree_root.role(), @common.Role::Article)
  expect(tree.state().node_by_id(subtree_node_id(0UL)) is None)
  expect(tree.state().node_by_id(subtree_node_id(1UL)) is None)
  expect(tree.state().node_by_id(subtree_node_id(2UL)) is Some(_))
  expect(tree.state().node_by_id(subtree_node_id(3UL)) is Some(_))
  let removed_ids = handler.removed_ids()
  let added_ids = handler.added_ids()
  expect_id_set_contains(removed_ids, subtree_node_id(0UL))
  expect_id_set_contains(removed_ids, subtree_node_id(1UL))
  expect_id_set_contains(added_ids, subtree_node_id(2UL))
  expect_id_set_contains(added_ids, subtree_node_id(3UL))
}

///|
test "tree.subtree_root_change_to_existing_child" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let subtree_root = @common.Node(@common.Role::Document)
  subtree_root.set_children([lid(1UL)])
  let child = @common.Node(@common.Role::Article)
  child.set_children([lid(2UL)])
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update.push_node(lid(0UL), subtree_root)
  subtree_update.push_node(lid(1UL), child)
  subtree_update.push_node(lid(2UL), @common.Node(@common.Role::Paragraph))
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  let graft_node = tree.state().node_by_id(node_id(1UL)).unwrap()
  @test.assert_eq(graft_node.child_ids()[0], subtree_node_id(0UL))
  let old_root = tree.state().node_by_id(subtree_node_id(0UL)).unwrap()
  @test.assert_eq(old_root.role(), @common.Role::Document)
  @test.assert_eq(old_root.parent_id(), Some(node_id(1UL)))
  let child_node = tree.state().node_by_id(subtree_node_id(1UL)).unwrap()
  @test.assert_eq(child_node.role(), @common.Role::Article)
  @test.assert_eq(child_node.parent_id(), Some(subtree_node_id(0UL)))
  let grandchild = tree.state().node_by_id(subtree_node_id(2UL)).unwrap()
  @test.assert_eq(grandchild.parent_id(), Some(subtree_node_id(1UL)))
  let handler = TreeTestHandler::TreeTestHandler()
  let new_root = @common.Node(@common.Role::Article)
  new_root.set_children([lid(2UL)])
  let subtree_update2 = @common.TreeUpdate(subtree_id(), lid(1UL))
  subtree_update2.push_node(lid(1UL), new_root)
  subtree_update2.push_node(lid(2UL), @common.Node(@common.Role::Paragraph))
  subtree_update2.set_tree(@common.Tree(lid(1UL)))
  tree.update_and_process_changes(subtree_update2, handler)
  let graft_node2 = tree.state().node_by_id(node_id(1UL)).unwrap()
  let children2 = graft_node2.child_ids()
  @test.assert_eq(children2.length(), 1)
  @test.assert_eq(children2[0], subtree_node_id(1UL))
  let new_root_node = tree.state().node_by_id(subtree_node_id(1UL)).unwrap()
  @test.assert_eq(new_root_node.parent_id(), Some(node_id(1UL)))
  @test.assert_eq(new_root_node.role(), @common.Role::Article)
  expect(tree.state().node_by_id(subtree_node_id(0UL)) is None)
  let grandchild2 = tree.state().node_by_id(subtree_node_id(2UL)).unwrap()
  @test.assert_eq(grandchild2.parent_id(), Some(subtree_node_id(1UL)))
  let removed_ids = handler.removed_ids()
  let updated_ids = handler.updated_ids()
  let added_ids = handler.added_ids()
  expect_id_set_contains(removed_ids, subtree_node_id(0UL))
  expect_id_set_contains(updated_ids, subtree_node_id(1UL))
  expect_id_set_not_contains(added_ids, subtree_node_id(1UL))
  expect_id_set_not_contains(added_ids, subtree_node_id(2UL))
}

///|
test "tree.subtree_root_change_to_new_parent_of_old_root" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let subtree_root = @common.Node(@common.Role::Document)
  subtree_root.set_children([lid(1UL)])
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update.push_node(lid(0UL), subtree_root)
  subtree_update.push_node(lid(1UL), @common.Node(@common.Role::Paragraph))
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  let handler = TreeTestHandler::TreeTestHandler()
  let new_root = @common.Node(@common.Role::Article)
  new_root.set_children([lid(0UL)])
  let old_root2 = @common.Node(@common.Role::Document)
  old_root2.set_children([lid(1UL)])
  let subtree_update2 = @common.TreeUpdate(subtree_id(), lid(2UL))
  subtree_update2.push_node(lid(2UL), new_root)
  subtree_update2.push_node(lid(0UL), old_root2)
  subtree_update2.push_node(lid(1UL), @common.Node(@common.Role::Paragraph))
  subtree_update2.set_tree(@common.Tree(lid(2UL)))
  tree.update_and_process_changes(subtree_update2, handler)
  let graft_node = tree.state().node_by_id(node_id(1UL)).unwrap()
  let children = graft_node.child_ids()
  @test.assert_eq(children.length(), 1)
  @test.assert_eq(children[0], subtree_node_id(2UL))
  let new_root_node = tree.state().node_by_id(subtree_node_id(2UL)).unwrap()
  @test.assert_eq(new_root_node.parent_id(), Some(node_id(1UL)))
  @test.assert_eq(new_root_node.role(), @common.Role::Article)
  let old_root_node = tree.state().node_by_id(subtree_node_id(0UL)).unwrap()
  @test.assert_eq(old_root_node.parent_id(), Some(subtree_node_id(2UL)))
  @test.assert_eq(old_root_node.role(), @common.Role::Document)
  let grandchild = tree.state().node_by_id(subtree_node_id(1UL)).unwrap()
  @test.assert_eq(grandchild.parent_id(), Some(subtree_node_id(0UL)))
  let added_ids = handler.added_ids()
  let updated_ids = handler.updated_ids()
  let removed_ids = handler.removed_ids()
  expect_id_set_contains(added_ids, subtree_node_id(2UL))
  expect_id_set_contains(updated_ids, subtree_node_id(0UL))
  expect_id_set_not_contains(removed_ids, subtree_node_id(0UL))
  expect_id_set_not_contains(removed_ids, subtree_node_id(1UL))
}

///|
test "tree.subtree_update_without_tree_preserves_root" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id())
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(0UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), graft)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  let subtree_root = @common.Node(@common.Role::Document)
  subtree_root.set_children([lid(1UL)])
  let child = @common.Node(@common.Role::Paragraph)
  child.set_label("original")
  let subtree_update = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update.push_node(lid(0UL), subtree_root)
  subtree_update.push_node(lid(1UL), child)
  subtree_update.set_tree(@common.Tree(lid(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  let handler = TreeTestHandler::TreeTestHandler()
  let modified = @common.Node(@common.Role::Paragraph)
  modified.set_label("modified")
  let subtree_update2 = @common.TreeUpdate(subtree_id(), lid(0UL))
  subtree_update2.push_node(lid(1UL), modified)
  tree.update_and_process_changes(subtree_update2, handler)
  let subtree_root_node = tree.state().node_by_id(subtree_node_id(0UL)).unwrap()
  @test.assert_eq(subtree_root_node.role(), @common.Role::Document)
  @test.assert_eq(subtree_root_node.parent_id(), Some(node_id(1UL)))
  let graft_node = tree.state().node_by_id(node_id(1UL)).unwrap()
  @test.assert_eq(graft_node.child_ids()[0], subtree_node_id(0UL))
  let child2 = tree.state().node_by_id(subtree_node_id(1UL)).unwrap()
  @test.assert_eq(child2.label(), Some("modified"))
  expect(handler.removed.length() == 0)
  expect(handler.added.length() == 0)
  expect_id_set_contains(handler.updated_ids(), subtree_node_id(1UL))
  expect_id_set_not_contains(handler.updated_ids(), subtree_node_id(0UL))
}

///|
test "tree.focus_returns_focused_node" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(1UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), @common.Node(@common.Role::Button))
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, true)
  @test.assert_eq(tree.state().focus().unwrap().id(), node_id(1UL))
}

///|
test "tree.focus_returns_active_descendant" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let listbox = @common.Node(@common.Role::ListBox)
  listbox.set_children([lid(2UL)])
  listbox.set_active_descendant(lid(2UL))
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(1UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), listbox)
  update.push_node(lid(2UL), @common.Node(@common.Role::ListBoxOption))
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, true)
  @test.assert_eq(tree.state().focus().unwrap().id(), node_id(2UL))
}

///|
test "tree.focus_moved_when_active_descendant_changes" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let listbox = @common.Node(@common.Role::ListBox)
  listbox.set_children([lid(2UL), lid(3UL)])
  listbox.set_active_descendant(lid(2UL))
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(1UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), listbox)
  update.push_node(lid(2UL), @common.Node(@common.Role::ListBoxOption))
  update.push_node(lid(3UL), @common.Node(@common.Role::ListBoxOption))
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, true)
  let listbox2 = @common.Node(@common.Role::ListBox)
  listbox2.set_children([lid(2UL), lid(3UL)])
  listbox2.set_active_descendant(lid(3UL))
  let update2 = @common.TreeUpdate(@common.TreeId::root(), lid(1UL))
  update2.push_node(lid(1UL), listbox2)
  let handler = TreeTestHandler::TreeTestHandler()
  tree.update_and_process_changes(update2, handler)
  @test.assert_eq(handler.focus_moves.length(), 1)
  let (old_focus, new_focus) = handler.focus_moves[0]
  @test.assert_eq(old_focus, Some(node_id(2UL)))
  @test.assert_eq(new_focus, Some(node_id(3UL)))
}

///|
test "tree.active_dialog_returns_dialog_ancestor" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let dialog = @common.Node(@common.Role::Dialog)
  dialog.set_children([lid(2UL)])
  let button = @common.Node(@common.Role::Button)
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(2UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), dialog)
  update.push_node(lid(2UL), button)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, true)
  @test.assert_eq(
    Some(node_id(1UL)),
    tree.state().active_dialog().map(n => n.id()),
  )
}

///|
test "tree.active_dialog_returns_none_without_dialog" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let button = @common.Node(@common.Role::Button)
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(1UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), button)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, true)
  expect(tree.state().active_dialog() is None)
}

///|
test "tree.active_dialog_returns_none_when_host_not_focused" {
  let root = @common.Node(@common.Role::Window)
  root.set_children([lid(1UL)])
  let dialog = @common.Node(@common.Role::Dialog)
  dialog.set_children([lid(2UL)])
  let button = @common.Node(@common.Role::Button)
  let update = @common.TreeUpdate(@common.TreeId::root(), lid(2UL))
  update.push_node(lid(0UL), root)
  update.push_node(lid(1UL), dialog)
  update.push_node(lid(2UL), button)
  update.set_tree(@common.Tree(lid(0UL)))
  let tree = Tree::Tree(update, false)
  expect(tree.state().active_dialog() is None)
}
