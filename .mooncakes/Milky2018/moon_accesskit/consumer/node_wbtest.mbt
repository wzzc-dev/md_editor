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
test "node.parent_and_index" {
  let tree = test_tree()
  assert_true(tree.state().root().parent_and_index() is None)
  @test.assert_eq(
    Some((ROOT_ID, 0)),
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_0_ID)))
    .unwrap()
    .parent_and_index()
    .map(p => (p.0.id().to_components().0.to_u64(), p.1)),
  )
  @test.assert_eq(
    Some((PARAGRAPH_0_ID, 0)),
    tree
    .state()
    .node_by_id(nid(lid(LABEL_0_0_IGNORED_ID)))
    .unwrap()
    .parent_and_index()
    .map(p => (p.0.id().to_components().0.to_u64(), p.1)),
  )
  @test.assert_eq(
    Some((ROOT_ID, 1)),
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_1_IGNORED_ID)))
    .unwrap()
    .parent_and_index()
    .map(p => (p.0.id().to_components().0.to_u64(), p.1)),
  )
}

///|
test "node.deepest_first_child" {
  let tree = test_tree()
  @test.assert_eq(
    LABEL_0_0_IGNORED_ID,
    tree.state().root().deepest_first_child().unwrap().id().to_components().0.to_u64(),
  )
  @test.assert_eq(
    LABEL_0_0_IGNORED_ID,
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_0_ID)))
    .unwrap()
    .deepest_first_child()
    .unwrap()
    .id()
    .to_components().0.to_u64(),
  )
  assert_true(
    tree
    .state()
    .node_by_id(nid(lid(LABEL_0_0_IGNORED_ID)))
    .unwrap()
    .deepest_first_child()
    is None,
  )
}

///|
test "node.filtered_parent" {
  let tree = test_tree()
  @test.assert_eq(
    ROOT_ID,
    tree
    .state()
    .node_by_id(nid(lid(LABEL_1_1_ID)))
    .unwrap()
    .filtered_parent(test_tree_filter)
    .unwrap()
    .id()
    .to_components().0.to_u64(),
  )
  assert_true(tree.state().root().filtered_parent(test_tree_filter) is None)
}

///|
test "node.deepest_first_filtered_child" {
  let tree = test_tree()
  @test.assert_eq(
    PARAGRAPH_0_ID,
    tree
    .state()
    .root()
    .deepest_first_filtered_child(test_tree_filter)
    .unwrap()
    .id()
    .to_components().0.to_u64(),
  )
  assert_true(
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_0_ID)))
    .unwrap()
    .deepest_first_filtered_child(test_tree_filter)
    is None,
  )
  assert_true(
    tree
    .state()
    .node_by_id(nid(lid(LABEL_0_0_IGNORED_ID)))
    .unwrap()
    .deepest_first_filtered_child(test_tree_filter)
    is None,
  )
}

///|
test "node.deepest_last_child" {
  let tree = test_tree()
  @test.assert_eq(
    EMPTY_CONTAINER_3_3_IGNORED_ID,
    tree.state().root().deepest_last_child().unwrap().id().to_components().0.to_u64(),
  )
  @test.assert_eq(
    EMPTY_CONTAINER_3_3_IGNORED_ID,
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_3_IGNORED_ID)))
    .unwrap()
    .deepest_last_child()
    .unwrap()
    .id()
    .to_components().0.to_u64(),
  )
  assert_true(
    tree
    .state()
    .node_by_id(nid(lid(BUTTON_3_2_ID)))
    .unwrap()
    .deepest_last_child()
    is None,
  )
}

