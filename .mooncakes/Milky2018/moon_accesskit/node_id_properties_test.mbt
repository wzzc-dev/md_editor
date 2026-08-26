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
test "active_descendant getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.active_descendant(), None)
}

///|
test "NodeId root should be zero" {
  @test.assert_eq(NodeId::root().to_u64(), 0UL)
}

///|
test "active_descendant setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_active_descendant(NodeId::from_u64(0UL))
  @test.assert_eq(node.active_descendant(), Some(NodeId::from_u64(0UL)))
}

///|
test "active_descendant clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_active_descendant(NodeId::from_u64(0UL))
  node.clear_active_descendant()
  @test.assert_eq(node.active_descendant(), None)
}

///|
test "error_message getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.error_message(), None)
}

///|
test "error_message setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_error_message(NodeId::from_u64(0UL))
  @test.assert_eq(node.error_message(), Some(NodeId::from_u64(0UL)))
}

///|
test "error_message clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_error_message(NodeId::from_u64(0UL))
  node.clear_error_message()
  @test.assert_eq(node.error_message(), None)
}

///|
test "in_page_link_target getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.in_page_link_target(), None)
}

///|
test "in_page_link_target setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_in_page_link_target(NodeId::from_u64(0UL))
  @test.assert_eq(node.in_page_link_target(), Some(NodeId::from_u64(0UL)))
}

///|
test "in_page_link_target clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_in_page_link_target(NodeId::from_u64(0UL))
  node.clear_in_page_link_target()
  @test.assert_eq(node.in_page_link_target(), None)
}

///|
test "member_of getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.member_of(), None)
}

///|
test "member_of setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_member_of(NodeId::from_u64(0UL))
  @test.assert_eq(node.member_of(), Some(NodeId::from_u64(0UL)))
}

///|
test "member_of clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_member_of(NodeId::from_u64(0UL))
  node.clear_member_of()
  @test.assert_eq(node.member_of(), None)
}

///|
test "next_on_line getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.next_on_line(), None)
}

///|
test "next_on_line setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_next_on_line(NodeId::from_u64(0UL))
  @test.assert_eq(node.next_on_line(), Some(NodeId::from_u64(0UL)))
}

///|
test "next_on_line clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_next_on_line(NodeId::from_u64(0UL))
  node.clear_next_on_line()
  @test.assert_eq(node.next_on_line(), None)
}

///|
test "previous_on_line getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.previous_on_line(), None)
}

///|
test "previous_on_line setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_previous_on_line(NodeId::from_u64(0UL))
  @test.assert_eq(node.previous_on_line(), Some(NodeId::from_u64(0UL)))
}

///|
test "previous_on_line clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_previous_on_line(NodeId::from_u64(0UL))
  node.clear_previous_on_line()
  @test.assert_eq(node.previous_on_line(), None)
}

///|
test "popup_for getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.popup_for(), None)
}

///|
test "popup_for setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_popup_for(NodeId::from_u64(0UL))
  @test.assert_eq(node.popup_for(), Some(NodeId::from_u64(0UL)))
}

///|
test "popup_for clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_popup_for(NodeId::from_u64(0UL))
  node.clear_popup_for()
  @test.assert_eq(node.popup_for(), None)
}
