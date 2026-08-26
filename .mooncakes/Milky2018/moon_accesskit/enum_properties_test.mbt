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
test "invalid getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.invalid(), None)
}

///|
test "invalid setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_invalid(Invalid::Grammar)
  @test.assert_eq(node.invalid(), Some(Invalid::Grammar))
}

///|
test "invalid clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_invalid(Invalid::Grammar)
  node.clear_invalid()
  @test.assert_eq(node.invalid(), None)
}

///|
test "toggled getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.toggled(), None)
}

///|
test "toggled setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_toggled(Toggled::True)
  @test.assert_eq(node.toggled(), Some(Toggled::True))
}

///|
test "toggled clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_toggled(Toggled::True)
  node.clear_toggled()
  @test.assert_eq(node.toggled(), None)
}

///|
test "live getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.live(), None)
}

///|
test "live setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_live(Live::Polite)
  @test.assert_eq(node.live(), Some(Live::Polite))
}

///|
test "live clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_live(Live::Polite)
  node.clear_live()
  @test.assert_eq(node.live(), None)
}

///|
test "text_direction getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.text_direction(), None)
}

///|
test "text_direction setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_text_direction(TextDirection::RightToLeft)
  @test.assert_eq(node.text_direction(), Some(TextDirection::RightToLeft))
}

///|
test "text_direction clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_text_direction(TextDirection::RightToLeft)
  node.clear_text_direction()
  @test.assert_eq(node.text_direction(), None)
}

///|
test "orientation getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.orientation(), None)
}

///|
test "orientation setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_orientation(Orientation::Vertical)
  @test.assert_eq(node.orientation(), Some(Orientation::Vertical))
}

///|
test "orientation clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_orientation(Orientation::Vertical)
  node.clear_orientation()
  @test.assert_eq(node.orientation(), None)
}

///|
test "sort_direction getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.sort_direction(), None)
}

///|
test "sort_direction setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_sort_direction(SortDirection::Descending)
  @test.assert_eq(node.sort_direction(), Some(SortDirection::Descending))
}

///|
test "sort_direction clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_sort_direction(SortDirection::Descending)
  node.clear_sort_direction()
  @test.assert_eq(node.sort_direction(), None)
}

///|
test "aria_current getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.aria_current(), None)
}

///|
test "aria_current setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_aria_current(AriaCurrent::True)
  @test.assert_eq(node.aria_current(), Some(AriaCurrent::True))
}

///|
test "aria_current clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_aria_current(AriaCurrent::True)
  node.clear_aria_current()
  @test.assert_eq(node.aria_current(), None)
}

///|
test "auto_complete getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.auto_complete(), None)
}

///|
test "auto_complete setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_auto_complete(AutoComplete::List)
  @test.assert_eq(node.auto_complete(), Some(AutoComplete::List))
}

///|
test "auto_complete clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_auto_complete(AutoComplete::List)
  node.clear_auto_complete()
  @test.assert_eq(node.auto_complete(), None)
}

///|
test "has_popup getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.has_popup(), None)
}

///|
test "has_popup setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_has_popup(HasPopup::Menu)
  @test.assert_eq(node.has_popup(), Some(HasPopup::Menu))
}

///|
test "has_popup clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_has_popup(HasPopup::Menu)
  node.clear_has_popup()
  @test.assert_eq(node.has_popup(), None)
}

///|
test "list_style getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.list_style(), None)
}

///|
test "list_style setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_list_style(ListStyle::Disc)
  @test.assert_eq(node.list_style(), Some(ListStyle::Disc))
}

///|
test "list_style clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_list_style(ListStyle::Disc)
  node.clear_list_style()
  @test.assert_eq(node.list_style(), None)
}

///|
test "text_align getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.text_align(), None)
}

///|
test "text_align setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_text_align(TextAlign::Right)
  @test.assert_eq(node.text_align(), Some(TextAlign::Right))
}

///|
test "text_align clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_text_align(TextAlign::Right)
  node.clear_text_align()
  @test.assert_eq(node.text_align(), None)
}

///|
test "vertical_offset getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.vertical_offset(), None)
}

///|
test "vertical_offset setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_vertical_offset(VerticalOffset::Superscript)
  @test.assert_eq(node.vertical_offset(), Some(VerticalOffset::Superscript))
}

///|
test "vertical_offset clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_vertical_offset(VerticalOffset::Superscript)
  node.clear_vertical_offset()
  @test.assert_eq(node.vertical_offset(), None)
}