///|
test "node.deepest_last_filtered_child" {
  let tree = test_tree()
  @test.assert_eq(
    BUTTON_3_2_ID,
    tree
    .state()
    .root()
    .deepest_last_filtered_child(test_tree_filter)
    .unwrap()
    .id()
    .to_components().0.to_u64(),
  )
  @test.assert_eq(
    BUTTON_3_2_ID,
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_3_IGNORED_ID)))
    .unwrap()
    .deepest_last_filtered_child(test_tree_filter)
    .unwrap()
    .id()
    .to_components().0.to_u64(),
  )
  assert_true(
    tree
    .state()
    .node_by_id(nid(lid(BUTTON_3_2_ID)))
    .unwrap()
    .deepest_last_filtered_child(test_tree_filter)
    is None,
  )
  assert_true(
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_0_ID)))
    .unwrap()
    .deepest_last_filtered_child(test_tree_filter)
    is None,
  )
}

///|
test "node.is_descendant_of" {
  let tree = test_tree()
  assert_true(
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_0_ID)))
    .unwrap()
    .is_descendant_of(tree.state().root()),
  )
  assert_true(
    tree
    .state()
    .node_by_id(nid(lid(LABEL_0_0_IGNORED_ID)))
    .unwrap()
    .is_descendant_of(tree.state().root()),
  )
  assert_true(
    tree
    .state()
    .node_by_id(nid(lid(LABEL_0_0_IGNORED_ID)))
    .unwrap()
    .is_descendant_of(
      tree.state().node_by_id(nid(lid(PARAGRAPH_0_ID))).unwrap(),
    ),
  )
  assert_true(
    !tree
    .state()
    .node_by_id(nid(lid(LABEL_0_0_IGNORED_ID)))
    .unwrap()
    .is_descendant_of(
      tree.state().node_by_id(nid(lid(PARAGRAPH_2_ID))).unwrap(),
    ),
  )
  assert_true(
    !tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_0_ID)))
    .unwrap()
    .is_descendant_of(
      tree.state().node_by_id(nid(lid(PARAGRAPH_2_ID))).unwrap(),
    ),
  )
}

///|
test "node.is_root" {
  let tree = test_tree()
  assert_true(tree.state().node_by_id(nid(lid(ROOT_ID))).unwrap().is_root())
  assert_true(
    !tree.state().node_by_id(nid(lid(PARAGRAPH_0_ID))).unwrap().is_root(),
  )
}

///|
test "node.bounding_box" {
  let tree = test_tree()
  assert_true(
    tree.state().node_by_id(nid(lid(ROOT_ID))).unwrap().bounding_box() is None,
  )
  @test.assert_eq(
    Some(@common.Rect(10.0, 40.0, 810.0, 80.0)),
    tree
    .state()
    .node_by_id(nid(lid(PARAGRAPH_1_IGNORED_ID)))
    .unwrap()
    .bounding_box(),
  )
  @test.assert_eq(
    Some(@common.Rect(20.0, 50.0, 100.0, 70.0)),
    tree.state().node_by_id(nid(lid(LABEL_1_1_ID))).unwrap().bounding_box(),
  )
}

///|
test "node.node_at_point" {
  let tree = test_tree()
  assert_true(
    tree
    .state()
    .root()
    .node_at_point(@common.Point(10.0, 40.0), test_tree_filter)
    is None,
  )
  @test.assert_eq(
    Some(nid(lid(LABEL_1_1_ID))),
    tree
    .state()
    .root()
    .node_at_point(@common.Point(20.0, 50.0), test_tree_filter)
    .map(node => node.id()),
  )
  @test.assert_eq(
    Some(nid(lid(LABEL_1_1_ID))),
    tree
    .state()
    .root()
    .node_at_point(@common.Point(50.0, 60.0), test_tree_filter)
    .map(node => node.id()),
  )
  assert_true(
    tree
    .state()
    .root()
    .node_at_point(@common.Point(100.0, 70.0), test_tree_filter)
    is None,
  )
}

