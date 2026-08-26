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
pub(all) struct Tree {
  root : NodeId
  toolkit_name : String?
  toolkit_version : String?
} derive(Eq, Debug)

///|
pub fn Tree::Tree(root : NodeId) -> Tree {
  { root, toolkit_name: None, toolkit_version: None }
}

///|
pub fn Tree::root_id(self : Tree) -> NodeId {
  self.root
}

///|
pub fn Tree::toolkit_name(self : Tree) -> String? {
  self.toolkit_name
}

///|
pub fn Tree::toolkit_version(self : Tree) -> String? {
  self.toolkit_version
}

///|
pub(all) struct NodeUpdate {
  priv id : NodeId
  priv node : Node
}

///|
pub fn NodeUpdate::NodeUpdate(id : NodeId, node : Node) -> NodeUpdate {
  { id, node }
}

///|
pub fn NodeUpdate::id(self : NodeUpdate) -> NodeId {
  self.id
}

///|
pub fn NodeUpdate::node(self : NodeUpdate) -> Node {
  self.node
}

///|
pub(all) struct TreeUpdate {
  priv nodes : Array[NodeUpdate]
  priv mut tree : Tree?
  priv tree_id : TreeId
  priv focus : NodeId
}

///|
pub fn TreeUpdate::TreeUpdate(tree_id : TreeId, focus : NodeId) -> TreeUpdate {
  { nodes: [], tree: None, tree_id, focus }
}

///|
pub fn TreeUpdate::nodes(self : TreeUpdate) -> Array[NodeUpdate] {
  self.nodes
}

///|
pub fn TreeUpdate::tree(self : TreeUpdate) -> Tree? {
  self.tree
}

///|
pub fn TreeUpdate::tree_id(self : TreeUpdate) -> TreeId {
  self.tree_id
}

///|
pub fn TreeUpdate::focus(self : TreeUpdate) -> NodeId {
  self.focus
}

///|
pub fn TreeUpdate::push_node(
  self : TreeUpdate,
  id : NodeId,
  node : Node,
) -> Unit {
  self.nodes.push(NodeUpdate::NodeUpdate(id, node))
}

///|
pub fn TreeUpdate::set_tree(self : TreeUpdate, tree : Tree) -> Unit {
  self.tree = Some(tree)
}

///|
pub(all) enum ActionData {
  CustomAction(Int)
  Value(String)
  NumericValue(Double)
  ScrollUnit(ScrollUnit)
  ScrollHint(ScrollHint)
  ScrollToPoint(Point)
  SetScrollOffset(Point)
  SetTextSelection(TextSelection)
} derive(Eq, Debug)

///|
pub impl Show for Tree with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub impl Show for ActionData with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub(all) struct ActionRequest {
  priv action : Action
  priv target_tree : TreeId
  priv target_node : NodeId
  priv mut data : ActionData?
}

///|
pub fn ActionRequest::ActionRequest(
  action : Action,
  target_tree : TreeId,
  target_node : NodeId,
) -> ActionRequest {
  { action, target_tree, target_node, data: None }
}

///|
pub fn ActionRequest::action(self : ActionRequest) -> Action {
  self.action
}

///|
pub fn ActionRequest::target_tree(self : ActionRequest) -> TreeId {
  self.target_tree
}

///|
pub fn ActionRequest::target_node(self : ActionRequest) -> NodeId {
  self.target_node
}

///|
pub fn ActionRequest::data(self : ActionRequest) -> ActionData? {
  self.data
}

///|
pub fn ActionRequest::set_data(self : ActionRequest, data : ActionData) -> Unit {
  self.data = Some(data)
}

///|
pub(open) trait ActivationHandler {
  request_initial_tree(Self) -> TreeUpdate?
}

///|
pub(open) trait ActionHandler {
  do_action(Self, ActionRequest) -> Unit
}

///|
pub(open) trait DeactivationHandler {
  deactivate_accessibility(Self) -> Unit
}

///|
pub impl ToJson for Tree with to_json(self : Tree) -> Json {
  Json::object({
    "root": self.root.to_json(),
    "toolkitName": match self.toolkit_name {
      Some(v) => Json::string(v)
      None => Json::null()
    },
    "toolkitVersion": match self.toolkit_version {
      Some(v) => Json::string(v)
      None => Json::null()
    },
  })
}

