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
pub struct TreeIndex(Int) derive(Eq, Debug, Hash)

///|
pub impl Show for TreeIndex with output(self, logger) {
  show_via_debug(self, logger)
}

///|
priv struct TreeIndexMap {
  id_to_index : Map[@common.TreeId, TreeIndex]
  index_to_id : Map[TreeIndex, @common.TreeId]
  mut next : Int
}

///|
fn TreeIndexMap::TreeIndexMap() -> TreeIndexMap {
  { id_to_index: Map([]), index_to_id: Map([]), next: 0 }
}

///|
fn TreeIndexMap::get_index(
  self : TreeIndexMap,
  id : @common.TreeId,
) -> TreeIndex {
  match self.id_to_index.get(id) {
    Some(index) => index
    None => {
      let index = TreeIndex(self.next)
      self.next = self.next + 1
      self.id_to_index[id] = index
      self.index_to_id[index] = id
      index
    }
  }
}

///|
fn TreeIndexMap::get_id(
  self : TreeIndexMap,
  index : TreeIndex,
) -> @common.TreeId? {
  self.index_to_id.get(index)
}

///|
pub(all) struct SubtreeState {
  root : NodeId
  focus : NodeId
} derive(Debug)

///|
pub impl Show for SubtreeState with output(self, logger) {
  show_via_debug(self, logger)
}

///|
pub struct State {
  priv mut nodes : Map[NodeId, NodeState]
  priv mut data : @common.Tree
  priv mut root : NodeId
  priv mut focus : NodeId
  priv mut is_host_focused : Bool
  priv mut subtrees : Map[@common.TreeId, SubtreeState]
  priv mut graft_parents : Map[@common.TreeId, NodeId]
}

///|
fn State::clone_state(self : State) -> State {
  {
    nodes: self.nodes.copy(),
    data: self.data,
    root: self.root,
    focus: self.focus,
    is_host_focused: self.is_host_focused,
    subtrees: self.subtrees.copy(),
    graft_parents: self.graft_parents.copy(),
  }
}

///|
pub fn State::root_id(self : State) -> NodeId {
  self.root
}

///|
pub fn State::root(self : State) -> Node {
  self.node_by_id(self.root).unwrap()
}

///|
pub fn State::has_node(self : State, node_id : NodeId) -> Bool {
  self.nodes.contains(node_id)
}

///|
pub fn State::node_by_id(self : State, node_id : NodeId) -> Node? {
  if self.nodes.contains(node_id) {
    Some(Node::{ tree_state: self, id: node_id })
  } else {
    None
  }
}

///|
pub fn State::subtree_root(self : State, tree_id : @common.TreeId) -> NodeId? {
  self.subtrees.get(tree_id).map(s => s.root)
}

///|
pub fn State::subtree_state(
  self : State,
  tree_id : @common.TreeId,
) -> SubtreeState? {
  self.subtrees.get(tree_id)
}

///|
pub fn State::graft_parent(self : State, tree_id : @common.TreeId) -> NodeId? {
  self.graft_parents.get(tree_id)
}

///|
pub fn State::is_host_focused(self : State) -> Bool {
  self.is_host_focused
}

///|
pub fn State::focus_id_in_tree(self : State) -> NodeId {
  self.focus
}

///|
pub fn State::focus_in_tree(self : State) -> Node {
  self.node_by_id(self.focus_id_in_tree()).unwrap()
}

///|
pub fn State::focus_id(self : State) -> NodeId? {
  if self.is_host_focused {
    Some(self.focus)
  } else {
    None
  }
}

///|
pub fn State::focus(self : State) -> Node? {
  self
  .focus_id()
  .map(id => {
    let focused = self.node_by_id(id).unwrap()
    match focused.active_descendant() {
      Some(desc) => desc
      None => focused
    }
  })
}

