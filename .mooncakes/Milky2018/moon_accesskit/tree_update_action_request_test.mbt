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
test "TreeUpdate new should default to empty nodes and no tree" {
  let update = @moon_accesskit.TreeUpdate(
    TreeId::root(),
    @moon_accesskit.NodeId(1UL),
  )
  @test.assert_eq(update.nodes().length(), 0)
  @test.assert_eq(update.tree(), None)
  @test.assert_eq(update.tree_id(), TreeId::root())
  @test.assert_eq(update.focus(), @moon_accesskit.NodeId(1UL))
}

///|
test "TreeUpdate push_node should append node updates" {
  let update = @moon_accesskit.TreeUpdate(
    TreeId::root(),
    @moon_accesskit.NodeId(1UL),
  )
  update.push_node(
    @moon_accesskit.NodeId(10UL),
    @moon_accesskit.Node(Role::Button),
  )
  update.push_node(
    @moon_accesskit.NodeId(11UL),
    @moon_accesskit.Node(Role::CheckBox),
  )
  @test.assert_eq(update.nodes().length(), 2)
  @test.assert_eq(update.nodes()[0].id(), @moon_accesskit.NodeId(10UL))
  @test.assert_eq(update.nodes()[1].id(), @moon_accesskit.NodeId(11UL))
}

///|
test "TreeUpdate set_tree should update tree data" {
  let update = @moon_accesskit.TreeUpdate(
    TreeId::root(),
    @moon_accesskit.NodeId(1UL),
  )
  update.set_tree(@moon_accesskit.Tree(@moon_accesskit.NodeId(1UL)))
  @test.assert_eq(
    update.tree().map(fn(t : Tree) { t.root_id() }),
    Some(@moon_accesskit.NodeId(1UL)),
  )
}

///|
test "ActionRequest new should default to no data" {
  let request = @moon_accesskit.ActionRequest(
    Action::Click,
    TreeId::root(),
    @moon_accesskit.NodeId(2UL),
  )
  @test.assert_eq(request.action(), Action::Click)
  @test.assert_eq(request.target_tree(), TreeId::root())
  @test.assert_eq(request.target_node(), @moon_accesskit.NodeId(2UL))
  @test.assert_eq(request.data(), None)
}

///|
test "ActionRequest set_data should update request data" {
  let request = @moon_accesskit.ActionRequest(
    Action::ScrollDown,
    TreeId::root(),
    @moon_accesskit.NodeId(2UL),
  )
  request.set_data(ActionData::ScrollUnit(ScrollUnit::Item))
  @test.assert_eq(
    request.data(),
    Some(ActionData::ScrollUnit(ScrollUnit::Item)),
  )
}
