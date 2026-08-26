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
test "node debug should omit empty fields" {
  let node = @moon_accesskit.Node(Role::Unknown)
  @test.assert_eq(node.debug(), "Node { role: Unknown }")
}

///|
test "node debug should include present properties in order" {
  let node = @moon_accesskit.Node(Role::Unknown)
  node.add_action(Action::Click)
  node.add_child_action(Action::ScrollIntoView)
  node.set_required()
  node.set_controls([@moon_accesskit.NodeId(1UL)])
  node.set_error_message(@moon_accesskit.NodeId(2UL))
  node.set_label("hello")
  node.set_scroll_x(1.0)
  node.set_font_size(2.0F)
  node.set_row_count(3)
  node.set_color_value(
    @moon_accesskit.Color(
      (255).to_byte(),
      (255).to_byte(),
      (255).to_byte(),
      (255).to_byte(),
    ),
  )
  node.set_underline(
    TextDecoration::TextDecoration(
      TextDecorationStyle::Dotted,
      @moon_accesskit.Color(
        (0).to_byte(),
        (0).to_byte(),
        (0).to_byte(),
        (255).to_byte(),
      ),
    ),
  )
  node.set_character_lengths([1, 2])
  node.set_character_positions([1.0, 2.0])
  node.set_expanded(true)
  node.set_invalid(Invalid::Grammar)
  node.set_transform(Affine::scale(1.0))
  node.set_bounds(Rect::Rect(0.0, 1.0, 2.0, 3.0))
  node.set_text_selection(
    @moon_accesskit.TextSelection(
      @moon_accesskit.TextPosition(@moon_accesskit.NodeId(0UL), 0),
      @moon_accesskit.TextPosition(@moon_accesskit.NodeId(0UL), 2),
    ),
  )
  node.set_tree_id(@moon_accesskit.TreeId(Uuid::nil()))
  node.push_custom_action(@moon_accesskit.CustomAction(0, "test action"))
  @test.assert_eq(
    node.debug(),
    "Node { role: Unknown, actions: [Click], child_actions: [ScrollIntoView], is_required: true, controls: [#1], error_message: #2, label: \"hello\", scroll_x: 1.0, font_size: 2.0, row_count: 3, color_value: Color { red: 255, green: 255, blue: 255, alpha: 255 }, underline: TextDecoration { style: Dotted, color: Color { red: 0, green: 0, blue: 0, alpha: 255 } }, character_lengths: [1, 2], character_positions: [1.0, 2.0], is_expanded: true, invalid: Grammar, transform: Affine::Affine([1.0, 0.0, 0.0, 1.0, 0.0, 0.0]), bounds: Rect { x0: 0.0, y0: 1.0, x1: 2.0, y1: 3.0 }, text_selection: TextSelection { anchor: TextPosition { node: #0, character_index: 0 }, focus: TextPosition { node: #0, character_index: 2 } }, tree_id: TreeId(00000000-0000-0000-0000-000000000000), custom_actions: [CustomAction { id: 0, description: \"test action\" }] }",
  )
}
