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
fn[T] reverse_array(arr : Array[T]) -> Array[T] {
  let out : Array[T] = []
  let len = arr.length()
  for i in 0..<len {
    out.push(arr[len - 1 - i])
  }
  out
}

///|
fn local_ids_from_node_ids(ids : Array[NodeId]) -> Array[UInt64] {
  let out : Array[UInt64] = []
  for id in ids {
    out.push(id.to_components().0.to_u64())
  }
  out
}

///|
fn local_ids_from_nodes(nodes : Array[Node]) -> Array[UInt64] {
  let out : Array[UInt64] = []
  for node in nodes {
    out.push(node.id().to_components().0.to_u64())
  }
  out
}

///|
test "iterators.following_siblings" {
  let tree = test_tree()
  @test.assert_eq(0, tree.state().root().following_siblings().length())
  @test.assert_eq(
    [PARAGRAPH_1_IGNORED_ID, PARAGRAPH_2_ID, PARAGRAPH_3_IGNORED_ID],
    local_ids_from_node_ids(
      tree
      .state()
      .node_by_id(nid(lid(PARAGRAPH_0_ID)))
      .unwrap()
      .following_sibling_ids(),
    ),
  )
  @test.assert_eq(
    3,
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_0_ID)))
    .unwrap()
    .following_siblings()
    .length(),
  )
  @test.assert_eq(
    0,
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_3_IGNORED_ID)))
    .unwrap()
    .following_siblings()
    .length(),
  )
}

///|
test "iterators.following_siblings_reversed" {
  let tree = test_tree()
  @test.assert_eq(
    [PARAGRAPH_3_IGNORED_ID, PARAGRAPH_2_ID, PARAGRAPH_1_IGNORED_ID],
    reverse_array(
      local_ids_from_node_ids(
        tree
        .state()
        .node_by_id(nid(lid(PARAGRAPH_0_ID)))
        .unwrap()
        .following_sibling_ids(),
      ),
    ),
  )
  @test.assert_eq(
    0,
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_3_IGNORED_ID)))
    .unwrap()
    .following_siblings()
    .length(),
  )
}

///|
test "iterators.preceding_siblings" {
  let tree = test_tree()
  @test.assert_eq(0, tree.state().root().preceding_siblings().length())
  @test.assert_eq(
    [PARAGRAPH_2_ID, PARAGRAPH_1_IGNORED_ID, PARAGRAPH_0_ID],
    local_ids_from_node_ids(
      tree
      .state()
      .node_by_id(nid(lid(PARAGRAPH_3_IGNORED_ID)))
      .unwrap()
      .preceding_sibling_ids(),
    ),
  )
  @test.assert_eq(
    3,
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_3_IGNORED_ID)))
    .unwrap()
    .preceding_siblings()
    .length(),
  )
  @test.assert_eq(
    0,
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_0_ID)))
    .unwrap()
    .preceding_siblings()
    .length(),
  )
}

///|
test "iterators.preceding_siblings_reversed" {
  let tree = test_tree()
  @test.assert_eq(
    [PARAGRAPH_0_ID, PARAGRAPH_1_IGNORED_ID, PARAGRAPH_2_ID],
    reverse_array(
      local_ids_from_node_ids(
        tree
        .state()
        .node_by_id(nid(lid(PARAGRAPH_3_IGNORED_ID)))
        .unwrap()
        .preceding_sibling_ids(),
      ),
    ),
  )
  @test.assert_eq(
    0,
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_0_ID)))
    .unwrap()
    .preceding_siblings()
    .length(),
  )
}