///|
fn find_active_dialog(node : Node?) -> Node? {
  match node {
    None => None
    Some(candidate) =>
      if candidate.is_dialog() {
        Some(candidate)
      } else {
        find_active_dialog(candidate.parent())
      }
  }
}

///|
pub fn State::active_dialog(self : State) -> Node? {
  find_active_dialog(self.focus())
}

///|
pub fn State::toolkit_name(self : State) -> String? {
  self.data.toolkit_name()
}

///|
pub fn State::toolkit_version(self : State) -> String? {
  self.data.toolkit_version()
}

///|
pub(open) trait ChangeHandler {
  node_added(self : Self, node : Node) -> Unit
  node_updated(self : Self, old_node : Node, new_node : Node) -> Unit
  focus_moved(self : Self, old_focus : Node?, new_focus : Node?) -> Unit
  node_removed(self : Self, node : Node) -> Unit
}

///|
pub(all) struct Tree {
  priv mut state : State
  priv mut next_state : State
  priv tree_index_map : TreeIndexMap
}

///|
pub fn Tree::Tree(
  initial_update : @common.TreeUpdate,
  is_host_focused : Bool,
) -> Tree {
  let tree_data = match initial_update.tree() {
    Some(tree) => tree
    None =>
      abort(
        "Tried to initialize the accessibility tree without a root tree. TreeUpdate::tree must be Some.",
      )
  }
  if initial_update.tree_id() != @common.TreeId::root() {
    abort(
      "Cannot initialize with a subtree. TreeUpdate::tree_id must be TreeId::ROOT.",
    )
  }
  let tree_index_map = TreeIndexMap::TreeIndexMap()
  let tree_index = tree_index_map.get_index(initial_update.tree_id())
  let root = NodeId(tree_index, tree_data.root_id())
  let focus = NodeId(tree_index, initial_update.focus())
  let state : State = {
    nodes: Map([]),
    data: tree_data,
    root,
    focus,
    is_host_focused,
    subtrees: Map([]),
    graft_parents: Map([]),
  }
  state.update(initial_update, is_host_focused, None, tree_index)
  { state, next_state: state.clone_state(), tree_index_map }
}

///|
pub fn Tree::state(self : Tree) -> State {
  self.state
}

///|
pub fn Tree::locate_node(
  self : Tree,
  node_id : NodeId,
) -> (@common.NodeId, @common.TreeId)? {
  if !self.state.has_node(node_id) {
    return None
  }
  let (local_id, tree_index) = node_id.to_components()
  self.tree_index_map.get_id(tree_index).map(tree_id => (local_id, tree_id))
}

///|
priv struct InternalChanges {
  added_node_ids : Map[NodeId, Unit]
  updated_node_ids : Map[NodeId, Unit]
  removed_node_ids : Map[NodeId, Unit]
}

///|
fn InternalChanges::InternalChanges() -> InternalChanges {
  {
    added_node_ids: Map([]),
    updated_node_ids: Map([]),
    removed_node_ids: Map([]),
  }
}

///|
fn[K : Hash + Eq] map_set_insert(set : Map[K, Unit], key : K) -> Bool {
  if set.contains(key) {
    false
  } else {
    set[key] = ()
    true
  }
}

///|
fn[K : Hash + Eq] map_set_remove(set : Map[K, Unit], key : K) -> Unit {
  if set.contains(key) {
    set.remove(key)
  }
}

///|
fn State::validate_global(self : State) -> Unit {
  if !self.nodes.contains(self.root) {
    abort("Root ID is not in the node list")
  }
  if !self.nodes.contains(self.focus) {
    abort("Focused ID is not in the node list")
  }
}