///|
test "node.no_label_or_labelled_by" {
  let update = @common.TreeUpdate(@common.TreeId::root(), @common.NodeId(0UL))
  let root = @common.Node(@common.Role::Window)
  root.set_children([@common.NodeId(1UL)])
  update.push_node(@common.NodeId(0UL), root)
  update.push_node(@common.NodeId(1UL), @common.Node(@common.Role::Button))
  update.set_tree(@common.Tree(@common.NodeId(0UL)))
  let tree = Tree::Tree(update, false)
  @test.assert_eq(
    None,
    tree.state().node_by_id(nid(@common.NodeId(1UL))).unwrap().label(),
  )
}

///|
test "node.label_from_labelled_by" {
  let label_1 = "Check email every"
  let label_2 = "minutes"
  let update = @common.TreeUpdate(@common.TreeId::root(), @common.NodeId(0UL))
  let root = @common.Node(@common.Role::Window)
  root.set_children([
    @common.NodeId(1UL),
    @common.NodeId(2UL),
    @common.NodeId(3UL),
    @common.NodeId(4UL),
  ])
  update.push_node(@common.NodeId(0UL), root)
  let checkbox = @common.Node(@common.Role::CheckBox)
  checkbox.set_labelled_by([@common.NodeId(2UL), @common.NodeId(4UL)])
  update.push_node(@common.NodeId(1UL), checkbox)
  let node2 = @common.Node(@common.Role::Label)
  node2.set_value(label_1)
  update.push_node(@common.NodeId(2UL), node2)
  let text_input = @common.Node(@common.Role::TextInput)
  text_input.push_labelled_by(@common.NodeId(4UL))
  update.push_node(@common.NodeId(3UL), text_input)
  let node4 = @common.Node(@common.Role::Label)
  node4.set_value(label_2)
  update.push_node(@common.NodeId(4UL), node4)
  update.set_tree(@common.Tree(@common.NodeId(0UL)))
  let tree = Tree::Tree(update, false)
  @test.assert_eq(
    Some([label_1, label_2].join(" ")),
    tree.state().node_by_id(nid(@common.NodeId(1UL))).unwrap().label(),
  )
  @test.assert_eq(
    Some(label_2),
    tree.state().node_by_id(nid(@common.NodeId(3UL))).unwrap().label(),
  )
}

///|
test "node.write_label_prefers_direct_label" {
  let direct_label = "Direct"
  let other_label = "Other"
  let update = @common.TreeUpdate(@common.TreeId::root(), @common.NodeId(0UL))
  let root = @common.Node(@common.Role::Window)
  root.set_children([@common.NodeId(1UL), @common.NodeId(2UL)])
  update.push_node(@common.NodeId(0UL), root)
  let button = @common.Node(@common.Role::Button)
  button.set_label(direct_label)
  button.set_labelled_by([@common.NodeId(2UL)])
  update.push_node(@common.NodeId(1UL), button)
  let label = @common.Node(@common.Role::Label)
  label.set_value(other_label)
  update.push_node(@common.NodeId(2UL), label)
  update.set_tree(@common.Tree(@common.NodeId(0UL)))
  let tree = Tree::Tree(update, false)
  let node = tree.state().node_by_id(nid(@common.NodeId(1UL))).unwrap()
  let buf = StringBuilder::new()
  assert_true(node.write_label(buf))
  @test.assert_eq(direct_label, buf.to_string())
}

///|
test "node.write_value_writes_document_range_for_single_line_input" {
  let update = @common.TreeUpdate(@common.TreeId::root(), @common.NodeId(1UL))
  let root = @common.Node(@common.Role::Window)
  root.set_children([@common.NodeId(1UL)])
  update.push_node(@common.NodeId(0UL), root)
  let text_input = @common.Node(@common.Role::TextInput)
  text_input.push_child(@common.NodeId(2UL))
  update.push_node(@common.NodeId(1UL), text_input)
  let text_run = @common.Node(@common.Role::TextRun)
  text_run.set_value("A")
  text_run.set_character_lengths([1])
  text_run.set_character_positions([0.0])
  text_run.set_character_widths([8.0])
  text_run.set_word_starts([0])
  text_run.set_text_direction(@common.TextDirection::LeftToRight)
  update.push_node(@common.NodeId(2UL), text_run)
  update.set_tree(@common.Tree(@common.NodeId(0UL)))
  let tree = Tree::Tree(update, false)
  let node = tree.state().node_by_id(nid(@common.NodeId(1UL))).unwrap()
  let buf = StringBuilder::new()
  assert_true(node.write_value(buf))
  @test.assert_eq("A", buf.to_string())
}

