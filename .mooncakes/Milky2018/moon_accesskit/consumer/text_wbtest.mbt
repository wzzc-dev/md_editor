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
fn text_test_decoration_1() -> @common.TextDecoration {
  @common.TextDecoration(
    @common.TextDecorationStyle::Solid,
    @common.Color((0).to_byte(), (0).to_byte(), (0).to_byte(), (255).to_byte()),
  )
}

///|
fn text_test_decoration_2() -> @common.TextDecoration {
  @common.TextDecoration(
    @common.TextDecorationStyle::Dotted,
    @common.Color(
      (255).to_byte(),
      (0).to_byte(),
      (0).to_byte(),
      (255).to_byte(),
    ),
  )
}

///|
fn text_test_decoration_3() -> @common.TextDecoration {
  @common.TextDecoration(
    @common.TextDecorationStyle::Dashed,
    @common.Color(
      (0).to_byte(),
      (255).to_byte(),
      (0).to_byte(),
      (255).to_byte(),
    ),
  )
}

///|
fn text_test_decoration_4() -> @common.TextDecoration {
  @common.TextDecoration(
    @common.TextDecorationStyle::Double,
    @common.Color(
      (0).to_byte(),
      (0).to_byte(),
      (255).to_byte(),
      (255).to_byte(),
    ),
  )
}

///|
fn expect(cond : Bool) -> Unit raise {
  @test.assert_eq(cond, true)
}

///|
fn inherited_tree_one_run(
  parent_setup : (@common.Node) -> Unit,
  run_setup : (@common.Node) -> Unit,
) -> Tree {
  let id0 = @common.NodeId::from_u64(0UL)
  let id1 = @common.NodeId::from_u64(1UL)
  let update = @common.TreeUpdate(@common.TreeId::root(), id0)
  let root = @common.Node(@common.Role::TextInput)
  root.set_children([id1])
  parent_setup(root)
  let run = @common.Node(@common.Role::TextRun)
  run.set_value("text")
  run.set_character_lengths([1, 1, 1, 1])
  run_setup(run)
  update.push_node(id0, root)
  update.push_node(id1, run)
  update.set_tree(@common.Tree(id0))
  Tree::Tree(update, false)
}

///|
fn inherited_tree_two_runs(
  parent_setup : (@common.Node) -> Unit,
  run1_setup : (@common.Node) -> Unit,
  run2_setup : (@common.Node) -> Unit,
) -> Tree {
  let id0 = @common.NodeId::from_u64(0UL)
  let id1 = @common.NodeId::from_u64(1UL)
  let id2 = @common.NodeId::from_u64(2UL)
  let update = @common.TreeUpdate(@common.TreeId::root(), id0)
  let root = @common.Node(@common.Role::TextInput)
  root.set_children([id1, id2])
  parent_setup(root)
  let run1 = @common.Node(@common.Role::TextRun)
  run1.set_value("text 1\n")
  run1.set_character_lengths([1, 1, 1, 1, 1, 1, 1])
  run1_setup(run1)
  let run2 = @common.Node(@common.Role::TextRun)
  run2.set_value("text 2")
  run2.set_character_lengths([1, 1, 1, 1, 1, 1])
  run2_setup(run2)
  update.push_node(id0, root)
  update.push_node(id1, run1)
  update.push_node(id2, run2)
  update.set_tree(@common.Tree(id0))
  Tree::Tree(update, false)
}

///|
test "text.inherited.text_direction.directly_set" {
  let tree = inherited_tree_one_run(_ => (), n => {
    n.set_text_direction(@common.TextDirection::LeftToRight)
  })
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  let pos = node.document_start()
  @test.assert_eq(
    pos.text_direction(),
    Some(@common.TextDirection::LeftToRight),
  )
  let range = node.document_range()
  @test.assert_eq(
    range.text_direction(),
    RangePropertyValue::Single(Some(@common.TextDirection::LeftToRight)),
  )
}

///|
test "text.inherited.text_direction.set_on_parent" {
  let tree = inherited_tree_one_run(
    n => n.set_text_direction(@common.TextDirection::LeftToRight),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  let pos = node.document_start()
  @test.assert_eq(
    pos.text_direction(),
    Some(@common.TextDirection::LeftToRight),
  )
  let range = node.document_range()
  @test.assert_eq(
    range.text_direction(),
    RangePropertyValue::Single(Some(@common.TextDirection::LeftToRight)),
  )
}

///|
test "text.inherited.text_direction.only_child_overrides_parent" {
  let tree = inherited_tree_one_run(
    n => n.set_text_direction(@common.TextDirection::LeftToRight),
    n => n.set_text_direction(@common.TextDirection::RightToLeft),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.text_direction(),
    Some(@common.TextDirection::LeftToRight),
  )
  let pos = node.document_start()
  @test.assert_eq(
    pos.text_direction(),
    Some(@common.TextDirection::RightToLeft),
  )
  let range = node.document_range()
  @test.assert_eq(
    range.text_direction(),
    RangePropertyValue::Single(Some(@common.TextDirection::RightToLeft)),
  )
}

///|
test "text.inherited.text_direction.unset" {
  let tree = inherited_tree_one_run(_ => (), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  let pos = node.document_start()
  @test.assert_eq(pos.text_direction(), None)
  let range = node.document_range()
  @test.assert_eq(range.text_direction(), RangePropertyValue::Single(None))
}

///|
test "text.inherited.text_direction.mixed_some_and_none" {
  let tree = inherited_tree_two_runs(
    _ => (),
    n => n.set_text_direction(@common.TextDirection::LeftToRight),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_range().text_direction(),
    RangePropertyValue::Mixed,
  )
}

///|
test "text.inherited.text_direction.mixed_one_child_overrides_parent" {
  let tree = inherited_tree_two_runs(
    n => n.set_text_direction(@common.TextDirection::LeftToRight),
    n => n.set_text_direction(@common.TextDirection::RightToLeft),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.text_direction(),
    Some(@common.TextDirection::LeftToRight),
  )
  let start = node.document_start()
  @test.assert_eq(
    start.text_direction(),
    Some(@common.TextDirection::RightToLeft),
  )
  @test.assert_eq(
    start.to_degenerate_range().text_direction(),
    RangePropertyValue::Single(Some(@common.TextDirection::RightToLeft)),
  )
  let end = node.document_end()
  @test.assert_eq(
    end.text_direction(),
    Some(@common.TextDirection::LeftToRight),
  )
  @test.assert_eq(
    end.to_degenerate_range().text_direction(),
    RangePropertyValue::Single(Some(@common.TextDirection::LeftToRight)),
  )
  @test.assert_eq(
    node.document_range().text_direction(),
    RangePropertyValue::Mixed,
  )
}

///|
test "text.inherited.font_family.directly_set" {
  let tree = inherited_tree_one_run(_ => (), n => n.set_font_family("Noto"))
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  let pos = node.document_start()
  @test.assert_eq(pos.font_family(), Some("Noto"))
  @test.assert_eq(
    node.document_range().font_family(),
    RangePropertyValue::Single(Some("Noto")),
  )
}

///|
test "text.inherited.font_family.set_on_parent" {
  let tree = inherited_tree_one_run(n => n.set_font_family("Noto"), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  let pos = node.document_start()
  @test.assert_eq(pos.font_family(), Some("Noto"))
  @test.assert_eq(
    node.document_range().font_family(),
    RangePropertyValue::Single(Some("Noto")),
  )
}

///|
test "text.inherited.font_family.only_child_overrides_parent" {
  let tree = inherited_tree_one_run(n => n.set_font_family("Noto"), n => {
    n.set_font_family("Inconsolata")
  })
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.font_family(), Some("Noto"))
  let pos = node.document_start()
  @test.assert_eq(pos.font_family(), Some("Inconsolata"))
  @test.assert_eq(
    node.document_range().font_family(),
    RangePropertyValue::Single(Some("Inconsolata")),
  )
}

///|
test "text.inherited.font_family.unset" {
  let tree = inherited_tree_one_run(_ => (), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().font_family(), None)
  @test.assert_eq(
    node.document_range().font_family(),
    RangePropertyValue::Single(None),
  )
}

///|
test "text.inherited.font_family.mixed_some_and_none" {
  let tree = inherited_tree_two_runs(_ => (), n => n.set_font_family("Noto"), _ => {
    ()
  })
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_range().font_family(),
    RangePropertyValue::Mixed,
  )
}

///|
test "text.inherited.font_family.mixed_one_child_overrides_parent" {
  let tree = inherited_tree_two_runs(
    n => n.set_font_family("Noto"),
    n => n.set_font_family("Inconsolata"),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.font_family(), Some("Noto"))
  let start = node.document_start()
  @test.assert_eq(start.font_family(), Some("Inconsolata"))
  @test.assert_eq(
    start.to_degenerate_range().font_family(),
    RangePropertyValue::Single(Some("Inconsolata")),
  )
  let end = node.document_end()
  @test.assert_eq(end.font_family(), Some("Noto"))
  @test.assert_eq(
    end.to_degenerate_range().font_family(),
    RangePropertyValue::Single(Some("Noto")),
  )
  @test.assert_eq(
    node.document_range().font_family(),
    RangePropertyValue::Mixed,
  )
}

///|
test "text.inherited.language.directly_set" {
  let tree = inherited_tree_one_run(_ => (), n => n.set_language("en"))
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().language(), Some("en"))
  @test.assert_eq(
    node.document_range().language(),
    RangePropertyValue::Single(Some("en")),
  )
}

