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
fn test_text_decoration() -> TextDecoration {
  TextDecoration::TextDecoration(
    TextDecorationStyle::Dotted,
    @moon_accesskit.Color(
      (0).to_byte(),
      (0).to_byte(),
      (0).to_byte(),
      (255).to_byte(),
    ),
  )
}

///|
test "overline getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.overline(), None)
}

///|
test "overline setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  let decoration = test_text_decoration()
  node.set_overline(decoration)
  @test.assert_eq(node.overline(), Some(decoration))
}

///|
test "overline clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_overline(test_text_decoration())
  node.clear_overline()
  @test.assert_eq(node.overline(), None)
}

///|
test "strikethrough getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.strikethrough(), None)
}

///|
test "strikethrough setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  let decoration = test_text_decoration()
  node.set_strikethrough(decoration)
  @test.assert_eq(node.strikethrough(), Some(decoration))
}

///|
test "strikethrough clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_strikethrough(test_text_decoration())
  node.clear_strikethrough()
  @test.assert_eq(node.strikethrough(), None)
}

///|
test "underline getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.underline(), None)
}

///|
test "underline setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  let decoration = test_text_decoration()
  node.set_underline(decoration)
  @test.assert_eq(node.underline(), Some(decoration))
}

///|
test "underline clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_underline(test_text_decoration())
  node.clear_underline()
  @test.assert_eq(node.underline(), None)
}