///|
test "node.label_from_descendant_label" {
  let default_button_label = "Play"
  let link_label = "Watch in browser"
  let checkbox_label = "Resume from previous position"
  let radio_button_label = "Normal speed"
  let menu_button_label = "More"
  let menu_item_label = "Share"
  let menu_item_checkbox_label = "Apply volume processing"
  let menu_item_radio_label = "Maximize loudness for noisy environment"
  let update = @common.TreeUpdate(@common.TreeId::root(), @common.NodeId(0UL))
  let root = @common.Node(@common.Role::Window)
  root.set_children([
    @common.NodeId(1UL),
    @common.NodeId(3UL),
    @common.NodeId(6UL),
    @common.NodeId(8UL),
    @common.NodeId(10UL),
    @common.NodeId(12UL),
  ])
  update.push_node(@common.NodeId(0UL), root)
  let default_button = @common.Node(@common.Role::DefaultButton)
  default_button.push_child(@common.NodeId(2UL))
  update.push_node(@common.NodeId(1UL), default_button)
  let default_button_label_node = @common.Node(@common.Role::Image)
  default_button_label_node.set_label(default_button_label)
  update.push_node(@common.NodeId(2UL), default_button_label_node)
  let link = @common.Node(@common.Role::Link)
  link.push_child(@common.NodeId(4UL))
  update.push_node(@common.NodeId(3UL), link)
  let link_label_container = @common.Node(@common.Role::GenericContainer)
  link_label_container.push_child(@common.NodeId(5UL))
  update.push_node(@common.NodeId(4UL), link_label_container)
  let link_label_node = @common.Node(@common.Role::Label)
  link_label_node.set_value(link_label)
  update.push_node(@common.NodeId(5UL), link_label_node)
  let checkbox = @common.Node(@common.Role::CheckBox)
  checkbox.push_child(@common.NodeId(7UL))
  update.push_node(@common.NodeId(6UL), checkbox)
  let checkbox_label_node = @common.Node(@common.Role::Label)
  checkbox_label_node.set_value(checkbox_label)
  update.push_node(@common.NodeId(7UL), checkbox_label_node)
  let radio_button = @common.Node(@common.Role::RadioButton)
  radio_button.push_child(@common.NodeId(9UL))
  update.push_node(@common.NodeId(8UL), radio_button)
  let radio_button_label_node = @common.Node(@common.Role::Label)
  radio_button_label_node.set_value(radio_button_label)
  update.push_node(@common.NodeId(9UL), radio_button_label_node)
  let menu_button = @common.Node(@common.Role::Button)
  menu_button.push_child(@common.NodeId(11UL))
  update.push_node(@common.NodeId(10UL), menu_button)
  let menu_button_label_node = @common.Node(@common.Role::Label)
  menu_button_label_node.set_value(menu_button_label)
  update.push_node(@common.NodeId(11UL), menu_button_label_node)
  let menu = @common.Node(@common.Role::Menu)
  menu.set_children([
    @common.NodeId(13UL),
    @common.NodeId(15UL),
    @common.NodeId(17UL),
  ])
  update.push_node(@common.NodeId(12UL), menu)
  let menu_item = @common.Node(@common.Role::MenuItem)
  menu_item.push_child(@common.NodeId(14UL))
  update.push_node(@common.NodeId(13UL), menu_item)
  let menu_item_label_node = @common.Node(@common.Role::Label)
  menu_item_label_node.set_value(menu_item_label)
  update.push_node(@common.NodeId(14UL), menu_item_label_node)
  let menu_item_checkbox = @common.Node(@common.Role::MenuItemCheckBox)
  menu_item_checkbox.push_child(@common.NodeId(16UL))
  update.push_node(@common.NodeId(15UL), menu_item_checkbox)
  let menu_item_checkbox_label_node = @common.Node(@common.Role::Label)
  menu_item_checkbox_label_node.set_value(menu_item_checkbox_label)
  update.push_node(@common.NodeId(16UL), menu_item_checkbox_label_node)
  let menu_item_radio = @common.Node(@common.Role::MenuItemRadio)
  menu_item_radio.push_child(@common.NodeId(18UL))
  update.push_node(@common.NodeId(17UL), menu_item_radio)
  let menu_item_radio_label_node = @common.Node(@common.Role::Label)
  menu_item_radio_label_node.set_value(menu_item_radio_label)
  update.push_node(@common.NodeId(18UL), menu_item_radio_label_node)
  update.set_tree(@common.Tree(@common.NodeId(0UL)))
  let tree = Tree::Tree(update, false)
  @test.assert_eq(
    Some(default_button_label),
    tree.state().node_by_id(nid(@common.NodeId(1UL))).unwrap().label(),
  )
  @test.assert_eq(
    Some(link_label),
    tree.state().node_by_id(nid(@common.NodeId(3UL))).unwrap().label(),
  )
  @test.assert_eq(
    Some(checkbox_label),
    tree.state().node_by_id(nid(@common.NodeId(6UL))).unwrap().label(),
  )
  @test.assert_eq(
    Some(radio_button_label),
    tree.state().node_by_id(nid(@common.NodeId(8UL))).unwrap().label(),
  )
  @test.assert_eq(
    Some(menu_button_label),
    tree.state().node_by_id(nid(@common.NodeId(10UL))).unwrap().label(),
  )
  @test.assert_eq(
    Some(menu_item_label),
    tree.state().node_by_id(nid(@common.NodeId(13UL))).unwrap().label(),
  )
  @test.assert_eq(
    Some(menu_item_checkbox_label),
    tree.state().node_by_id(nid(@common.NodeId(15UL))).unwrap().label(),
  )
  @test.assert_eq(
    Some(menu_item_radio_label),
    tree.state().node_by_id(nid(@common.NodeId(17UL))).unwrap().label(),
  )
}