///|
test "text.inherited.language.set_on_parent" {
  let tree = inherited_tree_one_run(n => n.set_language("en"), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().language(), Some("en"))
  @test.assert_eq(
    node.document_range().language(),
    RangePropertyValue::Single(Some("en")),
  )
}

///|
test "text.inherited.language.only_child_overrides_parent" {
  let tree = inherited_tree_one_run(n => n.set_language("en"), n => {
    n.set_language("fr")
  })
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.language(), Some("en"))
  @test.assert_eq(node.document_start().language(), Some("fr"))
  @test.assert_eq(
    node.document_range().language(),
    RangePropertyValue::Single(Some("fr")),
  )
}

///|
test "text.inherited.language.unset" {
  let tree = inherited_tree_one_run(_ => (), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().language(), None)
  @test.assert_eq(
    node.document_range().language(),
    RangePropertyValue::Single(None),
  )
}

///|
test "text.inherited.language.mixed_some_and_none" {
  let tree = inherited_tree_two_runs(_ => (), n => n.set_language("en"), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_range().language(), RangePropertyValue::Mixed)
}

///|
test "text.inherited.language.mixed_one_child_overrides_parent" {
  let tree = inherited_tree_two_runs(
    n => n.set_language("en"),
    n => n.set_language("fr"),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.language(), Some("en"))
  let start = node.document_start()
  @test.assert_eq(start.language(), Some("fr"))
  @test.assert_eq(
    start.to_degenerate_range().language(),
    RangePropertyValue::Single(Some("fr")),
  )
  let end = node.document_end()
  @test.assert_eq(end.language(), Some("en"))
  @test.assert_eq(
    end.to_degenerate_range().language(),
    RangePropertyValue::Single(Some("en")),
  )
  @test.assert_eq(node.document_range().language(), RangePropertyValue::Mixed)
}

///|
test "text.inherited.font_size.directly_set" {
  let tree = inherited_tree_one_run(_ => (), n => n.set_font_size(12.0F))
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().font_size(), Some(12.0F))
  @test.assert_eq(
    node.document_range().font_size(),
    RangePropertyValue::Single(Some(12.0F)),
  )
}

///|
test "text.inherited.font_size.set_on_parent" {
  let tree = inherited_tree_one_run(n => n.set_font_size(12.0F), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().font_size(), Some(12.0F))
  @test.assert_eq(
    node.document_range().font_size(),
    RangePropertyValue::Single(Some(12.0F)),
  )
}

///|
test "text.inherited.font_size.only_child_overrides_parent" {
  let tree = inherited_tree_one_run(n => n.set_font_size(12.0F), n => {
    n.set_font_size(24.0F)
  })
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.font_size(), Some(12.0F))
  @test.assert_eq(node.document_start().font_size(), Some(24.0F))
  @test.assert_eq(
    node.document_range().font_size(),
    RangePropertyValue::Single(Some(24.0F)),
  )
}

///|
test "text.inherited.font_size.unset" {
  let tree = inherited_tree_one_run(_ => (), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().font_size(), None)
  @test.assert_eq(
    node.document_range().font_size(),
    RangePropertyValue::Single(None),
  )
}

///|
test "text.inherited.font_size.mixed_some_and_none" {
  let tree = inherited_tree_two_runs(_ => (), n => n.set_font_size(12.0F), _ => {
    ()
  })
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_range().font_size(), RangePropertyValue::Mixed)
}

///|
test "text.inherited.font_size.mixed_one_child_overrides_parent" {
  let tree = inherited_tree_two_runs(
    n => n.set_font_size(12.0F),
    n => n.set_font_size(24.0F),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.font_size(), Some(12.0F))
  let start = node.document_start()
  @test.assert_eq(start.font_size(), Some(24.0F))
  @test.assert_eq(
    start.to_degenerate_range().font_size(),
    RangePropertyValue::Single(Some(24.0F)),
  )
  let end = node.document_end()
  @test.assert_eq(end.font_size(), Some(12.0F))
  @test.assert_eq(
    end.to_degenerate_range().font_size(),
    RangePropertyValue::Single(Some(12.0F)),
  )
  @test.assert_eq(node.document_range().font_size(), RangePropertyValue::Mixed)
}

///|
test "text.inherited.font_weight.directly_set" {
  let tree = inherited_tree_one_run(_ => (), n => n.set_font_weight(400.0F))
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().font_weight(), Some(400.0F))
  @test.assert_eq(
    node.document_range().font_weight(),
    RangePropertyValue::Single(Some(400.0F)),
  )
}

///|
test "text.inherited.font_weight.set_on_parent" {
  let tree = inherited_tree_one_run(n => n.set_font_weight(400.0F), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().font_weight(), Some(400.0F))
  @test.assert_eq(
    node.document_range().font_weight(),
    RangePropertyValue::Single(Some(400.0F)),
  )
}

///|
test "text.inherited.font_weight.only_child_overrides_parent" {
  let tree = inherited_tree_one_run(n => n.set_font_weight(400.0F), n => {
    n.set_font_weight(700.0F)
  })
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.font_weight(), Some(400.0F))
  @test.assert_eq(node.document_start().font_weight(), Some(700.0F))
  @test.assert_eq(
    node.document_range().font_weight(),
    RangePropertyValue::Single(Some(700.0F)),
  )
}

///|
test "text.inherited.font_weight.unset" {
  let tree = inherited_tree_one_run(_ => (), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().font_weight(), None)
  @test.assert_eq(
    node.document_range().font_weight(),
    RangePropertyValue::Single(None),
  )
}

///|
test "text.inherited.font_weight.mixed_some_and_none" {
  let tree = inherited_tree_two_runs(_ => (), n => n.set_font_weight(400.0F), _ => {
    ()
  })
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_range().font_weight(),
    RangePropertyValue::Mixed,
  )
}

///|
test "text.inherited.font_weight.mixed_one_child_overrides_parent" {
  let tree = inherited_tree_two_runs(
    n => n.set_font_weight(400.0F),
    n => n.set_font_weight(700.0F),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.font_weight(), Some(400.0F))
  let start = node.document_start()
  @test.assert_eq(start.font_weight(), Some(700.0F))
  @test.assert_eq(
    start.to_degenerate_range().font_weight(),
    RangePropertyValue::Single(Some(700.0F)),
  )
  let end = node.document_end()
  @test.assert_eq(end.font_weight(), Some(400.0F))
  @test.assert_eq(
    end.to_degenerate_range().font_weight(),
    RangePropertyValue::Single(Some(400.0F)),
  )
  @test.assert_eq(
    node.document_range().font_weight(),
    RangePropertyValue::Mixed,
  )
}

///|
test "text.inherited.background_color.directly_set" {
  let white = @common.Color(
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
  )
  let tree = inherited_tree_one_run(_ => (), n => n.set_background_color(white))
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().background_color(), Some(white))
  @test.assert_eq(
    node.document_range().background_color(),
    RangePropertyValue::Single(Some(white)),
  )
}

