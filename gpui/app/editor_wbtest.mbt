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