///|
test "node.placeholder_should_be_exposed_on_empty_text_input" {
  let placeholder = "John Doe"
  let update = @common.TreeUpdate(@common.TreeId::root(), @common.NodeId(1UL))
  let root = @common.Node(@common.Role::Window)
  root.set_children([@common.NodeId(1UL)])
  update.push_node(@common.NodeId(0UL), root)
  let text_input = @common.Node(@common.Role::MultilineTextInput)
  text_input.set_bounds(@common.Rect(8.0, 8.0, 296.0, 69.5))
  text_input.push_child(@common.NodeId(2UL))
  text_input.set_placeholder(placeholder)
  text_input.set_text_selection(
    @common.TextSelection(
      @common.TextPosition(@common.NodeId(2UL), 0),
      @common.TextPosition(@common.NodeId(2UL), 0),
    ),
  )
  text_input.add_action(@common.Action::Focus)
  update.push_node(@common.NodeId(1UL), text_input)
  let text_run = @common.Node(@common.Role::TextRun)
  text_run.set_bounds(@common.Rect(12.0, 10.0, 12.0, 24.0))
  text_run.set_value("")
  text_run.set_character_lengths([])
  text_run.set_character_positions([])
  text_run.set_character_widths([])
  text_run.set_text_direction(@common.TextDirection::LeftToRight)
  update.push_node(@common.NodeId(2UL), text_run)
  update.set_tree(@common.Tree(@common.NodeId(0UL)))
  let tree = Tree::Tree(update, false)
  @test.assert_eq(
    Some(placeholder),
    tree.state().node_by_id(nid(@common.NodeId(1UL))).unwrap().placeholder(),
  )
}