///|
test "text.inherited.background_color.set_on_parent" {
  let white = @common.Color(
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
  )
  let tree = inherited_tree_one_run(n => n.set_background_color(white), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().background_color(), Some(white))
  @test.assert_eq(
    node.document_range().background_color(),
    RangePropertyValue::Single(Some(white)),
  )
}

///|
test "text.inherited.background_color.only_child_overrides_parent" {
  let white = @common.Color(
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
  )
  let red = @common.Color(
    (255).to_byte(),
    (0).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
  )
  let tree = inherited_tree_one_run(n => n.set_background_color(white), n => {
    n.set_background_color(red)
  })
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.background_color(), Some(white))
  @test.assert_eq(node.document_start().background_color(), Some(red))
  @test.assert_eq(
    node.document_range().background_color(),
    RangePropertyValue::Single(Some(red)),
  )
}

///|
test "text.inherited.background_color.unset" {
  let tree = inherited_tree_one_run(_ => (), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().background_color(), None)
  @test.assert_eq(
    node.document_range().background_color(),
    RangePropertyValue::Single(None),
  )
}

///|
test "text.inherited.background_color.mixed_some_and_none" {
  let white = @common.Color(
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
  )
  let tree = inherited_tree_two_runs(
    _ => (),
    n => n.set_background_color(white),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_range().background_color(),
    RangePropertyValue::Mixed,
  )
}

///|
test "text.inherited.background_color.mixed_one_child_overrides_parent" {
  let white = @common.Color(
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
  )
  let red = @common.Color(
    (255).to_byte(),
    (0).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
  )
  let tree = inherited_tree_two_runs(
    n => n.set_background_color(white),
    n => n.set_background_color(red),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.background_color(), Some(white))
  let start = node.document_start()
  @test.assert_eq(start.background_color(), Some(red))
  @test.assert_eq(
    start.to_degenerate_range().background_color(),
    RangePropertyValue::Single(Some(red)),
  )
  let end = node.document_end()
  @test.assert_eq(end.background_color(), Some(white))
  @test.assert_eq(
    end.to_degenerate_range().background_color(),
    RangePropertyValue::Single(Some(white)),
  )
  @test.assert_eq(
    node.document_range().background_color(),
    RangePropertyValue::Mixed,
  )
}

///|
test "text.inherited.foreground_color.directly_set" {
  let black = @common.Color(
    (0).to_byte(),
    (0).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
  )
  let tree = inherited_tree_one_run(_ => (), n => n.set_foreground_color(black))
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().foreground_color(), Some(black))
  @test.assert_eq(
    node.document_range().foreground_color(),
    RangePropertyValue::Single(Some(black)),
  )
}

///|
test "text.inherited.foreground_color.set_on_parent" {
  let black = @common.Color(
    (0).to_byte(),
    (0).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
  )
  let tree = inherited_tree_one_run(n => n.set_foreground_color(black), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().foreground_color(), Some(black))
  @test.assert_eq(
    node.document_range().foreground_color(),
    RangePropertyValue::Single(Some(black)),
  )
}

///|
test "text.inherited.foreground_color.only_child_overrides_parent" {
  let black = @common.Color(
    (0).to_byte(),
    (0).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
  )
  let blue = @common.Color(
    (0).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
  )
  let tree = inherited_tree_one_run(n => n.set_foreground_color(black), n => {
    n.set_foreground_color(blue)
  })
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.foreground_color(), Some(black))
  @test.assert_eq(node.document_start().foreground_color(), Some(blue))
  @test.assert_eq(
    node.document_range().foreground_color(),
    RangePropertyValue::Single(Some(blue)),
  )
}

///|
test "text.inherited.foreground_color.unset" {
  let tree = inherited_tree_one_run(_ => (), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().foreground_color(), None)
  @test.assert_eq(
    node.document_range().foreground_color(),
    RangePropertyValue::Single(None),
  )
}

///|
test "text.inherited.foreground_color.mixed_some_and_none" {
  let black = @common.Color(
    (0).to_byte(),
    (0).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
  )
  let tree = inherited_tree_two_runs(
    _ => (),
    n => n.set_foreground_color(black),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_range().foreground_color(),
    RangePropertyValue::Mixed,
  )
}

///|
test "text.inherited.foreground_color.mixed_one_child_overrides_parent" {
  let black = @common.Color(
    (0).to_byte(),
    (0).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
  )
  let blue = @common.Color(
    (0).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
  )
  let tree = inherited_tree_two_runs(
    n => n.set_foreground_color(black),
    n => n.set_foreground_color(blue),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.foreground_color(), Some(black))
  let start = node.document_start()
  @test.assert_eq(start.foreground_color(), Some(blue))
  @test.assert_eq(
    start.to_degenerate_range().foreground_color(),
    RangePropertyValue::Single(Some(blue)),
  )
  let end = node.document_end()
  @test.assert_eq(end.foreground_color(), Some(black))
  @test.assert_eq(
    end.to_degenerate_range().foreground_color(),
    RangePropertyValue::Single(Some(black)),
  )
  @test.assert_eq(
    node.document_range().foreground_color(),
    RangePropertyValue::Mixed,
  )
}

///|
test "text.inherited.overline.directly_set" {
  let tree = inherited_tree_one_run(_ => (), n => {
    n.set_overline(text_test_decoration_1())
  })
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_start().overline(),
    Some(text_test_decoration_1()),
  )
  @test.assert_eq(
    node.document_range().overline(),
    RangePropertyValue::Single(Some(text_test_decoration_1())),
  )
}

///|
test "text.inherited.overline.set_on_parent" {
  let tree = inherited_tree_one_run(
    n => n.set_overline(text_test_decoration_1()),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_start().overline(),
    Some(text_test_decoration_1()),
  )
  @test.assert_eq(
    node.document_range().overline(),
    RangePropertyValue::Single(Some(text_test_decoration_1())),
  )
}

///|
test "text.inherited.overline.only_child_overrides_parent" {
  let tree = inherited_tree_one_run(
    n => n.set_overline(text_test_decoration_1()),
    n => n.set_overline(text_test_decoration_2()),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.overline(), Some(text_test_decoration_1()))
  @test.assert_eq(
    node.document_start().overline(),
    Some(text_test_decoration_2()),
  )
  @test.assert_eq(
    node.document_range().overline(),
    RangePropertyValue::Single(Some(text_test_decoration_2())),
  )
}

///|
test "text.inherited.overline.unset" {
  let tree = inherited_tree_one_run(_ => (), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().overline(), None)
  @test.assert_eq(
    node.document_range().overline(),
    RangePropertyValue::Single(None),
  )
}

///|
test "text.inherited.overline.mixed_some_and_none" {
  let tree = inherited_tree_two_runs(
    _ => (),
    n => n.set_overline(text_test_decoration_1()),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_range().overline(), RangePropertyValue::Mixed)
}

///|
test "text.inherited.overline.mixed_one_child_overrides_parent" {
  let tree = inherited_tree_two_runs(
    n => n.set_overline(text_test_decoration_1()),
    n => n.set_overline(text_test_decoration_2()),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.overline(), Some(text_test_decoration_1()))
  let start = node.document_start()
  @test.assert_eq(start.overline(), Some(text_test_decoration_2()))
  @test.assert_eq(
    start.to_degenerate_range().overline(),
    RangePropertyValue::Single(Some(text_test_decoration_2())),
  )
  let end = node.document_end()
  @test.assert_eq(end.overline(), Some(text_test_decoration_1()))
  @test.assert_eq(
    end.to_degenerate_range().overline(),
    RangePropertyValue::Single(Some(text_test_decoration_1())),
  )
  @test.assert_eq(node.document_range().overline(), RangePropertyValue::Mixed)
}

///|
test "text.inherited.strikethrough.directly_set" {
  let tree = inherited_tree_one_run(_ => (), n => {
    n.set_strikethrough(text_test_decoration_2())
  })
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_start().strikethrough(),
    Some(text_test_decoration_2()),
  )
  @test.assert_eq(
    node.document_range().strikethrough(),
    RangePropertyValue::Single(Some(text_test_decoration_2())),
  )
}

///|
test "text.inherited.strikethrough.set_on_parent" {
  let tree = inherited_tree_one_run(
    n => n.set_strikethrough(text_test_decoration_2()),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_start().strikethrough(),
    Some(text_test_decoration_2()),
  )
  @test.assert_eq(
    node.document_range().strikethrough(),
    RangePropertyValue::Single(Some(text_test_decoration_2())),
  )
}

