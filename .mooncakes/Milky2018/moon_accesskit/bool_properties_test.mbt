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
test "is_expanded getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.is_expanded(), None)
}

///|
test "is_expanded setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_expanded(true)
  @test.assert_eq(node.is_expanded(), Some(true))
}

///|
test "is_expanded clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_expanded(true)
  node.clear_expanded()
  @test.assert_eq(node.is_expanded(), None)
}

///|
test "is_selected getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.is_selected(), None)
}

///|
test "is_selected setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_selected(true)
  @test.assert_eq(node.is_selected(), Some(true))
}

///|
test "is_selected clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_selected(true)
  node.clear_selected()
  @test.assert_eq(node.is_selected(), None)
}
