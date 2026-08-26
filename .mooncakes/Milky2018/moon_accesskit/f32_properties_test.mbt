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
test "font_size getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.font_size(), None)
}

///|
test "font_size setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_font_size(1.0F)
  @test.assert_eq(node.font_size(), Some(1.0F))
}

///|
test "font_size clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_font_size(1.0F)
  node.clear_font_size()
  @test.assert_eq(node.font_size(), None)
}

///|
test "font_weight getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.font_weight(), None)
}

///|
test "font_weight setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_font_weight(1.0F)
  @test.assert_eq(node.font_weight(), Some(1.0F))
}

///|
test "font_weight clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_font_weight(1.0F)
  node.clear_font_weight()
  @test.assert_eq(node.font_weight(), None)
}
