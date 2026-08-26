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
test "json encode: TreeUpdate shape" {
  let tree_id = @moon_accesskit.TreeId(Uuid::nil())
  let root = NodeId::from_u64(1UL)
  let update = @moon_accesskit.TreeUpdate(tree_id, root)
  update.set_tree(@moon_accesskit.Tree(root))
  let node = @moon_accesskit.Node(Role::Button)
  node.set_label("OK")
  update.push_node(root, node)
  let actual_str = update.to_json().stringify()
  assert_true(
    actual_str.contains("\"treeId\":\"00000000-0000-0000-0000-000000000000\""),
  )
  let actual_json = @json.parse(actual_str)
  let expected_json = @json.parse(
    (
      #|{
      #|  "nodes": [
      #|    [
      #|      1,
      #|      {
      #|        "role": "button",
      #|        "actions": 0,
      #|        "childActions": 0,
      #|        "flags": 0,
      #|        "properties": { "label": "OK" }
      #|      }
      #|    ]
      #|  ],
      #|  "tree": { "root": 1, "toolkitName": null, "toolkitVersion": null },
      #|  "treeId": "00000000-0000-0000-0000-000000000000",
      #|  "focus": 1
      #|}
    ),
  )
  @test.assert_eq(actual_json, expected_json)
}

///|
test "json encode: ActionRequest with ActionData" {
  let tree_id = @moon_accesskit.TreeId(Uuid::nil())
  let node_id = NodeId::from_u64(2UL)
  let request = @moon_accesskit.ActionRequest(
    Action::CustomAction,
    tree_id,
    node_id,
  )
  request.set_data(ActionData::CustomAction(42))
  let actual_json = @json.parse(request.to_json().stringify())
  let expected_json = @json.parse(
    (
      #|{
      #|  "action": "customAction",
      #|  "targetTree": "00000000-0000-0000-0000-000000000000",
      #|  "targetNode": 2,
      #|  "data": { "customAction": 42 }
      #|}
    ),
  )
  @test.assert_eq(actual_json, expected_json)
}

///|
test "json decode: TreeUpdate roundtrip" {
  let tree_id = @moon_accesskit.TreeId(Uuid::nil())
  let root = NodeId::from_u64(3UL)
  let update = @moon_accesskit.TreeUpdate(tree_id, root)
  update.set_tree(@moon_accesskit.Tree(root))
  let node = @moon_accesskit.Node(Role::Label)
  node.set_value("Hello")
  update.push_node(root, node)
  let json = update.to_json()
  let decoded : TreeUpdate = @json.from_json(json)
  @test.assert_eq(
    decoded.tree_id().debug(),
    "TreeId(00000000-0000-0000-0000-000000000000)",
  )
  @test.assert_eq(decoded.focus().to_u64(), 3UL)
  let nodes = decoded.nodes()
  @test.assert_eq(nodes.length(), 1)
  let first = nodes[0]
  @test.assert_eq(first.id().to_u64(), 3UL)
  @test.assert_eq(first.node().value(), Some("Hello"))
}
