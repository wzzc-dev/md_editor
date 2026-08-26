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
test "character_positions getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.character_positions(), None)
}

///|
test "character_positions setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_character_positions([])
  @test.assert_eq(node.character_positions(), Some([]))
  node.set_character_positions([1.0, 2.0])
  @test.assert_eq(node.character_positions(), Some([1.0, 2.0]))
}

///|
test "character_positions clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_character_positions([1.0, 2.0])
  node.clear_character_positions()
  @test.assert_eq(node.character_positions(), None)
}

///|
test "character_widths getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.character_widths(), None)
}

///|
test "character_widths setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_character_widths([])
  @test.assert_eq(node.character_widths(), Some([]))
  node.set_character_widths([1.0, 2.0])
  @test.assert_eq(node.character_widths(), Some([1.0, 2.0]))
}

///|
test "character_widths clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_character_widths([1.0, 2.0])
  node.clear_character_widths()
  @test.assert_eq(node.character_widths(), None)
}