///|
test "node.placeholder_should_not_be_exposed_on_non_empty_text_input" {
  let placeholder = "John Doe"
  let update = @common.TreeUpdate(@common.TreeId::root(), @common.NodeId(1UL))
  let root = @common.Node(@common.Role::Window)
  root.set_children([@common.NodeId(1UL)])
  update.push_node(@common.NodeId(0UL), root)
  let text_input = @common.Node(@common.Role::MultilineTextInput)
  text_input.set_bounds(@common.Rect(8.0, 8.0, 296.0, 69.5))
  text_input.push_child(@common.NodeId(2UL))
  text_input.set_placeholder(placeholder)
  text_input.set_text_selection(
    @common.TextSelection(
      @common.TextPosition(@common.NodeId(2UL), 1),
      @common.TextPosition(@common.NodeId(2UL), 1),
    ),
  )
  text_input.add_action(@common.Action::Focus)
  update.push_node(@common.NodeId(1UL), text_input)
  let text_run = @common.Node(@common.Role::TextRun)
  text_run.set_bounds(@common.Rect(12.0, 10.0, 20.0, 24.0))
  text_run.set_value("A")
  text_run.set_character_lengths([1])
  text_run.set_character_positions([0.0])
  text_run.set_character_widths([8.0])
  text_run.set_word_starts([0])
  text_run.set_text_direction(@common.TextDirection::LeftToRight)
  update.push_node(@common.NodeId(2UL), text_run)
  update.set_tree(@common.Tree(@common.NodeId(0UL)))
  let tree = Tree::Tree(update, false)
  @test.assert_eq(
    None,
    tree.state().node_by_id(nid(@common.NodeId(1UL))).unwrap().placeholder(),
  )
}

///|
test "node.hidden_flag_should_be_inherited" {
  let update = @common.TreeUpdate(@common.TreeId::root(), @common.NodeId(0UL))
  let root = @common.Node(@common.Role::Window)
  root.set_children([@common.NodeId(1UL)])
  update.push_node(@common.NodeId(0UL), root)
  let container = @common.Node(@common.Role::GenericContainer)
  container.set_hidden()
  container.push_child(@common.NodeId(2UL))
  update.push_node(@common.NodeId(1UL), container)
  let leaf = @common.Node(@common.Role::Button)
  leaf.set_label("OK")
  update.push_node(@common.NodeId(2UL), leaf)
  update.set_tree(@common.Tree(@common.NodeId(0UL)))
  let tree = Tree::Tree(update, false)
  assert_true(
    tree.state().node_by_id(nid(@common.NodeId(2UL))).unwrap().is_hidden(),
  )
}

///|
test "node_id.new_and_to_components_round_trip" {
  let node_id = @common.NodeId::from_u64(42UL)
  let tree_index = TreeIndex(7)
  let id = NodeId(tree_index, node_id)
  let (extracted_node_id, extracted_tree_index) = id.to_components()
  @test.assert_eq(node_id, extracted_node_id)
  @test.assert_eq(tree_index, extracted_tree_index)
}

///|
test "node_id.with_same_tree_preserves_tree_index" {
  let original_node_id = @common.NodeId::from_u64(100UL)
  let tree_index = TreeIndex(5)
  let id = NodeId(tree_index, original_node_id)
  let new_node_id = @common.NodeId::from_u64(200UL)
  let new_id = id.with_same_tree(new_node_id)
  let (extracted_node_id, extracted_tree_index) = new_id.to_components()
  @test.assert_eq(new_node_id, extracted_node_id)
  @test.assert_eq(tree_index, extracted_tree_index)
}

///|
test "node_id.into_u128" {
  let node_id = @common.NodeId::from_u64(12345UL)
  let tree_index = TreeIndex(67)
  let id = NodeId(tree_index, node_id)
  let (extracted_node_id, extracted_tree_index) = id.to_components()
  @test.assert_eq(node_id, extracted_node_id)
  @test.assert_eq(tree_index, extracted_tree_index)
}

