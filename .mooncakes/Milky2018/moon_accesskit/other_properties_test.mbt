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
test "transform getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.transform(), None)
}

///|
test "transform setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  let value = Affine::Affine(1.0, 0.0, 0.0, 1.0, 0.0, 0.0)
  node.set_transform(value)
  @test.assert_eq(node.transform(), Some(value))
}

///|
test "transform clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_transform(Affine::Affine(1.0, 0.0, 0.0, 1.0, 0.0, 0.0))
  node.clear_transform()
  @test.assert_eq(node.transform(), None)
}

///|
test "bounds getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.bounds(), None)
}

///|
test "bounds setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  let value = Rect::Rect(0.0, 1.0, 2.0, 3.0)
  node.set_bounds(value)
  @test.assert_eq(node.bounds(), Some(value))
}

///|
test "bounds clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_bounds(Rect::Rect(0.0, 1.0, 2.0, 3.0))
  node.clear_bounds()
  @test.assert_eq(node.bounds(), None)
}

///|
test "text_selection getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.text_selection(), None)
}

///|
test "text_selection setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  let value = @moon_accesskit.TextSelection(
    @moon_accesskit.TextPosition(@moon_accesskit.NodeId(0UL), 0),
    @moon_accesskit.TextPosition(@moon_accesskit.NodeId(0UL), 2),
  )
  node.set_text_selection(value)
  @test.assert_eq(node.text_selection(), Some(value))
}

///|
test "text_selection clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_text_selection(
    @moon_accesskit.TextSelection(
      @moon_accesskit.TextPosition(@moon_accesskit.NodeId(0UL), 0),
      @moon_accesskit.TextPosition(@moon_accesskit.NodeId(0UL), 2),
    ),
  )
  node.clear_text_selection()
  @test.assert_eq(node.text_selection(), None)
}

///|
test "tree_id getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.tree_id(), None)
}

///|
test "tree_id setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  let value = @moon_accesskit.TreeId(Uuid::nil())
  node.set_tree_id(value)
  @test.assert_eq(node.tree_id(), Some(value))
}

///|
test "tree_id clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_tree_id(@moon_accesskit.TreeId(Uuid::nil()))
  node.clear_tree_id()
  @test.assert_eq(node.tree_id(), None)
}

///|
test "custom_actions getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.custom_actions(), [])
}

///|
test "custom_actions setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  let value = [
    @moon_accesskit.CustomAction::CustomAction(0, "first test action"),
    @moon_accesskit.CustomAction::CustomAction(1, "second test action"),
  ]
  node.set_custom_actions(value)
  @test.assert_eq(node.custom_actions(), value)
}

///|
test "custom_actions pusher should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  let first_action = @moon_accesskit.CustomAction::CustomAction(
    0, "first test action",
  )
  let second_action = @moon_accesskit.CustomAction::CustomAction(
    1, "second test action",
  )
  node.push_custom_action(first_action)
  @test.assert_eq(node.custom_actions(), [first_action])
  node.push_custom_action(second_action)
  @test.assert_eq(node.custom_actions(), [first_action, second_action])
}

///|
test "custom_actions clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_custom_actions([@moon_accesskit.CustomAction(0, "test action")])
  node.clear_custom_actions()
  @test.assert_eq(node.custom_actions(), [])
}