///|
pub impl @json.FromJson for Tree with from_json(json, path) {
  guard json is Object(obj) else {
    json_decode_error(path, "Tree::from_json: expected object")
  }
  for key, _ in obj {
    if key != "root" && key != "toolkitName" && key != "toolkitVersion" {
      json_decode_error(path, "Tree::from_json: unknown field \{key}")
    }
  }
  guard obj.get("root") is Some(root_json) else {
    json_decode_error(path, "Tree::from_json: missing field root")
  }
  guard obj.get("toolkitName") is Some(name_json) else {
    json_decode_error(path, "Tree::from_json: missing field toolkitName")
  }
  guard obj.get("toolkitVersion") is Some(ver_json) else {
    json_decode_error(path, "Tree::from_json: missing field toolkitVersion")
  }
  let root : NodeId = @json.FromJson::from_json(root_json, path.add_key("root"))
  let toolkit_name : String? = match name_json {
    Null => None
    String(s) => Some(s)
    _ =>
      json_decode_error(
        path.add_key("toolkitName"),
        "Tree::from_json: expected string or null",
      )
  }
  let toolkit_version : String? = match ver_json {
    Null => None
    String(s) => Some(s)
    _ =>
      json_decode_error(
        path.add_key("toolkitVersion"),
        "Tree::from_json: expected string or null",
      )
  }
  { root, toolkit_name, toolkit_version }
}

///|
pub impl ToJson for NodeUpdate with to_json(self : NodeUpdate) -> Json {
  Json::array([self.id.to_json(), self.node.to_json()])
}

///|
pub impl @json.FromJson for NodeUpdate with from_json(json, path) {
  guard json is Array(arr) else {
    json_decode_error(path, "NodeUpdate::from_json: expected array")
  }
  if arr.length() != 2 {
    json_decode_error(path, "NodeUpdate::from_json: expected 2 elements")
  }
  let id : NodeId = @json.FromJson::from_json(arr[0], path.add_index(0))
  let node : Node = @json.FromJson::from_json(arr[1], path.add_index(1))
  NodeUpdate::NodeUpdate(id, node)
}

///|
pub impl ToJson for TreeUpdate with to_json(self : TreeUpdate) -> Json {
  let nodes : Array[Json] = []
  for node in self.nodes {
    nodes.push(node.to_json())
  }
  Json::object({
    "nodes": Json::array(nodes),
    "tree": match self.tree {
      Some(t) => t.to_json()
      None => Json::null()
    },
    "treeId": self.tree_id.to_json(),
    "focus": self.focus.to_json(),
  })
}

///|
pub impl @json.FromJson for TreeUpdate with from_json(json, path) {
  guard json is Object(obj) else {
    json_decode_error(path, "TreeUpdate::from_json: expected object")
  }
  for key, _ in obj {
    if key != "nodes" && key != "tree" && key != "treeId" && key != "focus" {
      json_decode_error(path, "TreeUpdate::from_json: unknown field \{key}")
    }
  }
  guard obj.get("nodes") is Some(nodes_json) else {
    json_decode_error(path, "TreeUpdate::from_json: missing field nodes")
  }
  guard obj.get("tree") is Some(tree_json) else {
    json_decode_error(path, "TreeUpdate::from_json: missing field tree")
  }
  guard obj.get("treeId") is Some(tree_id_json) else {
    json_decode_error(path, "TreeUpdate::from_json: missing field treeId")
  }
  guard obj.get("focus") is Some(focus_json) else {
    json_decode_error(path, "TreeUpdate::from_json: missing field focus")
  }
  let nodes : Array[NodeUpdate] = @json.FromJson::from_json(
    nodes_json,
    path.add_key("nodes"),
  )
  let tree : Tree? = match tree_json {
    Null => None
    _ => Some(@json.FromJson::from_json(tree_json, path.add_key("tree")))
  }
  let tree_id : TreeId = @json.FromJson::from_json(
    tree_id_json,
    path.add_key("treeId"),
  )
  let focus : NodeId = @json.FromJson::from_json(
    focus_json,
    path.add_key("focus"),
  )
  let update = TreeUpdate::TreeUpdate(tree_id, focus)
  update.tree = tree
  for node in nodes {
    update.nodes.push(node)
  }
  update
}