///|
test "text.inherited.strikethrough.only_child_overrides_parent" {
  let tree = inherited_tree_one_run(
    n => n.set_strikethrough(text_test_decoration_2()),
    n => n.set_strikethrough(text_test_decoration_3()),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.strikethrough(), Some(text_test_decoration_2()))
  @test.assert_eq(
    node.document_start().strikethrough(),
    Some(text_test_decoration_3()),
  )
  @test.assert_eq(
    node.document_range().strikethrough(),
    RangePropertyValue::Single(Some(text_test_decoration_3())),
  )
}

///|
test "text.inherited.strikethrough.unset" {
  let tree = inherited_tree_one_run(_ => (), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().strikethrough(), None)
  @test.assert_eq(
    node.document_range().strikethrough(),
    RangePropertyValue::Single(None),
  )
}

///|
test "text.inherited.strikethrough.mixed_some_and_none" {
  let tree = inherited_tree_two_runs(
    _ => (),
    n => n.set_strikethrough(text_test_decoration_2()),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_range().strikethrough(),
    RangePropertyValue::Mixed,
  )
}

///|
test "text.inherited.strikethrough.mixed_one_child_overrides_parent" {
  let tree = inherited_tree_two_runs(
    n => n.set_strikethrough(text_test_decoration_2()),
    n => n.set_strikethrough(text_test_decoration_3()),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.strikethrough(), Some(text_test_decoration_2()))
  let start = node.document_start()
  @test.assert_eq(start.strikethrough(), Some(text_test_decoration_3()))
  @test.assert_eq(
    start.to_degenerate_range().strikethrough(),
    RangePropertyValue::Single(Some(text_test_decoration_3())),
  )
  let end = node.document_end()
  @test.assert_eq(end.strikethrough(), Some(text_test_decoration_2()))
  @test.assert_eq(
    end.to_degenerate_range().strikethrough(),
    RangePropertyValue::Single(Some(text_test_decoration_2())),
  )
  @test.assert_eq(
    node.document_range().strikethrough(),
    RangePropertyValue::Mixed,
  )
}

///|
test "text.inherited.underline.directly_set" {
  let tree = inherited_tree_one_run(_ => (), n => {
    n.set_underline(text_test_decoration_3())
  })
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_start().underline(),
    Some(text_test_decoration_3()),
  )
  @test.assert_eq(
    node.document_range().underline(),
    RangePropertyValue::Single(Some(text_test_decoration_3())),
  )
}

///|
test "text.inherited.underline.set_on_parent" {
  let tree = inherited_tree_one_run(
    n => n.set_underline(text_test_decoration_3()),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_start().underline(),
    Some(text_test_decoration_3()),
  )
  @test.assert_eq(
    node.document_range().underline(),
    RangePropertyValue::Single(Some(text_test_decoration_3())),
  )
}

///|
test "text.inherited.underline.only_child_overrides_parent" {
  let tree = inherited_tree_one_run(
    n => n.set_underline(text_test_decoration_3()),
    n => n.set_underline(text_test_decoration_4()),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.underline(), Some(text_test_decoration_3()))
  @test.assert_eq(
    node.document_start().underline(),
    Some(text_test_decoration_4()),
  )
  @test.assert_eq(
    node.document_range().underline(),
    RangePropertyValue::Single(Some(text_test_decoration_4())),
  )
}

///|
test "text.inherited.underline.unset" {
  let tree = inherited_tree_one_run(_ => (), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().underline(), None)
  @test.assert_eq(
    node.document_range().underline(),
    RangePropertyValue::Single(None),
  )
}

///|
test "text.inherited.underline.mixed_some_and_none" {
  let tree = inherited_tree_two_runs(
    _ => (),
    n => n.set_underline(text_test_decoration_3()),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_range().underline(), RangePropertyValue::Mixed)
}

///|
test "text.inherited.underline.mixed_one_child_overrides_parent" {
  let tree = inherited_tree_two_runs(
    n => n.set_underline(text_test_decoration_3()),
    n => n.set_underline(text_test_decoration_4()),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.underline(), Some(text_test_decoration_3()))
  let start = node.document_start()
  @test.assert_eq(start.underline(), Some(text_test_decoration_4()))
  @test.assert_eq(
    start.to_degenerate_range().underline(),
    RangePropertyValue::Single(Some(text_test_decoration_4())),
  )
  let end = node.document_end()
  @test.assert_eq(end.underline(), Some(text_test_decoration_3()))
  @test.assert_eq(
    end.to_degenerate_range().underline(),
    RangePropertyValue::Single(Some(text_test_decoration_3())),
  )
  @test.assert_eq(node.document_range().underline(), RangePropertyValue::Mixed)
}

///|
test "text.inherited.text_align.directly_set" {
  let tree = inherited_tree_one_run(_ => (), n => {
    n.set_text_align(@common.TextAlign::Left)
  })
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_start().text_align(),
    Some(@common.TextAlign::Left),
  )
  @test.assert_eq(
    node.document_range().text_align(),
    RangePropertyValue::Single(Some(@common.TextAlign::Left)),
  )
}

///|
test "text.inherited.text_align.set_on_parent" {
  let tree = inherited_tree_one_run(
    n => n.set_text_align(@common.TextAlign::Left),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_start().text_align(),
    Some(@common.TextAlign::Left),
  )
  @test.assert_eq(
    node.document_range().text_align(),
    RangePropertyValue::Single(Some(@common.TextAlign::Left)),
  )
}

///|
test "text.inherited.text_align.only_child_overrides_parent" {
  let tree = inherited_tree_one_run(
    n => n.set_text_align(@common.TextAlign::Left),
    n => n.set_text_align(@common.TextAlign::Justify),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.text_align(), Some(@common.TextAlign::Left))
  @test.assert_eq(
    node.document_start().text_align(),
    Some(@common.TextAlign::Justify),
  )
  @test.assert_eq(
    node.document_range().text_align(),
    RangePropertyValue::Single(Some(@common.TextAlign::Justify)),
  )
}

///|
test "text.inherited.text_align.unset" {
  let tree = inherited_tree_one_run(_ => (), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().text_align(), None)
  @test.assert_eq(
    node.document_range().text_align(),
    RangePropertyValue::Single(None),
  )
}

///|
test "text.inherited.text_align.mixed_some_and_none" {
  let tree = inherited_tree_two_runs(
    _ => (),
    n => n.set_text_align(@common.TextAlign::Left),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_range().text_align(), RangePropertyValue::Mixed)
}

///|
test "text.inherited.text_align.mixed_one_child_overrides_parent" {
  let tree = inherited_tree_two_runs(
    n => n.set_text_align(@common.TextAlign::Left),
    n => n.set_text_align(@common.TextAlign::Justify),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.text_align(), Some(@common.TextAlign::Left))
  let start = node.document_start()
  @test.assert_eq(start.text_align(), Some(@common.TextAlign::Justify))
  @test.assert_eq(
    start.to_degenerate_range().text_align(),
    RangePropertyValue::Single(Some(@common.TextAlign::Justify)),
  )
  let end = node.document_end()
  @test.assert_eq(end.text_align(), Some(@common.TextAlign::Left))
  @test.assert_eq(
    end.to_degenerate_range().text_align(),
    RangePropertyValue::Single(Some(@common.TextAlign::Left)),
  )
  @test.assert_eq(node.document_range().text_align(), RangePropertyValue::Mixed)
}

///|
test "text.inherited.vertical_offset.directly_set" {
  let tree = inherited_tree_one_run(_ => (), n => {
    n.set_vertical_offset(@common.VerticalOffset::Subscript)
  })
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_start().vertical_offset(),
    Some(@common.VerticalOffset::Subscript),
  )
  @test.assert_eq(
    node.document_range().vertical_offset(),
    RangePropertyValue::Single(Some(@common.VerticalOffset::Subscript)),
  )
}

///|
test "text.inherited.vertical_offset.set_on_parent" {
  let tree = inherited_tree_one_run(
    n => n.set_vertical_offset(@common.VerticalOffset::Subscript),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_start().vertical_offset(),
    Some(@common.VerticalOffset::Subscript),
  )
  @test.assert_eq(
    node.document_range().vertical_offset(),
    RangePropertyValue::Single(Some(@common.VerticalOffset::Subscript)),
  )
}

