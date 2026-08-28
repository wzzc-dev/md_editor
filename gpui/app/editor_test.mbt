///|
test "block parser recognizes the shared Markdown subset" {
  let source = "# Title\n\nParagraph **bold**.\n\n- item\n\n> quote\n\n```\ncode\n```\n"
  let blocks = @cross_framework/md_editor_gpui/app.parse_markdown_blocks(source)
  assert_eq(blocks.length(), 5)
  assert_true(blocks[0].kind is Heading(1))
  assert_true(blocks[2].kind is ListItem)
  assert_true(blocks[4].kind is Code)
}

///|
test "block serialization preserves editable Markdown" {
  let source = "# First\n\nSecond"
  let blocks = @cross_framework/md_editor_gpui/app.parse_markdown_blocks(source)
  assert_eq(
    @cross_framework/md_editor_gpui/app.serialize_markdown_blocks(blocks),
    "# First\n\nSecond\n",
  )
}

///|
test "sample is a non-empty Markdown document" {
  assert_true(@cross_framework/md_editor_gpui/app.SAMPLE.has_prefix("# "))
}
