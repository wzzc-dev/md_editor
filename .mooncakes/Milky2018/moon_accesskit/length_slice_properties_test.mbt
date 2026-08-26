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
test "character_lengths getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.character_lengths(), [])
}

///|
test "character_lengths setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_character_lengths([])
  @test.assert_eq(node.character_lengths(), [])
  node.set_character_lengths([1, 2])
  @test.assert_eq(node.character_lengths(), [1, 2])
}

///|
test "character_lengths clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_character_lengths([1, 2])
  node.clear_character_lengths()
  @test.assert_eq(node.character_lengths(), [])
}

///|
test "word_starts getter should return default value" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.word_starts(), [])
}

///|
test "word_starts setter should update the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_word_starts([])
  @test.assert_eq(node.word_starts(), [])
  node.set_word_starts([1, 2])
  @test.assert_eq(node.word_starts(), [1, 2])
}

///|
test "word_starts clearer should reset the property" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.set_word_starts([1, 2])
  node.clear_word_starts()
  @test.assert_eq(node.word_starts(), [])
}