///|
test "node_id.equality" {
  let id1 = NodeId(TreeIndex(2), @common.NodeId::from_u64(1UL))
  let id2 = NodeId(TreeIndex(2), @common.NodeId::from_u64(1UL))
  let id3 = NodeId(TreeIndex(3), @common.NodeId::from_u64(1UL))
  let id4 = NodeId(TreeIndex(2), @common.NodeId::from_u64(2UL))
  @test.assert_eq(id1, id2)
  assert_true(id1 != id3)
  assert_true(id1 != id4)
}

///|
test "node.is_focused_when_node_has_focus" {
  let update = @common.TreeUpdate(@common.TreeId::root(), @common.NodeId(1UL))
  let root = @common.Node(@common.Role::Window)
  root.set_children([@common.NodeId(1UL)])
  update.push_node(@common.NodeId(0UL), root)
  update.push_node(@common.NodeId(1UL), @common.Node(@common.Role::Button))
  update.set_tree(@common.Tree(@common.NodeId(0UL)))
  let tree = Tree::Tree(update, true)
  assert_true(
    tree.state().node_by_id(nid(@common.NodeId(1UL))).unwrap().is_focused(),
  )
}

///|
test "node.is_focused_when_node_does_not_have_focus" {
  let update = @common.TreeUpdate(@common.TreeId::root(), @common.NodeId(0UL))
  let root = @common.Node(@common.Role::Window)
  root.set_children([@common.NodeId(1UL)])
  update.push_node(@common.NodeId(0UL), root)
  update.push_node(@common.NodeId(1UL), @common.Node(@common.Role::Button))
  update.set_tree(@common.Tree(@common.NodeId(0UL)))
  let tree = Tree::Tree(update, true)
  assert_true(
    !tree.state().node_by_id(nid(@common.NodeId(1UL))).unwrap().is_focused(),
  )
}

///|
test "node.is_focused_active_descendant_is_focused" {
  let update = @common.TreeUpdate(@common.TreeId::root(), @common.NodeId(1UL))
  let root = @common.Node(@common.Role::Window)
  root.set_children([@common.NodeId(1UL)])
  update.push_node(@common.NodeId(0UL), root)
  let listbox = @common.Node(@common.Role::ListBox)
  listbox.set_children([@common.NodeId(2UL)])
  listbox.set_active_descendant(@common.NodeId(2UL))
  update.push_node(@common.NodeId(1UL), listbox)
  update.push_node(
    @common.NodeId(2UL),
    @common.Node(@common.Role::ListBoxOption),
  )
  update.set_tree(@common.Tree(@common.NodeId(0UL)))
  let tree = Tree::Tree(update, true)
  assert_true(
    tree.state().node_by_id(nid(@common.NodeId(2UL))).unwrap().is_focused(),
  )
}

///|
test "node.is_focused_node_with_active_descendant_is_not_focused" {
  let update = @common.TreeUpdate(@common.TreeId::root(), @common.NodeId(1UL))
  let root = @common.Node(@common.Role::Window)
  root.set_children([@common.NodeId(1UL)])
  update.push_node(@common.NodeId(0UL), root)
  let listbox = @common.Node(@common.Role::ListBox)
  listbox.set_children([@common.NodeId(2UL)])
  listbox.set_active_descendant(@common.NodeId(2UL))
  update.push_node(@common.NodeId(1UL), listbox)
  update.push_node(
    @common.NodeId(2UL),
    @common.Node(@common.Role::ListBoxOption),
  )
  update.set_tree(@common.Tree(@common.NodeId(0UL)))
  let tree = Tree::Tree(update, true)
  assert_true(
    !tree.state().node_by_id(nid(@common.NodeId(1UL))).unwrap().is_focused(),
  )
}