///|
pub impl ToJson for ActionData with to_json(self : ActionData) -> Json {
  match self {
    ActionData::CustomAction(id) =>
      Json::object({ "customAction": id.to_json() })
    ActionData::Value(v) => Json::object({ "value": Json::string(v) })
    ActionData::NumericValue(v) => Json::object({ "numericValue": v.to_json() })
    ActionData::ScrollUnit(v) => Json::object({ "scrollUnit": v.to_json() })
    ActionData::ScrollHint(v) => Json::object({ "scrollHint": v.to_json() })
    ActionData::ScrollToPoint(v) =>
      Json::object({ "scrollToPoint": v.to_json() })
    ActionData::SetScrollOffset(v) =>
      Json::object({ "setScrollOffset": v.to_json() })
    ActionData::SetTextSelection(v) =>
      Json::object({ "setTextSelection": v.to_json() })
  }
}

///|
pub impl @json.FromJson for ActionData with from_json(json, path) {
  guard json is Object(obj) else {
    json_decode_error(path, "ActionData::from_json: expected object")
  }
  let mut found_key : String? = None
  let mut found_value : Json? = None
  for key, value in obj {
    if found_key is Some(_) {
      json_decode_error(
        path, "ActionData::from_json: expected single-key object",
      )
    }
    found_key = Some(key)
    found_value = Some(value)
  }
  guard found_key is Some(key) && found_value is Some(value) else {
    json_decode_error(path, "ActionData::from_json: expected single-key object")
  }
  let value_path = path.add_key(key)
  match key {
    "customAction" =>
      ActionData::CustomAction(@json.FromJson::from_json(value, value_path))
    "value" => ActionData::Value(@json.FromJson::from_json(value, value_path))
    "numericValue" =>
      ActionData::NumericValue(@json.FromJson::from_json(value, value_path))
    "scrollUnit" =>
      ActionData::ScrollUnit(@json.FromJson::from_json(value, value_path))
    "scrollHint" =>
      ActionData::ScrollHint(@json.FromJson::from_json(value, value_path))
    "scrollToPoint" =>
      ActionData::ScrollToPoint(@json.FromJson::from_json(value, value_path))
    "setScrollOffset" =>
      ActionData::SetScrollOffset(@json.FromJson::from_json(value, value_path))
    "setTextSelection" =>
      ActionData::SetTextSelection(@json.FromJson::from_json(value, value_path))
    _ => json_decode_error(path, "ActionData::from_json: unknown variant")
  }
}

///|
pub impl ToJson for ActionRequest with to_json(self : ActionRequest) -> Json {
  Json::object({
    "action": self.action.to_json(),
    "targetTree": self.target_tree.to_json(),
    "targetNode": self.target_node.to_json(),
    "data": match self.data {
      Some(v) => v.to_json()
      None => Json::null()
    },
  })
}

///|
pub impl @json.FromJson for ActionRequest with from_json(json, path) {
  guard json is Object(obj) else {
    json_decode_error(path, "ActionRequest::from_json: expected object")
  }
  for key, _ in obj {
    if key != "action" &&
      key != "targetTree" &&
      key != "targetNode" &&
      key != "data" {
      json_decode_error(path, "ActionRequest::from_json: unknown field \{key}")
    }
  }
  guard obj.get("action") is Some(action_json) else {
    json_decode_error(path, "ActionRequest::from_json: missing field action")
  }
  guard obj.get("targetTree") is Some(tree_json) else {
    json_decode_error(
      path, "ActionRequest::from_json: missing field targetTree",
    )
  }
  guard obj.get("targetNode") is Some(node_json) else {
    json_decode_error(
      path, "ActionRequest::from_json: missing field targetNode",
    )
  }
  guard obj.get("data") is Some(data_json) else {
    json_decode_error(path, "ActionRequest::from_json: missing field data")
  }
  let action : Action = @json.FromJson::from_json(
    action_json,
    path.add_key("action"),
  )
  let target_tree : TreeId = @json.FromJson::from_json(
    tree_json,
    path.add_key("targetTree"),
  )
  let target_node : NodeId = @json.FromJson::from_json(
    node_json,
    path.add_key("targetNode"),
  )
  let data : ActionData? = match data_json {
    Null => None
    _ => Some(@json.FromJson::from_json(data_json, path.add_key("data")))
  }
  let request = ActionRequest::ActionRequest(action, target_tree, target_node)
  if data is Some(value) {
    request.data = Some(value)
  }
  request
}
