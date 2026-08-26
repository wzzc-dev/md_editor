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
test "u64 should be convertible to node id" {
  @test.assert_eq(NodeId::from_u64(0UL), @moon_accesskit.NodeId(0UL))
  @test.assert_eq(NodeId::from_u64(1UL), @moon_accesskit.NodeId(1UL))
}

///|
test "node id should be convertible to u64" {
  @test.assert_eq(NodeId::from_u64(0UL).to_u64(), 0UL)
  @test.assert_eq(NodeId::from_u64(1UL).to_u64(), 1UL)
}

///|
test "node id should have debug repr" {
  @test.assert_eq(NodeId::from_u64(0UL).debug(), "#0")
  @test.assert_eq(NodeId::from_u64(1UL).debug(), "#1")
}

///|
test "action n should return the corresponding variant" {
  @test.assert_eq(Action::n(0), Some(Action::Click))
  @test.assert_eq(Action::n(1), Some(Action::Focus))
  @test.assert_eq(Action::n(2), Some(Action::Blur))
  @test.assert_eq(Action::n(3), Some(Action::Collapse))
  @test.assert_eq(Action::n(4), Some(Action::Expand))
  @test.assert_eq(Action::n(5), Some(Action::CustomAction))
  @test.assert_eq(Action::n(6), Some(Action::Decrement))
  @test.assert_eq(Action::n(7), Some(Action::Increment))
  @test.assert_eq(Action::n(8), Some(Action::HideTooltip))
  @test.assert_eq(Action::n(9), Some(Action::ShowTooltip))
  @test.assert_eq(Action::n(10), Some(Action::ReplaceSelectedText))
  @test.assert_eq(Action::n(11), Some(Action::ScrollDown))
  @test.assert_eq(Action::n(12), Some(Action::ScrollLeft))
  @test.assert_eq(Action::n(13), Some(Action::ScrollRight))
  @test.assert_eq(Action::n(14), Some(Action::ScrollUp))
  @test.assert_eq(Action::n(15), Some(Action::ScrollIntoView))
  @test.assert_eq(Action::n(16), Some(Action::ScrollToPoint))
  @test.assert_eq(Action::n(17), Some(Action::SetScrollOffset))
  @test.assert_eq(Action::n(18), Some(Action::SetTextSelection))
  @test.assert_eq(
    Action::n(19),
    Some(Action::SetSequentialFocusNavigationStartingPoint),
  )
  @test.assert_eq(Action::n(20), Some(Action::SetValue))
  @test.assert_eq(Action::n(21), Some(Action::ShowContextMenu))
  @test.assert_eq(Action::n(22), None)
}

///|
test "empty action mask should be converted to empty vec" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(action_mask_to_action_vec(node.actions_mask()), [])
}

///|
test "action mask should be convertible to vec" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.add_action(Action::Click)
  @test.assert_eq(action_mask_to_action_vec(node.actions_mask()), [
    Action::Click,
  ])
  let node = @moon_accesskit.Node(Role::Unknown)
  node.add_action(Action::ShowContextMenu)
  @test.assert_eq(action_mask_to_action_vec(node.actions_mask()), [
    Action::ShowContextMenu,
  ])
  let node = @moon_accesskit.Node(Role::Unknown)
  node.add_action(Action::Click)
  node.add_action(Action::ShowContextMenu)
  @test.assert_eq(action_mask_to_action_vec(node.actions_mask()), [
    Action::Click,
    Action::ShowContextMenu,
  ])
  let node = @moon_accesskit.Node(Role::Unknown)
  node.add_action(Action::Focus)
  node.add_action(Action::Blur)
  node.add_action(Action::Collapse)
  @test.assert_eq(action_mask_to_action_vec(node.actions_mask()), [
    Action::Focus,
    Action::Blur,
    Action::Collapse,
  ])
}

///|
test "new node should have user provided role" {
  let node = @moon_accesskit.Node(Role::Button)
  @test.assert_eq(node.role(), Role::Button)
}

///|
test "node role setter should update the role" {
  let node = @moon_accesskit.Node(Role::Button)
  node.set_role(Role::CheckBox)
  @test.assert_eq(node.role(), Role::CheckBox)
}