///|
test "text.inherited.vertical_offset.only_child_overrides_parent" {
  let tree = inherited_tree_one_run(
    n => n.set_vertical_offset(@common.VerticalOffset::Subscript),
    n => n.set_vertical_offset(@common.VerticalOffset::Superscript),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.vertical_offset(),
    Some(@common.VerticalOffset::Subscript),
  )
  @test.assert_eq(
    node.document_start().vertical_offset(),
    Some(@common.VerticalOffset::Superscript),
  )
  @test.assert_eq(
    node.document_range().vertical_offset(),
    RangePropertyValue::Single(Some(@common.VerticalOffset::Superscript)),
  )
}

///|
test "text.inherited.vertical_offset.unset" {
  let tree = inherited_tree_one_run(_ => (), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_start().vertical_offset(), None)
  @test.assert_eq(
    node.document_range().vertical_offset(),
    RangePropertyValue::Single(None),
  )
}

///|
test "text.inherited.vertical_offset.mixed_some_and_none" {
  let tree = inherited_tree_two_runs(
    _ => (),
    n => n.set_vertical_offset(@common.VerticalOffset::Subscript),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.document_range().vertical_offset(),
    RangePropertyValue::Mixed,
  )
}

///|
test "text.inherited.vertical_offset.mixed_one_child_overrides_parent" {
  let tree = inherited_tree_two_runs(
    n => n.set_vertical_offset(@common.VerticalOffset::Subscript),
    n => n.set_vertical_offset(@common.VerticalOffset::Superscript),
    _ => (),
  )
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(
    node.vertical_offset(),
    Some(@common.VerticalOffset::Subscript),
  )
  let start = node.document_start()
  @test.assert_eq(
    start.vertical_offset(),
    Some(@common.VerticalOffset::Superscript),
  )
  @test.assert_eq(
    start.to_degenerate_range().vertical_offset(),
    RangePropertyValue::Single(Some(@common.VerticalOffset::Superscript)),
  )
  let end = node.document_end()
  @test.assert_eq(
    end.vertical_offset(),
    Some(@common.VerticalOffset::Subscript),
  )
  @test.assert_eq(
    end.to_degenerate_range().vertical_offset(),
    RangePropertyValue::Single(Some(@common.VerticalOffset::Subscript)),
  )
  @test.assert_eq(
    node.document_range().vertical_offset(),
    RangePropertyValue::Mixed,
  )
}

///|
test "text.inherited.is_italic.directly_set" {
  let tree = inherited_tree_one_run(_ => (), n => n.set_italic())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  expect(node.document_start().is_italic())
  @test.assert_eq(
    node.document_range().is_italic(),
    RangePropertyValue::Single(true),
  )
}

