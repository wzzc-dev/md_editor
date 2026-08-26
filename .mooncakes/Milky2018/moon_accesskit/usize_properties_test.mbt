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
test "row_count getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.row_count(), None)
}

///|
test "row_count setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_row_count(1)
  @test.assert_eq(node.row_count(), Some(1))
}

///|
test "row_count clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_row_count(1)
  node.clear_row_count()
  @test.assert_eq(node.row_count(), None)
}

///|
test "column_count getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.column_count(), None)
}

///|
test "column_count setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_column_count(1)
  @test.assert_eq(node.column_count(), Some(1))
}

///|
test "column_count clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_column_count(1)
  node.clear_column_count()
  @test.assert_eq(node.column_count(), None)
}

///|
test "row_index getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.row_index(), None)
}

///|
test "row_index setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_row_index(1)
  @test.assert_eq(node.row_index(), Some(1))
}

///|
test "row_index clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_row_index(1)
  node.clear_row_index()
  @test.assert_eq(node.row_index(), None)
}

///|
test "column_index getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.column_index(), None)
}

///|
test "column_index setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_column_index(1)
  @test.assert_eq(node.column_index(), Some(1))
}

///|
test "column_index clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_column_index(1)
  node.clear_column_index()
  @test.assert_eq(node.column_index(), None)
}

///|
test "row_span getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.row_span(), None)
}

///|
test "row_span setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_row_span(1)
  @test.assert_eq(node.row_span(), Some(1))
}

///|
test "row_span clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_row_span(1)
  node.clear_row_span()
  @test.assert_eq(node.row_span(), None)
}

///|
test "column_span getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.column_span(), None)
}

///|
test "column_span setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_column_span(1)
  @test.assert_eq(node.column_span(), Some(1))
}

///|
test "column_span clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_column_span(1)
  node.clear_column_span()
  @test.assert_eq(node.column_span(), None)
}

///|
test "level getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.level(), None)
}

///|
test "level setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_level(1)
  @test.assert_eq(node.level(), Some(1))
}

///|
test "level clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_level(1)
  node.clear_level()
  @test.assert_eq(node.level(), None)
}

///|
test "size_of_set getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.size_of_set(), None)
}

///|
test "size_of_set setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_size_of_set(1)
  @test.assert_eq(node.size_of_set(), Some(1))
}

///|
test "size_of_set clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_size_of_set(1)
  node.clear_size_of_set()
  @test.assert_eq(node.size_of_set(), None)
}

///|
test "position_in_set getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.position_in_set(), None)
}

///|
test "position_in_set setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_position_in_set(1)
  @test.assert_eq(node.position_in_set(), Some(1))
}

///|
test "position_in_set clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_position_in_set(1)
  node.clear_position_in_set()
  @test.assert_eq(node.position_in_set(), None)
}