///|
test "new node should not support any action" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.supports_action(Action::Click))
  assert_false(node.supports_action(Action::Focus))
  assert_false(node.supports_action(Action::Blur))
  assert_false(node.supports_action(Action::Collapse))
  assert_false(node.supports_action(Action::Expand))
  assert_false(node.supports_action(Action::CustomAction))
  assert_false(node.supports_action(Action::Decrement))
  assert_false(node.supports_action(Action::Increment))
  assert_false(node.supports_action(Action::HideTooltip))
  assert_false(node.supports_action(Action::ShowTooltip))
  assert_false(node.supports_action(Action::ReplaceSelectedText))
  assert_false(node.supports_action(Action::ScrollDown))
  assert_false(node.supports_action(Action::ScrollLeft))
  assert_false(node.supports_action(Action::ScrollRight))
  assert_false(node.supports_action(Action::ScrollUp))
  assert_false(node.supports_action(Action::ScrollIntoView))
  assert_false(node.supports_action(Action::ScrollToPoint))
  assert_false(node.supports_action(Action::SetScrollOffset))
  assert_false(node.supports_action(Action::SetTextSelection))
  assert_false(
    node.supports_action(Action::SetSequentialFocusNavigationStartingPoint),
  )
  assert_false(node.supports_action(Action::SetValue))
  assert_false(node.supports_action(Action::ShowContextMenu))
  assert_false(node.child_supports_action(Action::Click))
  assert_false(node.child_supports_action(Action::Focus))
  assert_false(node.child_supports_action(Action::Blur))
  assert_false(node.child_supports_action(Action::Collapse))
  assert_false(node.child_supports_action(Action::Expand))
  assert_false(node.child_supports_action(Action::CustomAction))
  assert_false(node.child_supports_action(Action::Decrement))
  assert_false(node.child_supports_action(Action::Increment))
  assert_false(node.child_supports_action(Action::HideTooltip))
  assert_false(node.child_supports_action(Action::ShowTooltip))
  assert_false(node.child_supports_action(Action::ReplaceSelectedText))
  assert_false(node.child_supports_action(Action::ScrollDown))
  assert_false(node.child_supports_action(Action::ScrollLeft))
  assert_false(node.child_supports_action(Action::ScrollRight))
  assert_false(node.child_supports_action(Action::ScrollUp))
  assert_false(node.child_supports_action(Action::ScrollIntoView))
  assert_false(node.child_supports_action(Action::ScrollToPoint))
  assert_false(node.child_supports_action(Action::SetScrollOffset))
  assert_false(node.child_supports_action(Action::SetTextSelection))
  assert_false(
    node.child_supports_action(
      Action::SetSequentialFocusNavigationStartingPoint,
    ),
  )
  assert_false(node.child_supports_action(Action::SetValue))
  assert_false(node.child_supports_action(Action::ShowContextMenu))
}

///|
test "node add action should add the action" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.add_action(Action::Focus)
  assert_true(node.supports_action(Action::Focus))
  node.add_action(Action::Blur)
  assert_true(node.supports_action(Action::Blur))
}

///|
test "node add child action should add the action" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.add_child_action(Action::Focus)
  assert_true(node.child_supports_action(Action::Focus))
  node.add_child_action(Action::Blur)
  assert_true(node.child_supports_action(Action::Blur))
}

///|
test "node add action should do nothing if the action is already supported" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.add_action(Action::Focus)
  node.add_action(Action::Focus)
  assert_true(node.supports_action(Action::Focus))
}

///|
test "node add child action should do nothing if the action is already supported" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.add_child_action(Action::Focus)
  node.add_child_action(Action::Focus)
  assert_true(node.child_supports_action(Action::Focus))
}

///|
test "node remove action should remove the action" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.add_action(Action::Blur)
  node.remove_action(Action::Blur)
  assert_false(node.supports_action(Action::Blur))
}

///|
test "node remove child action should remove the action" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.add_child_action(Action::Blur)
  node.remove_child_action(Action::Blur)
  assert_false(node.child_supports_action(Action::Blur))
}

///|
test "node clear actions should remove all actions" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.add_action(Action::Focus)
  node.add_action(Action::Blur)
  node.clear_actions()
  assert_false(node.supports_action(Action::Focus))
  assert_false(node.supports_action(Action::Blur))
}

///|
test "node clear child actions should remove all actions" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.add_child_action(Action::Focus)
  node.add_child_action(Action::Blur)
  node.clear_child_actions()
  assert_false(node.child_supports_action(Action::Focus))
  assert_false(node.child_supports_action(Action::Blur))
}

///|
test "node should have debug repr" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.add_action(Action::Click)
  node.add_action(Action::Focus)
  node.add_child_action(Action::ScrollIntoView)
  node.set_hidden()
  node.set_multiselectable()
  node.set_children([NodeId::from_u64(0UL), NodeId::from_u64(1UL)])
  node.set_active_descendant(NodeId::from_u64(2UL))
  node.push_custom_action({ id: 0, description: "test action" })
  @test.assert_eq(
    node.debug(),
    "Node { role: Unknown, actions: [Click, Focus], child_actions: [ScrollIntoView], is_hidden: true, is_multiselectable: true, children: [#0, #1], active_descendant: #2, custom_actions: [CustomAction { id: 0, description: \"test action\" }] }",
  )
}

///|
test "new tree should have root id" {
  let tree = @moon_accesskit.Tree::Tree(NodeId::from_u64(1UL))
  @test.assert_eq(tree.root_id(), NodeId::from_u64(1UL))
  @test.assert_eq(tree.toolkit_name(), None)
  @test.assert_eq(tree.toolkit_version(), None)
}