///|
test "text.inherited.is_italic.set_on_parent" {
  let tree = inherited_tree_one_run(n => n.set_italic(), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  expect(node.document_start().is_italic())
  @test.assert_eq(
    node.document_range().is_italic(),
    RangePropertyValue::Single(true),
  )
}

///|
test "text.inherited.is_italic.unset" {
  let tree = inherited_tree_one_run(_ => (), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  expect(!node.document_start().is_italic())
  @test.assert_eq(
    node.document_range().is_italic(),
    RangePropertyValue::Single(false),
  )
}

///|
test "text.inherited.is_italic.mixed" {
  let tree = inherited_tree_two_runs(_ => (), n => n.set_italic(), _ => ())
  let node = tree
    .state()
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
  @test.assert_eq(node.document_range().is_italic(), RangePropertyValue::Mixed)
}

///|
fn main_multiline_tree(selection : @common.TextSelection?) -> Tree {
  let id0 = @common.NodeId::from_u64(0UL)
  let id1 = @common.NodeId::from_u64(1UL)
  let id2 = @common.NodeId::from_u64(2UL)
  let id3 = @common.NodeId::from_u64(3UL)
  let id4 = @common.NodeId::from_u64(4UL)
  let id5 = @common.NodeId::from_u64(5UL)
  let id6 = @common.NodeId::from_u64(6UL)
  let id7 = @common.NodeId::from_u64(7UL)
  let id8 = @common.NodeId::from_u64(8UL)
  let id9 = @common.NodeId::from_u64(9UL)
  let update = @common.TreeUpdate(@common.TreeId::root(), id1)
  let n0 = @common.Node(@common.Role::Window)
  n0.set_transform(@common.Affine::scale(1.5))
  n0.set_children([id1])
  let n1 = @common.Node(@common.Role::MultilineTextInput)
  n1.set_bounds(
    @common.Rect(8.0, 31.666664123535156, 296.0, 123.66666412353516),
  )
  n1.set_children([id2, id3, id4, id5, id6, id7, id8, id9])
  n1.add_action(@common.Action::Focus)
  n1.set_text_direction(@common.TextDirection::LeftToRight)
  if selection is Some(sel) {
    n1.set_text_selection(sel)
  }
  let n2 = @common.Node(@common.Role::TextRun)
  n2.set_bounds(
    @common.Rect(12.0, 33.666664123535156, 290.9189147949219, 48.33333206176758),
  )
  n2.set_value("This paragraph is\u{a0}long enough to wrap ")
  n2.set_character_lengths([
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  ])
  n2.set_character_positions([
    0.0F, 7.3333335F, 14.666667F, 22.0F, 29.333334F, 36.666668F, 44.0F, 51.333332F,
    58.666668F, 66.0F, 73.333336F, 80.666664F, 88.0F, 95.333336F, 102.666664F, 110.0F,
    117.333336F, 124.666664F, 132.0F, 139.33333F, 146.66667F, 154.0F, 161.33333F,
    168.66667F, 176.0F, 183.33333F, 190.66667F, 198.0F, 205.33333F, 212.66667F, 220.0F,
    227.33333F, 234.66667F, 242.0F, 249.33333F, 256.66666F, 264.0F, 271.33334F,
  ])
  n2.set_character_widths([
    7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F,
    7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F,
    7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F,
    7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F,
    7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F,
  ])
  n2.set_word_starts([5, 15, 18, 23, 30, 33])
  let n3 = @common.Node(@common.Role::TextRun)
  n3.set_bounds(@common.Rect(12.0, 48.33333206176758, 34.252257, 63.0))
  n3.set_value("to ")
  n3.set_character_lengths([1, 1, 1])
  n3.set_character_positions([0.0F, 7.3333435F, 14.666687F])
  n3.set_character_widths([7.58557F, 7.58557F, 7.58557F])
  n3.set_word_starts([0])
  n3.set_next_on_line(id4)
  let n4 = @common.Node(@common.Role::TextRun)
  n4.set_bounds(@common.Rect(34.0, 48.33333206176758, 85.58557, 63.0))
  n4.set_value("another")
  n4.set_character_lengths([1, 1, 1, 1, 1, 1, 1])
  n4.set_character_positions([
    0.0F, 7.333344F, 14.666687F, 22.0F, 29.333344F, 36.666687F, 44.0F,
  ])
  n4.set_character_widths([
    7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F,
  ])
  n4.set_word_starts([0])
  n4.set_underline(text_test_decoration_1())
  n4.set_previous_on_line(id3)
  n4.set_next_on_line(id5)
  let n5 = @common.Node(@common.Role::TextRun)
  n5.set_bounds(
    @common.Rect(85.33334, 48.33333206176758, 129.5855712890625, 63.0),
  )
  n5.set_value(" line.\n")
  n5.set_character_lengths([1, 1, 1, 1, 1, 1, 1])
  n5.set_character_positions([
    0.0F, 7.333344F, 14.666687F, 22.0F, 29.333344F, 36.666687F, 44.25226F,
  ])
  n5.set_character_widths([
    7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 0.0F,
  ])
  n5.set_word_starts([1])
  n5.set_previous_on_line(id4)
  let n6 = @common.Node(@common.Role::TextRun)
  n6.set_bounds(@common.Rect(12.0, 63.0, 144.25222778320313, 77.66666412353516))
  n6.set_value("Another paragraph.\n")
  n6.set_character_lengths([
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
  ])
  n6.set_character_positions([
    0.0F, 7.3333335F, 14.666667F, 22.0F, 29.333334F, 36.666668F, 44.0F, 51.333332F,
    58.666668F, 66.0F, 73.333336F, 80.666664F, 88.0F, 95.333336F, 102.666664F, 110.0F,
    117.333336F, 124.666664F, 132.25223F,
  ])
  n6.set_character_widths([
    7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F,
    7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F,
    7.58557F, 7.58557F, 0.0F,
  ])
  n6.set_word_starts([8])
  let n7 = @common.Node(@common.Role::TextRun)
  n7.set_bounds(@common.Rect(12.0, 77.66666412353516, 12.0, 92.33332824707031))
  n7.set_value("\n")
  n7.set_character_lengths([1])
  n7.set_character_positions([0.0F])
  n7.set_character_widths([0.0F])
  let n8 = @common.Node(@common.Role::TextRun)
  n8.set_bounds(@common.Rect(12.0, 92.33332824707031, 158.9188995361328, 107.0))
  n8.set_value("Last non-blank line\u{1f44d}\u{1f3fb}\n")
  n8.set_character_lengths([
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8, 1,
  ])
  n8.set_character_positions([
    0.0F, 7.3333335F, 14.666667F, 22.0F, 29.333334F, 36.666668F, 44.0F, 51.333332F,
    58.666668F, 66.0F, 73.333336F, 80.666664F, 88.0F, 95.333336F, 102.666664F, 110.0F,
    117.333336F, 124.666664F, 132.0F, 139.33333F, 146.9189F,
  ])
  n8.set_character_widths([
    7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F,
    7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F, 7.58557F,
    7.58557F, 7.58557F, 7.58557F, 7.58557F, 0.0F,
  ])
  n8.set_word_starts([5, 9, 15])
  let n9 = @common.Node(@common.Role::TextRun)
  n9.set_bounds(@common.Rect(12.0, 107.0, 12.0, 121.66666412353516))
  n9.set_value("")
  n9.set_character_lengths([])
  n9.set_character_positions([])
  n9.set_character_widths([])
  update.push_node(id0, n0)
  update.push_node(id1, n1)
  update.push_node(id2, n2)
  update.push_node(id3, n3)
  update.push_node(id4, n4)
  update.push_node(id5, n5)
  update.push_node(id6, n6)
  update.push_node(id7, n7)
  update.push_node(id8, n8)
  update.push_node(id9, n9)
  update.set_tree(@common.Tree(id0))
  Tree::Tree(update, true)
}

///|
fn multiline_wrapped_line_end_selection() -> @common.TextSelection {
  @common.TextSelection(
    @common.TextPosition(@common.NodeId::from_u64(2UL), 38),
    @common.TextPosition(@common.NodeId::from_u64(2UL), 38),
  )
}

///|
fn multiline_first_line_middle_selection() -> @common.TextSelection {
  @common.TextSelection(
    @common.TextPosition(@common.NodeId::from_u64(2UL), 5),
    @common.TextPosition(@common.NodeId::from_u64(2UL), 5),
  )
}

///|
fn multiline_second_line_middle_selection() -> @common.TextSelection {
  @common.TextSelection(
    @common.TextPosition(@common.NodeId::from_u64(4UL), 3),
    @common.TextPosition(@common.NodeId::from_u64(4UL), 3),
  )
}

///|
fn multiline_past_end_selection() -> @common.TextSelection {
  @common.TextSelection(
    @common.TextPosition(@common.NodeId::from_u64(9UL), 3),
    @common.TextPosition(@common.NodeId::from_u64(9UL), 3),
  )
}

///|
test "text.supports_text_ranges" {
  let tree = main_multiline_tree(None)
  let state = tree.state()
  expect(
    !state
    .node_by_id(nid(@common.NodeId::from_u64(0UL)))
    .unwrap()
    .supports_text_ranges(),
  )
  expect(
    state
    .node_by_id(nid(@common.NodeId::from_u64(1UL)))
    .unwrap()
    .supports_text_ranges(),
  )
}

///|
test "text.multiline_document_range" {
  let tree = main_multiline_tree(None)
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  let range = node.document_range()
  let start = range.start()
  expect(start.is_word_start())
  expect(start.is_line_start())
  expect(!start.is_line_end())
  expect(start.is_paragraph_start())
  expect(start.is_document_start())
  expect(!start.is_document_end())
  let end = range.end()
  expect(start.compare(end).unwrap() < 0)
  expect(end.is_word_start())
  expect(end.is_line_start())
  expect(end.is_line_end())
  expect(end.is_paragraph_start())
  expect(!end.is_document_start())
  expect(end.is_document_end())
  @test.assert_eq(
    range.text(),
    "This paragraph is\u{a0}long enough to wrap to another line.\nAnother paragraph.\n\nLast non-blank line\u{1f44d}\u{1f3fb}\n",
  )
  @test.assert_eq(range.bounding_boxes(), [
    @common.Rect(18.0, 50.499996185302734, 436.3783721923828, 72.49999809265137),
    @common.Rect(18.0, 72.49999809265137, 51.3783855, 94.5),
    @common.Rect(51.0, 72.49999809265137, 128.378355, 94.5),
    @common.Rect(128.00001, 72.49999809265137, 194.37835693359375, 94.5),
    @common.Rect(18.0, 94.5, 216.3783416748047, 116.49999618530273),
    @common.Rect(18.0, 116.49999618530273, 18.0, 138.49999237060547),
    @common.Rect(18.0, 138.49999237060547, 238.37834930419922, 160.5),
  ])
}

///|
test "text.multiline_document_range_to_first_format_change" {
  let tree = main_multiline_tree(None)
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  let range = node.document_range()
  range.set_end(range.start().forward_to_format_end())
  @test.assert_eq(
    range.text(),
    "This paragraph is\u{a0}long enough to wrap to ",
  )
  @test.assert_eq(range.bounding_boxes(), [
    @common.Rect(18.0, 50.499996185302734, 436.3783721923828, 72.49999809265137),
    @common.Rect(18.0, 72.49999809265137, 51.3783855, 94.5),
  ])
}

///|
test "text.multiline_document_range_from_last_format_change" {
  let tree = main_multiline_tree(None)
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  let range = node.document_range()
  range.set_start(range.end().backward_to_format_start())
  @test.assert_eq(
    range.text(),
    " line.\nAnother paragraph.\n\nLast non-blank line\u{1f44d}\u{1f3fb}\n",
  )
  @test.assert_eq(range.bounding_boxes(), [
    @common.Rect(128.00001, 72.49999809265137, 194.37835693359375, 94.5),
    @common.Rect(18.0, 94.5, 216.3783416748047, 116.49999618530273),
    @common.Rect(18.0, 116.49999618530273, 18.0, 138.49999237060547),
    @common.Rect(18.0, 138.49999237060547, 238.37834930419922, 160.5),
  ])
}

///|
fn multiline_end_selection() -> @common.TextSelection {
  @common.TextSelection(
    @common.TextPosition(@common.NodeId::from_u64(9UL), 0),
    @common.TextPosition(@common.NodeId::from_u64(9UL), 0),
  )
}

///|
test "text.multiline_end_degenerate_range" {
  let tree = main_multiline_tree(Some(multiline_end_selection()))
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  let range = node.text_selection().unwrap()
  expect(range.is_degenerate())
  let pos = range.start()
  expect(pos.is_word_start())
  expect(pos.is_line_start())
  expect(pos.is_line_end())
  expect(pos.is_paragraph_start())
  expect(!pos.is_document_start())
  expect(pos.is_document_end())
  @test.assert_eq(range.text(), "")
  @test.assert_eq(range.bounding_boxes(), [
    @common.Rect(18.0, 160.5, 18.0, 182.49999618530273),
  ])
}

///|
test "text.multiline_wrapped_line_end_range" {
  let tree = main_multiline_tree(Some(multiline_wrapped_line_end_selection()))
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  let range = node.text_selection().unwrap()
  @test.assert_eq(range.is_degenerate(), true)
  let pos = range.start()
  @test.assert_eq(pos.is_word_start(), false)
  @test.assert_eq(pos.is_line_start(), false)
  @test.assert_eq(pos.is_line_end(), true)
  @test.assert_eq(pos.is_paragraph_start(), false)
  @test.assert_eq(pos.is_document_start(), false)
  @test.assert_eq(pos.is_document_end(), false)
  @test.assert_eq(range.text(), "")
  @test.assert_eq(range.bounding_boxes(), [
    @common.Rect(
      436.3783721923828, 50.499996185302734, 436.3783721923828, 72.49999809265137,
    ),
  ])
  let char_end_pos = pos.forward_to_character_end()
  let line_start_range = pos.to_degenerate_range()
  line_start_range.set_end(char_end_pos)
  @test.assert_eq(line_start_range.is_degenerate(), false)
  @test.assert_eq(line_start_range.start().is_line_start(), true)
  @test.assert_eq(line_start_range.text(), "t")
  @test.assert_eq(line_start_range.bounding_boxes(), [
    @common.Rect(18.0, 72.49999809265137, 29.378354787826538, 94.5),
  ])
  let prev_char_pos = pos.backward_to_character_start()
  let prev_char_range = pos.to_degenerate_range()
  prev_char_range.set_start(prev_char_pos)
  @test.assert_eq(prev_char_range.is_degenerate(), false)
  @test.assert_eq(prev_char_range.end().is_line_end(), true)
  @test.assert_eq(prev_char_range.text(), " ")
  @test.assert_eq(prev_char_range.bounding_boxes(), [
    @common.Rect(
      425.00001525878906, 50.499996185302734, 436.3783721923828, 72.49999809265137,
    ),
  ])
  @test.assert_eq(prev_char_pos.forward_to_character_end().is_line_end(), true)
  @test.assert_eq(prev_char_pos.forward_to_word_end().is_line_end(), true)
  @test.assert_eq(prev_char_pos.forward_to_line_end().is_line_end(), true)
  @test.assert_eq(
    prev_char_pos.forward_to_character_start().is_line_start(),
    true,
  )
  @test.assert_eq(prev_char_pos.forward_to_word_start().is_line_start(), true)
  @test.assert_eq(prev_char_pos.forward_to_line_start().is_line_start(), true)
}

///|
test "text.multiline_find_line_ends_from_middle" {
  let tree = main_multiline_tree(Some(multiline_second_line_middle_selection()))
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  let range = node.text_selection().unwrap()
  expect(range.is_degenerate())
  let pos = range.start()
  expect(!pos.is_line_start())
  expect(!pos.is_line_end())
  expect(!pos.is_document_start())
  expect(!pos.is_document_end())
  let line_start = pos.backward_to_line_start()
  range.set_start(line_start)
  let line_end = line_start.forward_to_line_end()
  range.set_end(line_end)
  expect(!range.is_degenerate())
  expect(range.start().is_line_start())
  expect(range.end().is_line_end())
  @test.assert_eq(range.text(), "to another line.\n")
  @test.assert_eq(range.bounding_boxes(), [
    @common.Rect(18.0, 72.49999809265137, 51.3783855, 94.5),
    @common.Rect(51.0, 72.49999809265137, 128.378355, 94.5),
    @common.Rect(128.00001, 72.49999809265137, 194.37835693359375, 94.5),
  ])
  expect(line_start.forward_to_line_start().is_line_start())
}

///|
test "text.multiline_find_wrapped_line_ends_from_middle" {
  let tree = main_multiline_tree(Some(multiline_first_line_middle_selection()))
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  let range = node.text_selection().unwrap()
  expect(range.is_degenerate())
  let pos = range.start()
  expect(!pos.is_line_start())
  expect(!pos.is_line_end())
  expect(!pos.is_document_start())
  expect(!pos.is_document_end())
  let line_start = pos.backward_to_line_start()
  range.set_start(line_start)
  let line_end = line_start.forward_to_line_end()
  range.set_end(line_end)
  expect(!range.is_degenerate())
  expect(range.start().is_line_start())
  expect(range.end().is_line_end())
  @test.assert_eq(range.text(), "This paragraph is\u{a0}long enough to wrap ")
  @test.assert_eq(range.bounding_boxes(), [
    @common.Rect(18.0, 50.499996185302734, 436.3783721923828, 72.49999809265137),
  ])
  expect(line_start.forward_to_line_start().is_line_start())
}

///|
test "text.multiline_find_paragraph_ends_from_middle" {
  let tree = main_multiline_tree(Some(multiline_second_line_middle_selection()))
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  let range = node.text_selection().unwrap()
  expect(range.is_degenerate())
  let pos = range.start()
  expect(!pos.is_paragraph_start())
  expect(!pos.is_document_start())
  expect(!pos.is_document_end())
  let paragraph_start = pos.backward_to_paragraph_start()
  range.set_start(paragraph_start)
  let paragraph_end = paragraph_start.forward_to_paragraph_end()
  range.set_end(paragraph_end)
  expect(!range.is_degenerate())
  expect(range.start().is_paragraph_start())
  expect(range.end().is_paragraph_end())
  @test.assert_eq(
    range.text(),
    "This paragraph is\u{a0}long enough to wrap to another line.\n",
  )
  @test.assert_eq(range.bounding_boxes(), [
    @common.Rect(18.0, 50.499996185302734, 436.3783721923828, 72.49999809265137),
    @common.Rect(18.0, 72.49999809265137, 51.3783855, 94.5),
    @common.Rect(51.0, 72.49999809265137, 128.378355, 94.5),
    @common.Rect(128.00001, 72.49999809265137, 194.37835693359375, 94.5),
  ])
  expect(paragraph_start.forward_to_paragraph_start().is_paragraph_start())
}

///|
test "text.multiline_find_format_ends_from_middle" {
  let tree = main_multiline_tree(Some(multiline_second_line_middle_selection()))
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  let range = node.text_selection().unwrap()
  expect(range.is_degenerate())
  let pos = range.start()
  expect(!pos.is_format_start())
  expect(!pos.is_document_start())
  expect(!pos.is_document_end())
  let format_start = pos.backward_to_format_start()
  range.set_start(format_start)
  let format_end = pos.forward_to_format_end()
  range.set_end(format_end)
  expect(!range.is_degenerate())
  @test.assert_eq(range.text(), "another")
  @test.assert_eq(range.bounding_boxes(), [
    @common.Rect(51.0, 72.49999809265137, 128.378355, 94.5),
  ])
}

///|
test "text.multiline_find_word_ends_from_middle" {
  let tree = main_multiline_tree(Some(multiline_second_line_middle_selection()))
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  let range = node.text_selection().unwrap()
  expect(range.is_degenerate())
  let pos = range.start()
  expect(!pos.is_word_start())
  expect(!pos.is_document_start())
  expect(!pos.is_document_end())
  let word_start = pos.backward_to_word_start()
  range.set_start(word_start)
  let word_end = word_start.forward_to_word_end()
  let word_end2 = pos.forward_to_word_end()
  expect(word_end.compare(word_end2).unwrap() == 0)
  let word_start2 = word_end.backward_to_word_start()
  expect(word_start.compare(word_start2).unwrap() == 0)
  range.set_end(word_end)
  expect(!range.is_degenerate())
  @test.assert_eq(range.text(), "another ")
  @test.assert_eq(range.bounding_boxes(), [
    @common.Rect(51.0, 72.49999809265137, 128.378355, 94.5),
    @common.Rect(128.00001, 72.49999809265137, 139.37836478782654, 94.5),
  ])
}

///|
test "text.text_position_at_point" {
  let tree = main_multiline_tree(None)
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  {
    let pos = node.text_position_at_point(
      @common.Point(8.0, 31.666664123535156),
    )
    expect(pos.is_document_start())
  }
  {
    let pos = node.text_position_at_point(
      @common.Point(12.0, 33.666664123535156),
    )
    expect(pos.is_document_start())
  }
  {
    let pos = node.text_position_at_point(@common.Point(16.0, 40.0))
    expect(pos.is_document_start())
  }
  {
    let pos = node.text_position_at_point(@common.Point(144.0, 40.0))
    expect(!pos.is_document_start())
    expect(!pos.is_document_end())
    expect(!pos.is_line_end())
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), "l")
  }
  {
    let pos = node.text_position_at_point(@common.Point(150.0, 40.0))
    expect(!pos.is_document_start())
    expect(!pos.is_document_end())
    expect(!pos.is_line_end())
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), "l")
  }
  {
    let pos = node.text_position_at_point(@common.Point(291.0, 40.0))
    expect(!pos.is_document_start())
    expect(!pos.is_document_end())
    expect(pos.is_line_end())
    let range = pos.to_degenerate_range()
    range.set_start(pos.backward_to_word_start())
    @test.assert_eq(range.text(), "wrap ")
  }
  {
    let pos = node.text_position_at_point(@common.Point(12.0, 50.0))
    expect(!pos.is_document_start())
    expect(pos.is_line_start())
    expect(!pos.is_paragraph_start())
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_word_end())
    @test.assert_eq(range.text(), "to ")
  }
  {
    let pos = node.text_position_at_point(@common.Point(130.0, 50.0))
    expect(!pos.is_document_start())
    expect(!pos.is_document_end())
    expect(pos.is_line_end())
    let range = pos.to_degenerate_range()
    range.set_start(pos.backward_to_word_start())
    @test.assert_eq(range.text(), "line.\n")
  }
  {
    let pos = node.text_position_at_point(@common.Point(12.0, 80.0))
    expect(!pos.is_document_start())
    expect(!pos.is_document_end())
    expect(pos.is_line_end())
    let range = pos.to_degenerate_range()
    range.set_start(pos.backward_to_line_start())
    @test.assert_eq(range.text(), "\n")
  }
  {
    let pos = node.text_position_at_point(@common.Point(12.0, 120.0))
    expect(pos.is_document_end())
  }
  let pos = node.text_position_at_point(@common.Point(250.0, 122.0))
  expect(pos.is_document_end())
}

