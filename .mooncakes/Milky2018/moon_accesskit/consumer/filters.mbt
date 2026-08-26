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
pub(all) enum FilterResult {
  Include
  ExcludeNode
  ExcludeSubtree
} derive(Eq, Debug)

///|
pub impl Show for FilterResult with output(self, logger) {
  show_via_debug(self, logger)
}

///|
fn common_filter_base(node : Node) -> FilterResult? {
  if node.is_focused() {
    return Some(FilterResult::Include)
  }
  if node.is_hidden() {
    return Some(FilterResult::ExcludeSubtree)
  }
  // Graft nodes are transparent containers pointing to a subtree.
  if node.is_graft() {
    return Some(FilterResult::ExcludeNode)
  }
  let role = node.role()
  if role == @common.Role::GenericContainer || role == @common.Role::TextRun {
    return Some(FilterResult::ExcludeNode)
  }
  None
}

///|
fn common_filter_without_parent_checks(node : Node) -> FilterResult {
  match common_filter_base(node) {
    Some(result) => result
    None => FilterResult::Include
  }
}

///|
fn is_first_sibling_in_parent_bbox(
  siblings : Array[Node],
  parent_bbox : @common.Rect,
) -> Bool {
  if siblings.length() == 0 {
    false
  } else {
    match siblings[0].bounding_box() {
      None => false
      Some(bbox) => !bbox.intersect(parent_bbox).is_empty()
    }
  }
}

///|
pub fn common_filter(node : Node) -> FilterResult {
  match common_filter_base(node) {
    Some(result) => return result
    None => ()
  }
  match node.parent() {
    None => ()
    Some(parent) =>
      if common_filter(parent) == FilterResult::ExcludeSubtree {
        return FilterResult::ExcludeSubtree
      }
  }
  match node.filtered_parent(common_filter_without_parent_checks) {
    None => ()
    Some(parent) =>
      if parent.clips_children() {
        match node.bounding_box() {
          None => ()
          Some(bbox) =>
            match parent.bounding_box() {
              None => ()
              Some(parent_bbox) => {
                let should_exclude = bbox.intersect(parent_bbox).is_empty() &&
                  !(is_first_sibling_in_parent_bbox(
                    node.following_filtered_siblings(
                      common_filter_without_parent_checks,
                    ),
                    parent_bbox,
                  ) ||
                  is_first_sibling_in_parent_bbox(
                    node.preceding_filtered_siblings(
                      common_filter_without_parent_checks,
                    ),
                    parent_bbox,
                  ))
                if should_exclude {
                  return FilterResult::ExcludeSubtree
                }
              }
            }
        }
      }
  }
  FilterResult::Include
}

///|
pub fn common_filter_with_root_exception(node : Node) -> FilterResult {
  if node.is_root() {
    FilterResult::Include
  } else {
    common_filter(node)
  }
}