///|
test "iterators.following_filtered_siblings" {
  let tree = test_tree()
  @test.assert_eq(
    0,
    tree.state().root().following_filtered_siblings(test_tree_filter).length(),
  )
  @test.assert_eq(
    [LABEL_1_1_ID, PARAGRAPH_2_ID, LABEL_3_1_0_ID, BUTTON_3_2_ID],
    local_ids_from_nodes(
      tree
      .state()
      .node_by_id(nid(lid(PARAGRAPH_0_ID)))
      .unwrap()
      .following_filtered_siblings(test_tree_filter),
    ),
  )
  @test.assert_eq(
    [BUTTON_3_2_ID],
    local_ids_from_nodes(
      tree
      .state()
      .node_by_id(nid(lid(LABEL_3_1_0_ID)))
      .unwrap()
      .following_filtered_siblings(test_tree_filter),
    ),
  )
  @test.assert_eq(
    0,
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_3_IGNORED_ID)))
    .unwrap()
    .following_filtered_siblings(test_tree_filter)
    .length(),
  )
}

///|
test "iterators.following_filtered_siblings_reversed" {
  let tree = test_tree()
  @test.assert_eq(
    [BUTTON_3_2_ID, LABEL_3_1_0_ID, PARAGRAPH_2_ID, LABEL_1_1_ID],
    reverse_array(
      local_ids_from_nodes(
        tree
        .state()
        .node_by_id(nid(lid(PARAGRAPH_0_ID)))
        .unwrap()
        .following_filtered_siblings(test_tree_filter),
      ),
    ),
  )
  @test.assert_eq(
    [BUTTON_3_2_ID],
    reverse_array(
      local_ids_from_nodes(
        tree
        .state()
        .node_by_id(nid(lid(LABEL_3_1_0_ID)))
        .unwrap()
        .following_filtered_siblings(test_tree_filter),
      ),
    ),
  )
  @test.assert_eq(
    0,
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_3_IGNORED_ID)))
    .unwrap()
    .following_filtered_siblings(test_tree_filter)
    .length(),
  )
}

///|
test "iterators.preceding_filtered_siblings" {
  let tree = test_tree()
  @test.assert_eq(
    0,
    tree.state().root().preceding_filtered_siblings(test_tree_filter).length(),
  )
  @test.assert_eq(
    [PARAGRAPH_2_ID, LABEL_1_1_ID, PARAGRAPH_0_ID],
    local_ids_from_nodes(
      tree
      .state()
      .node_by_id(nid(lid(PARAGRAPH_3_IGNORED_ID)))
      .unwrap()
      .preceding_filtered_siblings(test_tree_filter),
    ),
  )
  @test.assert_eq(
    [PARAGRAPH_2_ID, LABEL_1_1_ID, PARAGRAPH_0_ID],
    local_ids_from_nodes(
      tree
      .state()
      .node_by_id(nid(lid(LABEL_3_1_0_ID)))
      .unwrap()
      .preceding_filtered_siblings(test_tree_filter),
    ),
  )
  @test.assert_eq(
    0,
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_0_ID)))
    .unwrap()
    .preceding_filtered_siblings(test_tree_filter)
    .length(),
  )
}

///|
test "iterators.preceding_filtered_siblings_reversed" {
  let tree = test_tree()
  @test.assert_eq(
    [PARAGRAPH_0_ID, LABEL_1_1_ID, PARAGRAPH_2_ID],
    reverse_array(
      local_ids_from_nodes(
        tree
        .state()
        .node_by_id(nid(lid(PARAGRAPH_3_IGNORED_ID)))
        .unwrap()
        .preceding_filtered_siblings(test_tree_filter),
      ),
    ),
  )
  @test.assert_eq(
    [PARAGRAPH_0_ID, LABEL_1_1_ID, PARAGRAPH_2_ID],
    reverse_array(
      local_ids_from_nodes(
        tree
        .state()
        .node_by_id(nid(lid(LABEL_3_1_0_ID)))
        .unwrap()
        .preceding_filtered_siblings(test_tree_filter),
      ),
    ),
  )
  @test.assert_eq(
    0,
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_0_ID)))
    .unwrap()
    .preceding_filtered_siblings(test_tree_filter)
    .length(),
  )
}

