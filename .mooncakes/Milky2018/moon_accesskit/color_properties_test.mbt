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
test "color_value getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.color_value(), None)
}

///|
test "color_value setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_color_value(
    @moon_accesskit.Color(
      (255).to_byte(),
      (255).to_byte(),
      (255).to_byte(),
      (255).to_byte(),
    ),
  )
  @test.assert_eq(
    node.color_value(),
    Some(
      @moon_accesskit.Color(
        (255).to_byte(),
        (255).to_byte(),
        (255).to_byte(),
        (255).to_byte(),
      ),
    ),
  )
}

///|
test "color_value clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_color_value(
    @moon_accesskit.Color(
      (255).to_byte(),
      (255).to_byte(),
      (255).to_byte(),
      (255).to_byte(),
    ),
  )
  node.clear_color_value()
  @test.assert_eq(node.color_value(), None)
}

///|
test "background_color getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.background_color(), None)
}

///|
test "background_color setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_background_color(
    @moon_accesskit.Color(
      (255).to_byte(),
      (255).to_byte(),
      (255).to_byte(),
      (255).to_byte(),
    ),
  )
  @test.assert_eq(
    node.background_color(),
    Some(
      @moon_accesskit.Color(
        (255).to_byte(),
        (255).to_byte(),
        (255).to_byte(),
        (255).to_byte(),
      ),
    ),
  )
}

///|
test "background_color clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_background_color(
    @moon_accesskit.Color(
      (255).to_byte(),
      (255).to_byte(),
      (255).to_byte(),
      (255).to_byte(),
    ),
  )
  node.clear_background_color()
  @test.assert_eq(node.background_color(), None)
}

///|
test "foreground_color getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.foreground_color(), None)
}

///|
test "foreground_color setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_foreground_color(
    @moon_accesskit.Color(
      (255).to_byte(),
      (255).to_byte(),
      (255).to_byte(),
      (255).to_byte(),
    ),
  )
  @test.assert_eq(
    node.foreground_color(),
    Some(
      @moon_accesskit.Color(
        (255).to_byte(),
        (255).to_byte(),
        (255).to_byte(),
        (255).to_byte(),
      ),
    ),
  )
}

///|
test "foreground_color clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_foreground_color(
    @moon_accesskit.Color(
      (255).to_byte(),
      (255).to_byte(),
      (255).to_byte(),
      (255).to_byte(),
    ),
  )
  node.clear_foreground_color()
  @test.assert_eq(node.foreground_color(), None)
}
