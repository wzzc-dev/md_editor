///|
test "input mapping swaps newlines for the placeholder" {
  assert_eq(input_text_of_markdown("a\nb"), "a\u{E000}b")
  assert_eq(markdown_of_input_text("a\u{E000}b"), "a\nb")
}

///|
test "input mapping round-trips multi-line markdown" {
  let markdown = "```text\nlet ui = \"MoonBit\"\n```"
  assert_eq(markdown_of_input_text(input_text_of_markdown(markdown)), markdown)
}

///|
test "input mapping leaves single-line text unchanged" {
  let markdown = "# Heading **bold**"
  assert_eq(input_text_of_markdown(markdown), markdown)
  assert_eq(markdown_of_input_text(markdown), markdown)
}

///|
test "markdown source projection hides supported syntax" {
  let blocks = parse_markdown_blocks(
    "# **Title**\n\n- item\n\n[link](https://example.com)",
  )
  assert_eq(
    block_display_segments(blocks[0]).map(segment => segment.0).join(""),
    "Title",
  )
  assert_eq(
    block_display_segments(blocks[1]).map(segment => segment.0).join(""),
    "• item",
  )
  assert_eq(
    block_display_segments(blocks[2]).map(segment => segment.0).join(""),
    "link",
  )
}