///|
fn State::compute_effective_focus(self : State) -> NodeId {
  fn follow_graft_focus(focus : NodeId) -> NodeId {
    match self.nodes.get(focus) {
      None => focus
      Some(node_state) =>
        match node_state.data.tree_id() {
          None => focus
          Some(subtree_id) =>
            match self.subtrees.get(subtree_id) {
              Some(subtree) => follow_graft_focus(subtree.focus)
              None =>
                abort(
                  "Focus is on graft node but subtree does not exist. Graft nodes cannot be focused without their subtree.",
                )
            }
        }
    }
  }

  match self.subtrees.get(@common.TreeId::root()) {
    None => self.focus
    Some(root_subtree) => follow_graft_focus(root_subtree.focus)
  }
}

///|
fn State::update_host_focus_state(
  self : State,
  is_host_focused : Bool,
  opt_changes : InternalChanges?,
) -> Unit {
  let (focus, _) = self.focus.to_components()
  let update = @common.TreeUpdate(@common.TreeId::root(), focus)
  self.update(update, is_host_focused, opt_changes, TreeIndex(0))
}

///|
fn State::update(
  self : State,
  update : @common.TreeUpdate,
  is_host_focused : Bool,
  opt_changes : InternalChanges?,
  tree_index : TreeIndex,
) -> Unit {
  fn map_id(local_id : @common.NodeId) -> NodeId {
    NodeId(tree_index, local_id)
  }

  fn node_data_eq(a : @common.Node, b : @common.Node) -> Bool {
    a.debug() == b.debug()
  }

  let unreachable_node_ids : Map[NodeId, Unit] = Map([])
  let seen_child_ids : Map[NodeId, Unit] = Map([])
  let tree_id = update.tree_id()
  if tree_id != @common.TreeId::root() {
    let subtree_exists = self.subtrees.contains(tree_id)
    if update.tree() is Some(_) && !self.graft_parents.contains(tree_id) {
      abort(
        "Cannot push subtree: no graft node exists for this tree. Push the graft node before pushing the subtree.",
      )
    }
    if !subtree_exists && update.tree() is None {
      abort(
        "Cannot update subtree: subtree does not exist. The first update for a subtree must include tree data.",
      )
    }
  }
  let mut new_tree_root : NodeId? = None
  if update.tree() is Some(tree) {
    let new_root = map_id(tree.root_id())
    if tree_id == @common.TreeId::root() {
      if tree.root_id() != self.data.root_id() {
        unreachable_node_ids[self.root] = ()
      }
      self.root = new_root
      self.data = tree
    } else if self.subtrees.get(tree_id) is Some(subtree) {
      if subtree.root != new_root {
        unreachable_node_ids[subtree.root] = ()
      }
    }
    new_tree_root = Some(new_root)
  }
  let root_local = match new_tree_root {
    Some(r) => r.to_components().0
    None =>
      match self.subtrees.get(tree_id) {
        Some(subtree) => subtree.root.to_components().0
        None => self.data.root_id()
      }
  }
  let pending_nodes : Map[NodeId, @common.Node] = Map([])
  let pending_children : Map[NodeId, ParentAndIndex] = Map([])
  let pending_grafts : Map[@common.TreeId, NodeId] = Map([])
  let grafts_to_remove : Map[@common.TreeId, Unit] = Map([])
  fn record_graft(
    pending_grafts : Map[@common.TreeId, NodeId],
    subtree_id : @common.TreeId,
    graft_node_id : NodeId,
  ) -> Unit {
    if subtree_id == @common.TreeId::root() {
      abort("Cannot graft the root tree")
    }
    if pending_grafts.contains(subtree_id) {
      abort("Subtree already has a graft parent")
    }
    pending_grafts[subtree_id] = graft_node_id
  }

  fn add_node(
    nodes : Map[NodeId, NodeState],
    pending_grafts : Map[@common.TreeId, NodeId],
    opt_changes : InternalChanges?,
    parent_and_index : ParentAndIndex?,
    id : NodeId,
    data : @common.Node,
  ) -> Unit {
    if data.tree_id() is Some(subtree_id) {
      if data.children().length() > 0 {
        abort(
          "Node has both tree_id and children. A graft node's only child comes from its subtree.",
        )
      }
      record_graft(pending_grafts, subtree_id, id)
    }
    nodes[id] = NodeState::{ parent_and_index, data }
    if opt_changes is Some(changes) {
      changes.added_node_ids[id] = ()
    }
  }

  for node_update in update.nodes() {
    let local_node_id = node_update.id()
    let node_data = node_update.node()
    let node_id = map_id(local_node_id)
    map_set_remove(unreachable_node_ids, node_id)
    let children = node_data.children()
    for child_index in 0..<children.length() {
      let child_id = map_id(children[child_index])
      if !map_set_insert(seen_child_ids, child_id) {
        abort("TreeUpdate includes duplicate child")
      }
      map_set_remove(unreachable_node_ids, child_id)
      let parent_and_index = ParentAndIndex(node_id, child_index)
      if self.nodes.get(child_id) is Some(child_state) {
        if child_state.parent_and_index != Some(parent_and_index) {
          self.nodes[child_id] = NodeState::{
            parent_and_index: Some(parent_and_index),
            data: child_state.data,
          }
          if opt_changes is Some(changes) {
            changes.updated_node_ids[child_id] = ()
          }
        }
      } else if pending_nodes.get(child_id) is Some(child_data) {
        pending_nodes.remove(child_id)
        add_node(
          self.nodes,
          pending_grafts,
          opt_changes,
          Some(parent_and_index),
          child_id,
          child_data,
        )
      } else {
        pending_children[child_id] = parent_and_index
      }
    }
    if self.nodes.get(node_id) is Some(node_state0) {
      let old_parent_and_index = node_state0.parent_and_index
      let parent_and_index = if local_node_id == root_local {
        None
      } else {
        old_parent_and_index
      }
      let old_data = node_state0.data
      for existing_child in old_data.children() {
        let mapped_existing_child_id = map_id(existing_child)
        if !seen_child_ids.contains(mapped_existing_child_id) {
          unreachable_node_ids[mapped_existing_child_id] = ()
        }
      }
      let data_changed = !node_data_eq(old_data, node_data)
      if data_changed {
        if node_data.tree_id() is Some(_) && node_data.children().length() > 0 {
          abort(
            "Node has both tree_id and children. A graft node's only child comes from its subtree.",
          )
        }
        let old_tree_id = old_data.tree_id()
        let new_tree_id = node_data.tree_id()
        if old_tree_id != new_tree_id {
          if old_tree_id is Some(old_subtree_id) {
            grafts_to_remove[old_subtree_id] = ()
          }
          if new_tree_id is Some(new_subtree_id) {
            record_graft(pending_grafts, new_subtree_id, node_id)
          }
        }
      }
      if data_changed || parent_and_index != old_parent_and_index {
        self.nodes[node_id] = NodeState::{
          parent_and_index,
          data: if data_changed {
            node_data
          } else {
            old_data
          },
        }
        if opt_changes is Some(changes) {
          changes.updated_node_ids[node_id] = ()
        }
      }
    } else if pending_children.get(node_id) is Some(parent_and_index) {
      pending_children.remove(node_id)
      add_node(
        self.nodes,
        pending_grafts,
        opt_changes,
        Some(parent_and_index),
        node_id,
        node_data,
      )
    } else if local_node_id == root_local {
      add_node(
        self.nodes,
        pending_grafts,
        opt_changes,
        None,
        node_id,
        node_data,
      )
    } else {
      pending_nodes[node_id] = node_data
    }
  }
  if pending_nodes.length() > 0 {
    abort(
      "TreeUpdate includes nodes which are neither in the current tree nor a child of another node from the update",
    )
  }
  if pending_children.length() > 0 {
    abort(
      "TreeUpdate includes children ids which are neither in the current tree nor the ID of another node from the update",
    )
  }
  let tree_focus = map_id(update.focus())
  if new_tree_root is Some(new_root) {
    self.subtrees[tree_id] = { root: new_root, focus: tree_focus }
  } else if self.subtrees.get(tree_id) is Some(subtree) {
    self.subtrees[tree_id] = { root: subtree.root, focus: tree_focus }
  } else if tree_id == @common.TreeId::root() {
    self.subtrees[tree_id] = { root: self.root, focus: tree_focus }
  }
  self.is_host_focused = is_host_focused
  if unreachable_node_ids.length() > 0 {
    fn traverse_unreachable(
      nodes : Map[NodeId, NodeState],
      grafts_to_remove : Map[@common.TreeId, Unit],
      opt_changes : InternalChanges?,
      seen_child_ids : Map[NodeId, Unit],
      new_tree_root : NodeId?,
      id : NodeId,
    ) -> Unit {
      if opt_changes is Some(changes) {
        changes.removed_node_ids[id] = ()
      }
      let node_state = nodes.get(id).unwrap()
      nodes.remove(id)
      if node_state.data.tree_id() is Some(subtree_id) {
        grafts_to_remove[subtree_id] = ()
      }
      let (_, tree_index) = id.to_components()
      for child_local_id in node_state.data.children() {
        let child_node_id = NodeId(tree_index, child_local_id)
        if !seen_child_ids.contains(child_node_id) &&
          new_tree_root != Some(child_node_id) {
          traverse_unreachable(
            nodes, grafts_to_remove, opt_changes, seen_child_ids, new_tree_root,
            child_node_id,
          )
        }
      }
    }

    for id, _ in unreachable_node_ids {
      traverse_unreachable(
        self.nodes,
        grafts_to_remove,
        opt_changes,
        seen_child_ids,
        new_tree_root,
        id,
      )
    }
  }
  fn traverse_subtree(
    nodes : Map[NodeId, NodeState],
    subtrees_to_remove : Array[@common.TreeId],
    subtrees_queued : Map[@common.TreeId, Unit],
    opt_changes : InternalChanges?,
    id : NodeId,
  ) -> Unit {
    match nodes.get(id) {
      None => return
      Some(node_state) => {
        nodes.remove(id)
        if opt_changes is Some(changes) {
          changes.removed_node_ids[id] = ()
        }
        if node_state.data.tree_id() is Some(nested_subtree_id) {
          if map_set_insert(subtrees_queued, nested_subtree_id) {
            subtrees_to_remove.push(nested_subtree_id)
          }
        }
        let (_, tree_index) = id.to_components()
        for child_local_id in node_state.data.children() {
          traverse_subtree(
            nodes,
            subtrees_to_remove,
            subtrees_queued,
            opt_changes,
            NodeId(tree_index, child_local_id),
          )
        }
      }
    }
  }

  let subtrees_queued : Map[@common.TreeId, Unit] = grafts_to_remove.copy()
  let subtrees_to_remove : Array[@common.TreeId] = []
  for subtree_id, _ in subtrees_queued {
    subtrees_to_remove.push(subtree_id)
  }
  let mut i = 0
  while i < subtrees_to_remove.length() {
    let subtree_id = subtrees_to_remove[i]
    i = i + 1
    if !self.graft_parents.contains(subtree_id) {
      continue
    }
    self.graft_parents.remove(subtree_id)
    if pending_grafts.contains(subtree_id) {
      continue
    }
    match self.subtrees.get(subtree_id) {
      None => ()
      Some(subtree) => {
        self.subtrees.remove(subtree_id)
        traverse_subtree(
          self.nodes,
          subtrees_to_remove,
          subtrees_queued,
          opt_changes,
          subtree.root,
        )
      }
    }
  }
  for subtree_id, node_id in pending_grafts {
    if self.graft_parents.contains(subtree_id) {
      abort("Subtree already has a graft parent")
    }
    self.graft_parents[subtree_id] = node_id
    match self.subtrees.get(subtree_id) {
      None => ()
      Some(subtree) => {
        let subtree_root_id = subtree.root
        match self.nodes.get(subtree_root_id) {
          None => ()
          Some(root_state0) => {
            let root_state = root_state0
            root_state.parent_and_index = Some(ParentAndIndex(node_id, 0))
            self.nodes[subtree_root_id] = root_state
            if opt_changes is Some(changes) {
              if !changes.added_node_ids.contains(subtree_root_id) {
                changes.updated_node_ids[subtree_root_id] = ()
              }
            }
          }
        }
      }
    }
  }
  if new_tree_root is Some(new_root_id) {
    match self.graft_parents.get(tree_id) {
      None => ()
      Some(graft_node_id) =>
        match self.nodes.get(new_root_id) {
          None => ()
          Some(root_state0) => {
            let root_state = root_state0
            root_state.parent_and_index = Some(ParentAndIndex(graft_node_id, 0))
            self.nodes[new_root_id] = root_state
            if opt_changes is Some(changes) {
              if !changes.added_node_ids.contains(new_root_id) {
                changes.updated_node_ids[new_root_id] = ()
              }
            }
          }
        }
    }
  }
  self.focus = self.compute_effective_focus()
  self.validate_global()
}

