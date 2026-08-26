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
test "label getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.label(), None)
}

///|
test "label setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_label("test")
  @test.assert_eq(node.label(), Some("test"))
}

///|
test "label clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_label("test")
  node.clear_label()
  @test.assert_eq(node.label(), None)
}

///|
test "description getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.description(), None)
}

///|
test "description setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_description("test")
  @test.assert_eq(node.description(), Some("test"))
}

///|
test "description clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_description("test")
  node.clear_description()
  @test.assert_eq(node.description(), None)
}

///|
test "value getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.value(), None)
}

///|
test "value setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_value("test")
  @test.assert_eq(node.value(), Some("test"))
}

///|
test "value clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_value("test")
  node.clear_value()
  @test.assert_eq(node.value(), None)
}

///|
test "access_key getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.access_key(), None)
}

///|
test "access_key setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_access_key("test")
  @test.assert_eq(node.access_key(), Some("test"))
}

///|
test "access_key clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_access_key("test")
  node.clear_access_key()
  @test.assert_eq(node.access_key(), None)
}

///|
test "author_id getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.author_id(), None)
}

///|
test "author_id setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_author_id("test")
  @test.assert_eq(node.author_id(), Some("test"))
}

///|
test "author_id clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_author_id("test")
  node.clear_author_id()
  @test.assert_eq(node.author_id(), None)
}

///|
test "class_name getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.class_name(), None)
}

///|
test "class_name setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_class_name("test")
  @test.assert_eq(node.class_name(), Some("test"))
}

///|
test "class_name clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_class_name("test")
  node.clear_class_name()
  @test.assert_eq(node.class_name(), None)
}

///|
test "font_family getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.font_family(), None)
}

///|
test "font_family setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_font_family("test")
  @test.assert_eq(node.font_family(), Some("test"))
}

///|
test "font_family clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_font_family("test")
  node.clear_font_family()
  @test.assert_eq(node.font_family(), None)
}

///|
test "html_tag getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.html_tag(), None)
}

///|
test "html_tag setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_html_tag("test")
  @test.assert_eq(node.html_tag(), Some("test"))
}

///|
test "html_tag clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_html_tag("test")
  node.clear_html_tag()
  @test.assert_eq(node.html_tag(), None)
}

///|
test "inner_html getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.inner_html(), None)
}

///|
test "inner_html setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_inner_html("test")
  @test.assert_eq(node.inner_html(), Some("test"))
}

///|
test "inner_html clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_inner_html("test")
  node.clear_inner_html()
  @test.assert_eq(node.inner_html(), None)
}

///|
test "keyboard_shortcut getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.keyboard_shortcut(), None)
}

///|
test "keyboard_shortcut setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_keyboard_shortcut("test")
  @test.assert_eq(node.keyboard_shortcut(), Some("test"))
}

///|
test "keyboard_shortcut clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_keyboard_shortcut("test")
  node.clear_keyboard_shortcut()
  @test.assert_eq(node.keyboard_shortcut(), None)
}

///|
test "language getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.language(), None)
}

///|
test "language setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_language("test")
  @test.assert_eq(node.language(), Some("test"))
}

///|
test "language clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_language("test")
  node.clear_language()
  @test.assert_eq(node.language(), None)
}

///|
test "placeholder getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.placeholder(), None)
}

///|
test "placeholder setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_placeholder("test")
  @test.assert_eq(node.placeholder(), Some("test"))
}

///|
test "placeholder clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_placeholder("test")
  node.clear_placeholder()
  @test.assert_eq(node.placeholder(), None)
}

///|
test "role_description getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.role_description(), None)
}

///|
test "role_description setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_role_description("test")
  @test.assert_eq(node.role_description(), Some("test"))
}

///|
test "role_description clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_role_description("test")
  node.clear_role_description()
  @test.assert_eq(node.role_description(), None)
}

///|
test "state_description getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.state_description(), None)
}

///|
test "state_description setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_state_description("test")
  @test.assert_eq(node.state_description(), Some("test"))
}

///|
test "state_description clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_state_description("test")
  node.clear_state_description()
  @test.assert_eq(node.state_description(), None)
}

///|
test "tooltip getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.tooltip(), None)
}

///|
test "tooltip setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_tooltip("test")
  @test.assert_eq(node.tooltip(), Some("test"))
}

///|
test "tooltip clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_tooltip("test")
  node.clear_tooltip()
  @test.assert_eq(node.tooltip(), None)
}

///|
test "url getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.url(), None)
}

///|
test "url setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_url("test")
  @test.assert_eq(node.url(), Some("test"))
}

///|
test "url clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_url("test")
  node.clear_url()
  @test.assert_eq(node.url(), None)
}

///|
test "row_index_text getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.row_index_text(), None)
}

///|
test "row_index_text setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_row_index_text("test")
  @test.assert_eq(node.row_index_text(), Some("test"))
}

///|
test "row_index_text clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_row_index_text("test")
  node.clear_row_index_text()
  @test.assert_eq(node.row_index_text(), None)
}

///|
test "column_index_text getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.column_index_text(), None)
}

///|
test "column_index_text setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_column_index_text("test")
  @test.assert_eq(node.column_index_text(), Some("test"))
}

///|
test "column_index_text clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_column_index_text("test")
  node.clear_column_index_text()
  @test.assert_eq(node.column_index_text(), None)
}

///|
test "braille_label getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.braille_label(), None)
}

///|
test "braille_label setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_braille_label("test")
  @test.assert_eq(node.braille_label(), Some("test"))
}

///|
test "braille_label clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_braille_label("test")
  node.clear_braille_label()
  @test.assert_eq(node.braille_label(), None)
}

///|
test "braille_role_description getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.braille_role_description(), None)
}

///|
test "braille_role_description setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_braille_role_description("test")
  @test.assert_eq(node.braille_role_description(), Some("test"))
}

///|
test "braille_role_description clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_braille_role_description("test")
  node.clear_braille_role_description()
  @test.assert_eq(node.braille_role_description(), None)
}
