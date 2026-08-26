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
test "is_hidden: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_hidden())
}

///|
test "is_hidden: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_hidden()
  assert_true(node.is_hidden())
}

///|
test "is_hidden: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_hidden()
  node.clear_hidden()
  assert_false(node.is_hidden())
}

///|
test "is_multiselectable: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_multiselectable())
}

///|
test "is_multiselectable: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_multiselectable()
  assert_true(node.is_multiselectable())
}

///|
test "is_multiselectable: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_multiselectable()
  node.clear_multiselectable()
  assert_false(node.is_multiselectable())
}

///|
test "is_required: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_required())
}

///|
test "is_required: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_required()
  assert_true(node.is_required())
}

///|
test "is_required: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_required()
  node.clear_required()
  assert_false(node.is_required())
}

///|
test "is_visited: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_visited())
}

///|
test "is_visited: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_visited()
  assert_true(node.is_visited())
}

///|
test "is_visited: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_visited()
  node.clear_visited()
  assert_false(node.is_visited())
}

///|
test "is_busy: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_busy())
}

///|
test "is_busy: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_busy()
  assert_true(node.is_busy())
}

///|
test "is_busy: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_busy()
  node.clear_busy()
  assert_false(node.is_busy())
}

///|
test "is_live_atomic: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_live_atomic())
}

///|
test "is_live_atomic: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_live_atomic()
  assert_true(node.is_live_atomic())
}

///|
test "is_live_atomic: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_live_atomic()
  node.clear_live_atomic()
  assert_false(node.is_live_atomic())
}

///|
test "is_modal: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_modal())
}

///|
test "is_modal: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_modal()
  assert_true(node.is_modal())
}

///|
test "is_modal: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_modal()
  node.clear_modal()
  assert_false(node.is_modal())
}

///|
test "is_touch_transparent: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_touch_transparent())
}

///|
test "is_touch_transparent: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_touch_transparent()
  assert_true(node.is_touch_transparent())
}

///|
test "is_touch_transparent: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_touch_transparent()
  node.clear_touch_transparent()
  assert_false(node.is_touch_transparent())
}

///|
test "is_read_only: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_read_only())
}

///|
test "is_read_only: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_read_only()
  assert_true(node.is_read_only())
}

///|
test "is_read_only: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_read_only()
  node.clear_read_only()
  assert_false(node.is_read_only())
}

///|
test "is_disabled: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_disabled())
}

///|
test "is_disabled: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_disabled()
  assert_true(node.is_disabled())
}

///|
test "is_disabled: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_disabled()
  node.clear_disabled()
  assert_false(node.is_disabled())
}

///|
test "is_italic: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_italic())
}

///|
test "is_italic: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_italic()
  assert_true(node.is_italic())
}

///|
test "is_italic: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_italic()
  node.clear_italic()
  assert_false(node.is_italic())
}

///|
test "clips_children: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.clips_children())
}

///|
test "clips_children: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_clips_children()
  assert_true(node.clips_children())
}

///|
test "clips_children: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_clips_children()
  node.clear_clips_children()
  assert_false(node.clips_children())
}

///|
test "is_line_breaking_object: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_line_breaking_object())
}

///|
test "is_line_breaking_object: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_is_line_breaking_object()
  assert_true(node.is_line_breaking_object())
}

///|
test "is_line_breaking_object: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_is_line_breaking_object()
  node.clear_is_line_breaking_object()
  assert_false(node.is_line_breaking_object())
}

///|
test "is_page_breaking_object: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_page_breaking_object())
}

///|
test "is_page_breaking_object: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_is_page_breaking_object()
  assert_true(node.is_page_breaking_object())
}

///|
test "is_page_breaking_object: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_is_page_breaking_object()
  node.clear_is_page_breaking_object()
  assert_false(node.is_page_breaking_object())
}

///|
test "is_spelling_error: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_spelling_error())
}

///|
test "is_spelling_error: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_is_spelling_error()
  assert_true(node.is_spelling_error())
}

///|
test "is_spelling_error: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_is_spelling_error()
  node.clear_is_spelling_error()
  assert_false(node.is_spelling_error())
}

///|
test "is_grammar_error: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_grammar_error())
}

///|
test "is_grammar_error: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_is_grammar_error()
  assert_true(node.is_grammar_error())
}

///|
test "is_grammar_error: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_is_grammar_error()
  node.clear_is_grammar_error()
  assert_false(node.is_grammar_error())
}

///|
test "is_search_match: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_search_match())
}

///|
test "is_search_match: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_is_search_match()
  assert_true(node.is_search_match())
}

///|
test "is_search_match: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_is_search_match()
  node.clear_is_search_match()
  assert_false(node.is_search_match())
}

///|
test "is_suggestion: default false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  assert_false(node.is_suggestion())
}

///|
test "is_suggestion: setter sets true" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_is_suggestion()
  assert_true(node.is_suggestion())
}

///|
test "is_suggestion: clearer resets false" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_is_suggestion()
  node.clear_is_suggestion()
  assert_false(node.is_suggestion())
}