///|
test "text.to_global_usv_index" {
  let tree = main_multiline_tree(None)
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  {
    let range = node.document_range()
    @test.assert_eq(range.start().to_global_usv_index(), 0)
    @test.assert_eq(range.end().to_global_usv_index(), 97)
  }
  let range = node.document_range()
  let pos = range.start().forward_to_line_end()
  @test.assert_eq(pos.to_global_usv_index(), 38)
  let pos = range.start().forward_to_line_start()
  @test.assert_eq(pos.to_global_usv_index(), 38)
  let pos = pos.forward_to_character_start()
  @test.assert_eq(pos.to_global_usv_index(), 39)
  let pos = pos.forward_to_line_start()
  @test.assert_eq(pos.to_global_usv_index(), 55)
}

///|
test "text.to_global_utf16_index" {
  let tree = main_multiline_tree(None)
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  {
    let range = node.document_range()
    @test.assert_eq(range.start().to_global_utf16_index(), 0)
    @test.assert_eq(range.end().to_global_utf16_index(), 99)
  }
  let range = node.document_range()
  let pos = range.start().forward_to_line_end()
  @test.assert_eq(pos.to_global_utf16_index(), 38)
  let pos = range.start().forward_to_line_start()
  @test.assert_eq(pos.to_global_utf16_index(), 38)
  let pos = pos.forward_to_character_start()
  @test.assert_eq(pos.to_global_utf16_index(), 39)
  let pos = pos.forward_to_line_start()
  @test.assert_eq(pos.to_global_utf16_index(), 55)
}

