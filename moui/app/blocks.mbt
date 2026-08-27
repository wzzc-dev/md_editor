///|
pub(all) struct MarkdownBlockItem {
  id : Int
  markdown : String
} derive(Eq, Debug)

///|
fn push_markdown_block(
  blocks : Array[MarkdownBlockItem],
  markdown : String,
) -> Unit {
  blocks.push({ id: blocks.length(), markdown })
}

///|
pub fn parse_markdown_blocks(source : String) -> Array[MarkdownBlockItem] {
  let blocks : Array[MarkdownBlockItem] = []
  let paragraph : Array[String] = []
  let code : Array[String] = []
  let mut in_code = false
  let flush_paragraph = fn() {
    if !paragraph.is_empty() {
      push_markdown_block(blocks, paragraph.join(" "))
      paragraph.clear()
    }
  }
  for raw in source.split("\n") {
    let line = raw.to_owned().trim_end().to_owned()
    let value = line.trim().to_owned()
    if value.has_prefix("```") {
      if in_code {
        code.push(line)
        push_markdown_block(blocks, code.join("\n"))
        code.clear()
      } else {
        flush_paragraph()
        code.push(line)
      }
      in_code = !in_code
    } else if in_code {
      code.push(line)
    } else if value == "" {
      flush_paragraph()
    } else if value.has_prefix("#") ||
      value.has_prefix("> ") ||
      value.has_prefix("- ") ||
      value.has_prefix("* ") {
      flush_paragraph()
      push_markdown_block(blocks, value)
    } else {
      paragraph.push(value)
    }
  }
  if in_code && !code.is_empty() {
    push_markdown_block(blocks, code.join("\n"))
  }
  flush_paragraph()
  if blocks.is_empty() {
    push_markdown_block(blocks, "")
  }
  blocks
}

///|
pub fn serialize_markdown_blocks(blocks : Array[MarkdownBlockItem]) -> String {
  blocks.map(block => block.markdown).join("\n\n") + "\n"
}

///|
fn update_markdown_block(
  blocks : Array[MarkdownBlockItem],
  index : Int,
  markdown : String,
) -> Unit {
  if index >= 0 && index < blocks.length() {
    blocks[index] = { id: index, markdown }
  }
}
