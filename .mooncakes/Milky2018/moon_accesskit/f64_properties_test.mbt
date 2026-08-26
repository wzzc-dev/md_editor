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
test "scroll_x getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.scroll_x(), None)
}

///|
test "scroll_x setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_scroll_x(1.0)
  @test.assert_eq(node.scroll_x(), Some(1.0))
}

///|
test "scroll_x clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_scroll_x(1.0)
  node.clear_scroll_x()
  @test.assert_eq(node.scroll_x(), None)
}

///|
test "scroll_x_min getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.scroll_x_min(), None)
}

///|
test "scroll_x_min setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_scroll_x_min(1.0)
  @test.assert_eq(node.scroll_x_min(), Some(1.0))
}

///|
test "scroll_x_min clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_scroll_x_min(1.0)
  node.clear_scroll_x_min()
  @test.assert_eq(node.scroll_x_min(), None)
}

///|
test "scroll_x_max getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.scroll_x_max(), None)
}

///|
test "scroll_x_max setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_scroll_x_max(1.0)
  @test.assert_eq(node.scroll_x_max(), Some(1.0))
}

///|
test "scroll_x_max clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_scroll_x_max(1.0)
  node.clear_scroll_x_max()
  @test.assert_eq(node.scroll_x_max(), None)
}

///|
test "scroll_y getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.scroll_y(), None)
}

///|
test "scroll_y setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_scroll_y(1.0)
  @test.assert_eq(node.scroll_y(), Some(1.0))
}

///|
test "scroll_y clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_scroll_y(1.0)
  node.clear_scroll_y()
  @test.assert_eq(node.scroll_y(), None)
}

///|
test "scroll_y_min getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.scroll_y_min(), None)
}

///|
test "scroll_y_min setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_scroll_y_min(1.0)
  @test.assert_eq(node.scroll_y_min(), Some(1.0))
}

///|
test "scroll_y_min clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_scroll_y_min(1.0)
  node.clear_scroll_y_min()
  @test.assert_eq(node.scroll_y_min(), None)
}

///|
test "scroll_y_max getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.scroll_y_max(), None)
}

///|
test "scroll_y_max setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_scroll_y_max(1.0)
  @test.assert_eq(node.scroll_y_max(), Some(1.0))
}

///|
test "scroll_y_max clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_scroll_y_max(1.0)
  node.clear_scroll_y_max()
  @test.assert_eq(node.scroll_y_max(), None)
}

///|
test "numeric_value getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.numeric_value(), None)
}

///|
test "numeric_value setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_numeric_value(1.0)
  @test.assert_eq(node.numeric_value(), Some(1.0))
}

///|
test "numeric_value clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_numeric_value(1.0)
  node.clear_numeric_value()
  @test.assert_eq(node.numeric_value(), None)
}

///|
test "min_numeric_value getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.min_numeric_value(), None)
}

///|
test "min_numeric_value setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_min_numeric_value(1.0)
  @test.assert_eq(node.min_numeric_value(), Some(1.0))
}

///|
test "min_numeric_value clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_min_numeric_value(1.0)
  node.clear_min_numeric_value()
  @test.assert_eq(node.min_numeric_value(), None)
}

///|
test "max_numeric_value getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.max_numeric_value(), None)
}

///|
test "max_numeric_value setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_max_numeric_value(1.0)
  @test.assert_eq(node.max_numeric_value(), Some(1.0))
}

///|
test "max_numeric_value clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_max_numeric_value(1.0)
  node.clear_max_numeric_value()
  @test.assert_eq(node.max_numeric_value(), None)
}

///|
test "numeric_value_step getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.numeric_value_step(), None)
}

///|
test "numeric_value_step setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_numeric_value_step(1.0)
  @test.assert_eq(node.numeric_value_step(), Some(1.0))
}

///|
test "numeric_value_step clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_numeric_value_step(1.0)
  node.clear_numeric_value_step()
  @test.assert_eq(node.numeric_value_step(), None)
}

///|
test "numeric_value_jump getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.numeric_value_jump(), None)
}

///|
test "numeric_value_jump setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_numeric_value_jump(1.0)
  @test.assert_eq(node.numeric_value_jump(), Some(1.0))
}

///|
test "numeric_value_jump clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_numeric_value_jump(1.0)
  node.clear_numeric_value_jump()
  @test.assert_eq(node.numeric_value_jump(), None)
}
