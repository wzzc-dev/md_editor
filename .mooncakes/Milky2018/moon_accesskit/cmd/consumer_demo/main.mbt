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
struct NoOpHandler {}

///|
impl @consumer.ChangeHandler for NoOpHandler with node_added(_, _) {
  ()
}

///|
impl @consumer.ChangeHandler for NoOpHandler with node_updated(_, _, _) {
  ()
}

///|
impl @consumer.ChangeHandler for NoOpHandler with focus_moved(_, _, _) {
  ()
}

///|
impl @consumer.ChangeHandler for NoOpHandler with node_removed(_, _) {
  ()
}

///|
fn main {
  let subtree_id = @lib.TreeId({ high: 0UL, low: 1UL })
  let update = @lib.TreeUpdate(@lib.TreeId::root(), @lib.NodeId(0UL))
  let root = @lib.Node(@lib.Role::Window)
  root.set_children([@lib.NodeId(1UL)])
  update.push_node(@lib.NodeId(0UL), root)
  let graft = @lib.Node(@lib.Role::GenericContainer)
  graft.set_tree_id(subtree_id)
  update.push_node(@lib.NodeId(1UL), graft)
  update.set_tree(@lib.Tree(@lib.NodeId(0UL)))
  let tree = @consumer.Tree(update, false)
  let subtree_update = @lib.TreeUpdate(subtree_id, @lib.NodeId(0UL))
  let document = @lib.Node(@lib.Role::Document)
  document.set_children([@lib.NodeId(1UL)])
  let button = @lib.Node(@lib.Role::Button)
  button.set_label("OK")
  subtree_update.push_node(@lib.NodeId(0UL), document)
  subtree_update.push_node(@lib.NodeId(1UL), button)
  subtree_update.set_tree(@lib.Tree(@lib.NodeId(0UL)))
  tree.update_and_process_changes(subtree_update, NoOpHandler::{  })
  let root_node = tree.state().root()
  let filtered_children = root_node.filtered_children(@consumer.common_filter)
  println("root.filtered_children(common_filter):")
  for node in filtered_children {
    println("- " + node.role().to_string())
  }
  if filtered_children.length() > 0 {
    let document_node = filtered_children[0]
    let doc_children = document_node.filtered_children(@consumer.common_filter)
    println("document.filtered_children(common_filter):")
    for node in doc_children {
      println(
        "- " +
        node.role().to_string() +
        " label=" +
        node.label().unwrap_or("<none>"),
      )
    }
  }
}