///|
test "iterators.filtered_children" {
  let tree = test_tree()
  @test.assert_eq(
    [
      PARAGRAPH_0_ID,
      LABEL_1_1_ID,
      PARAGRAPH_2_ID,
      LABEL_3_1_0_ID,
      BUTTON_3_2_ID,
    ],
    local_ids_from_nodes(
      tree.state().root().filtered_children(test_tree_filter),
    ),
  )
  @test.assert_eq(
    0,
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_0_ID)))
    .unwrap()
    .filtered_children(test_tree_filter)
    .length(),
  )
  @test.assert_eq(
    0,
    tree
    .state()
    .node_by_id(nid(lid(LABEL_0_0_IGNORED_ID)))
    .unwrap()
    .filtered_children(test_tree_filter)
    .length(),
  )
}

///|
test "iterators.filtered_children_reversed" {
  let tree = test_tree()
  @test.assert_eq(
    [
      BUTTON_3_2_ID,
      LABEL_3_1_0_ID,
      PARAGRAPH_2_ID,
      LABEL_1_1_ID,
      PARAGRAPH_0_ID,
    ],
    reverse_array(
      local_ids_from_nodes(
        tree.state().root().filtered_children(test_tree_filter),
      ),
    ),
  )
  @test.assert_eq(
    0,
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_0_ID)))
    .unwrap()
    .filtered_children(test_tree_filter)
    .length(),
  )
  @test.assert_eq(
    0,
    tree
    .state()
    .node_by_id(nid(lid(LABEL_0_0_IGNORED_ID)))
    .unwrap()
    .filtered_children(test_tree_filter)
    .length(),
  )
}

///|
test "iterators.graft_node_without_subtree_has_no_filtered_children" {
  let subtree_id = @common.TreeId({ high: 0UL, low: 1UL })
  let update = @common.TreeUpdate(@common.TreeId::root(), @common.NodeId(0UL))
  let root = @common.Node(@common.Role::Window)
  root.set_children([@common.NodeId(1UL)])
  update.push_node(@common.NodeId(0UL), root)
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id)
  update.push_node(@common.NodeId(1UL), graft)
  update.set_tree(@common.Tree(@common.NodeId(0UL)))
  let tree = Tree::Tree(update, false)
  let graft_node = tree.state().node_by_id(nid(@common.NodeId(1UL))).unwrap()
  @test.assert_eq(0, graft_node.filtered_children(common_filter).length())
}

///|
test "iterators.filtered_children_crosses_subtree_boundary" {
  let subtree_id = @common.TreeId({ high: 0UL, low: 1UL })
  let update = @common.TreeUpdate(@common.TreeId::root(), @common.NodeId(0UL))
  let root = @common.Node(@common.Role::Window)
  root.set_children([@common.NodeId(1UL)])
  update.push_node(@common.NodeId(0UL), root)
  let graft = @common.Node(@common.Role::GenericContainer)
  graft.set_tree_id(subtree_id)
  update.push_node(@common.NodeId(1UL), graft)
  update.set_tree(@common.Tree(@common.NodeId(0UL)))
  let tree = Tree::Tree(update, false)
  let subtree_update = @common.TreeUpdate(subtree_id, @common.NodeId(0UL))
  let subtree_root = @common.Node(@common.Role::Document)
  subtree_root.set_children([@common.NodeId(1UL)])
  subtree_update.push_node(@common.NodeId(0UL), subtree_root)
  subtree_update.push_node(
    @common.NodeId(1UL),
    @common.Node(@common.Role::Button),
  )
  subtree_update.set_tree(@common.Tree(@common.NodeId(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  let filtered_children = tree.state().root().filtered_children(common_filter)
  @test.assert_eq(1, filtered_children.length())
  let subtree_root_id = NodeId(TreeIndex(1), @common.NodeId(0UL))
  @test.assert_eq(subtree_root_id, filtered_children[0].id())
  let doc_children = filtered_children[0].filtered_children(common_filter)
  @test.assert_eq(1, doc_children.length())
  let button_id = NodeId(TreeIndex(1), @common.NodeId(1UL))
  @test.assert_eq(button_id, doc_children[0].id())
}