///|
test "text.to_line_index" {
  let tree = main_multiline_tree(None)
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  {
    let range = node.document_range()
    @test.assert_eq(range.start().to_line_index(), 0)
    @test.assert_eq(range.end().to_line_index(), 5)
  }
  let range = node.document_range()
  let pos = range.start().forward_to_line_end()
  @test.assert_eq(pos.to_line_index(), 0)
  let pos = range.start().forward_to_line_start()
  @test.assert_eq(pos.to_line_index(), 1)
  let pos = pos.forward_to_character_start()
  @test.assert_eq(pos.to_line_index(), 1)
  @test.assert_eq(pos.forward_to_line_end().to_line_index(), 1)
  let pos = pos.forward_to_line_start()
  @test.assert_eq(pos.to_line_index(), 2)
}

///|
test "text.line_range_from_index" {
  let tree = main_multiline_tree(None)
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  @test.assert_eq(
    node.line_range_from_index(0).unwrap().text(),
    "This paragraph is\u{a0}long enough to wrap ",
  )
  @test.assert_eq(
    node.line_range_from_index(1).unwrap().text(),
    "to another line.\n",
  )
  @test.assert_eq(
    node.line_range_from_index(2).unwrap().text(),
    "Another paragraph.\n",
  )
  @test.assert_eq(node.line_range_from_index(3).unwrap().text(), "\n")
  @test.assert_eq(
    node.line_range_from_index(4).unwrap().text(),
    "Last non-blank line\u{1f44d}\u{1f3fb}\n",
  )
  @test.assert_eq(node.line_range_from_index(5).unwrap().text(), "")
  expect(node.line_range_from_index(6) is None)
}

///|
test "text.text_position_from_global_usv_index" {
  let tree = main_multiline_tree(None)
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  {
    let pos = node.text_position_from_global_usv_index(0).unwrap()
    expect(pos.is_document_start())
  }
  {
    let pos = node.text_position_from_global_usv_index(17).unwrap()
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), "\u{a0}")
  }
  {
    let pos = node.text_position_from_global_usv_index(18).unwrap()
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), "l")
  }
  {
    let pos = node.text_position_from_global_usv_index(37).unwrap()
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), " ")
  }
  {
    let pos = node.text_position_from_global_usv_index(38).unwrap()
    expect(!pos.is_paragraph_start())
    expect(pos.is_line_start())
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), "t")
  }
  {
    let pos = node.text_position_from_global_usv_index(54).unwrap()
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), "\n")
  }
  {
    let pos = node.text_position_from_global_usv_index(55).unwrap()
    expect(pos.is_paragraph_start())
    expect(pos.is_line_start())
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), "A")
  }
  for i in 94..<=95 {
    let pos = node.text_position_from_global_usv_index(i).unwrap()
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), "\u{1f44d}\u{1f3fb}")
  }
  {
    let pos = node.text_position_from_global_usv_index(96).unwrap()
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), "\n")
  }
  {
    let pos = node.text_position_from_global_usv_index(97).unwrap()
    expect(pos.is_document_end())
  }
  expect(node.text_position_from_global_usv_index(98) is None)
}

///|
test "text.text_position_from_global_utf16_index" {
  let tree = main_multiline_tree(None)
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  {
    let pos = node.text_position_from_global_utf16_index(0).unwrap()
    expect(pos.is_document_start())
  }
  {
    let pos = node.text_position_from_global_utf16_index(17).unwrap()
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), "\u{a0}")
  }
  {
    let pos = node.text_position_from_global_utf16_index(18).unwrap()
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), "l")
  }
  {
    let pos = node.text_position_from_global_utf16_index(37).unwrap()
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), " ")
  }
  {
    let pos = node.text_position_from_global_utf16_index(38).unwrap()
    expect(!pos.is_paragraph_start())
    expect(pos.is_line_start())
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), "t")
  }
  {
    let pos = node.text_position_from_global_utf16_index(54).unwrap()
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), "\n")
  }
  {
    let pos = node.text_position_from_global_utf16_index(55).unwrap()
    expect(pos.is_paragraph_start())
    expect(pos.is_line_start())
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), "A")
  }
  for i in 94..<=97 {
    let pos = node.text_position_from_global_utf16_index(i).unwrap()
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), "\u{1f44d}\u{1f3fb}")
  }
  {
    let pos = node.text_position_from_global_utf16_index(98).unwrap()
    let range = pos.to_degenerate_range()
    range.set_end(pos.forward_to_character_end())
    @test.assert_eq(range.text(), "\n")
  }
  {
    let pos = node.text_position_from_global_utf16_index(99).unwrap()
    expect(pos.is_document_end())
  }
  expect(node.text_position_from_global_utf16_index(100) is None)
}

///|
test "text.multiline_selection_clamping" {
  let tree = main_multiline_tree(Some(multiline_past_end_selection()))
  let state = tree.state()
  let node = state.node_by_id(nid(@common.NodeId::from_u64(1UL))).unwrap()
  let _ = node.text_selection().unwrap()
}

///|
test "text.range_property_value_map" {
  @test.assert_eq(
    RangePropertyValue::Single(Some(0)).map(x => x + 1),
    RangePropertyValue::Single(Some(1)),
  )
  @test.assert_eq(
    RangePropertyValue::Single(None).map(x => x + 1),
    RangePropertyValue::Single(None),
  )
  @test.assert_eq(
    RangePropertyValue::Mixed.map(x => x + 1),
    RangePropertyValue::Mixed,
  )
}
