///|
test "block counter recognizes the shared Markdown subset" {
  let source = "# Title\n\nParagraph **bold**.\n\n- item\n\n> quote\n\n```\ncode\n```\n"
  assert_eq(@cross_framework/md_editor_gpui/app.block_count(source), 5)
}

///|
test "sample is a non-empty Markdown document" {
  assert_true(@cross_framework/md_editor_gpui/app.SAMPLE.has_prefix("# "))
}
