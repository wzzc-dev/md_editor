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
test "children getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_true(node.children().is_empty())
}

///|
test "children setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_children([])
  assert_true(node.children().is_empty())
  let ids = [NodeId::from_u64(0UL), NodeId::from_u64(1UL)]
  node.set_children(ids)
  @test.assert_eq(node.children(), ids)
}

///|
test "children pusher should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.push_child(NodeId::from_u64(0UL))
  @test.assert_eq(node.children(), [NodeId::from_u64(0UL)])
  node.push_child(NodeId::from_u64(1UL))
  @test.assert_eq(node.children(), [
    NodeId::from_u64(0UL),
    NodeId::from_u64(1UL),
  ])
}

///|
test "children clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_children([NodeId::from_u64(0UL)])
  node.clear_children()
  assert_true(node.children().is_empty())
}

///|
test "controls getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_true(node.controls().is_empty())
}

///|
test "controls setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_controls([])
  assert_true(node.controls().is_empty())
  let ids = [NodeId::from_u64(0UL), NodeId::from_u64(1UL)]
  node.set_controls(ids)
  @test.assert_eq(node.controls(), ids)
}

///|
test "controls pusher should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.push_controlled(NodeId::from_u64(0UL))
  @test.assert_eq(node.controls(), [NodeId::from_u64(0UL)])
  node.push_controlled(NodeId::from_u64(1UL))
  @test.assert_eq(node.controls(), [
    NodeId::from_u64(0UL),
    NodeId::from_u64(1UL),
  ])
}

///|
test "controls clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_controls([NodeId::from_u64(0UL)])
  node.clear_controls()
  assert_true(node.controls().is_empty())
}

///|
test "details getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_true(node.details().is_empty())
}

///|
test "details setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_details([])
  assert_true(node.details().is_empty())
  let ids = [NodeId::from_u64(0UL), NodeId::from_u64(1UL)]
  node.set_details(ids)
  @test.assert_eq(node.details(), ids)
}

///|
test "details pusher should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.push_detail(NodeId::from_u64(0UL))
  @test.assert_eq(node.details(), [NodeId::from_u64(0UL)])
  node.push_detail(NodeId::from_u64(1UL))
  @test.assert_eq(node.details(), [NodeId::from_u64(0UL), NodeId::from_u64(1UL)])
}

///|
test "details clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_details([NodeId::from_u64(0UL)])
  node.clear_details()
  assert_true(node.details().is_empty())
}

///|
test "described_by getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_true(node.described_by().is_empty())
}

///|
test "described_by setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_described_by([])
  assert_true(node.described_by().is_empty())
  let ids = [NodeId::from_u64(0UL), NodeId::from_u64(1UL)]
  node.set_described_by(ids)
  @test.assert_eq(node.described_by(), ids)
}

///|
test "described_by pusher should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.push_described_by(NodeId::from_u64(0UL))
  @test.assert_eq(node.described_by(), [NodeId::from_u64(0UL)])
  node.push_described_by(NodeId::from_u64(1UL))
  @test.assert_eq(node.described_by(), [
    NodeId::from_u64(0UL),
    NodeId::from_u64(1UL),
  ])
}

///|
test "described_by clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_described_by([NodeId::from_u64(0UL)])
  node.clear_described_by()
  assert_true(node.described_by().is_empty())
}

///|
test "flow_to getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_true(node.flow_to().is_empty())
}

///|
test "flow_to setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_flow_to([])
  assert_true(node.flow_to().is_empty())
  let ids = [NodeId::from_u64(0UL), NodeId::from_u64(1UL)]
  node.set_flow_to(ids)
  @test.assert_eq(node.flow_to(), ids)
}

///|
test "flow_to pusher should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.push_flow_to(NodeId::from_u64(0UL))
  @test.assert_eq(node.flow_to(), [NodeId::from_u64(0UL)])
  node.push_flow_to(NodeId::from_u64(1UL))
  @test.assert_eq(node.flow_to(), [NodeId::from_u64(0UL), NodeId::from_u64(1UL)])
}

///|
test "flow_to clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_flow_to([NodeId::from_u64(0UL)])
  node.clear_flow_to()
  assert_true(node.flow_to().is_empty())
}

///|
test "labelled_by getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_true(node.labelled_by().is_empty())
}

///|
test "labelled_by setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_labelled_by([])
  assert_true(node.labelled_by().is_empty())
  let ids = [NodeId::from_u64(0UL), NodeId::from_u64(1UL)]
  node.set_labelled_by(ids)
  @test.assert_eq(node.labelled_by(), ids)
}

///|
test "labelled_by pusher should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.push_labelled_by(NodeId::from_u64(0UL))
  @test.assert_eq(node.labelled_by(), [NodeId::from_u64(0UL)])
  node.push_labelled_by(NodeId::from_u64(1UL))
  @test.assert_eq(node.labelled_by(), [
    NodeId::from_u64(0UL),
    NodeId::from_u64(1UL),
  ])
}

///|
test "labelled_by clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_labelled_by([NodeId::from_u64(0UL)])
  node.clear_labelled_by()
  assert_true(node.labelled_by().is_empty())
}

///|
test "owns getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_true(node.owns().is_empty())
}

///|
test "owns setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_owns([])
  assert_true(node.owns().is_empty())
  let ids = [NodeId::from_u64(0UL), NodeId::from_u64(1UL)]
  node.set_owns(ids)
  @test.assert_eq(node.owns(), ids)
}

///|
test "owns pusher should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.push_owned(NodeId::from_u64(0UL))
  @test.assert_eq(node.owns(), [NodeId::from_u64(0UL)])
  node.push_owned(NodeId::from_u64(1UL))
  @test.assert_eq(node.owns(), [NodeId::from_u64(0UL), NodeId::from_u64(1UL)])
}

///|
test "owns clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_owns([NodeId::from_u64(0UL)])
  node.clear_owns()
  assert_true(node.owns().is_empty())
}

///|
test "radio_group getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_true(node.radio_group().is_empty())
}

///|
test "radio_group setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_radio_group([])
  assert_true(node.radio_group().is_empty())
  let ids = [NodeId::from_u64(0UL), NodeId::from_u64(1UL)]
  node.set_radio_group(ids)
  @test.assert_eq(node.radio_group(), ids)
}

///|
test "radio_group pusher should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.push_to_radio_group(NodeId::from_u64(0UL))
  @test.assert_eq(node.radio_group(), [NodeId::from_u64(0UL)])
  node.push_to_radio_group(NodeId::from_u64(1UL))
  @test.assert_eq(node.radio_group(), [
    NodeId::from_u64(0UL),
    NodeId::from_u64(1UL),
  ])
}

///|
test "radio_group clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_radio_group([NodeId::from_u64(0UL)])
  node.clear_radio_group()
  assert_true(node.radio_group().is_empty())
}