///|
pub fn[H : ChangeHandler] Tree::update_and_process_changes(
  self : Tree,
  update : @common.TreeUpdate,
  handler : H,
) -> Unit {
  let tree_index = self.tree_index_map.get_index(update.tree_id())
  self.next_state = self.state.clone_state()
  let changes = InternalChanges::InternalChanges()
  self.next_state.update(
    update,
    self.state.is_host_focused,
    Some(changes),
    tree_index,
  )
  self.process_changes(changes, handler)
}

///|
pub fn[H : ChangeHandler] Tree::update_host_focus_state_and_process_changes(
  self : Tree,
  is_host_focused : Bool,
  handler : H,
) -> Unit {
  self.next_state = self.state.clone_state()
  let changes = InternalChanges::InternalChanges()
  self.next_state.update_host_focus_state(is_host_focused, Some(changes))
  self.process_changes(changes, handler)
}

///|
fn[H : ChangeHandler] Tree::process_changes(
  self : Tree,
  changes : InternalChanges,
  handler : H,
) -> Unit {
  for id, _ in changes.added_node_ids {
    let node = self.next_state.node_by_id(id).unwrap()
    handler.node_added(node)
  }
  for id, _ in changes.updated_node_ids {
    let old_node = self.state.node_by_id(id).unwrap()
    let new_node = self.next_state.node_by_id(id).unwrap()
    handler.node_updated(old_node, new_node)
  }
  let old_focus = self.state.focus()
  let new_focus = self.next_state.focus()
  if old_focus.map(n => n.id()) != new_focus.map(n => n.id()) {
    if old_focus is Some(old_node) {
      let id = old_node.id()
      if !changes.updated_node_ids.contains(id) &&
        !changes.removed_node_ids.contains(id) {
        match self.next_state.node_by_id(id) {
          None => ()
          Some(old_node_new_version) =>
            handler.node_updated(old_node, old_node_new_version)
        }
      }
    }
    if new_focus is Some(new_node) {
      let id = new_node.id()
      if !changes.added_node_ids.contains(id) &&
        !changes.updated_node_ids.contains(id) {
        match self.state.node_by_id(id) {
          None => ()
          Some(new_node_old_version) =>
            handler.node_updated(new_node_old_version, new_node)
        }
      }
    }
    handler.focus_moved(old_focus, new_focus)
  }
  for id, _ in changes.removed_node_ids {
    let node = self.state.node_by_id(id).unwrap()
    handler.node_removed(node)
  }
  self.state = self.next_state.clone_state()
  self.next_state = self.state.clone_state()
}
