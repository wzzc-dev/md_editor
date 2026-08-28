///|
pub(all) enum BlockKind {
  Heading(Int)
  Paragraph
  ListItem
  Quote
  Code
} derive(Eq, Debug)

///|
pub(all) struct MarkdownBlock {
  id : Int
  kind : BlockKind
  markdown : String
} derive(Eq, Debug)

///|
fn push_block(
  blocks : Array[MarkdownBlock],
  kind : BlockKind,
  markdown : String,
) -> Unit {
  blocks.push({ id: blocks.length(), kind, markdown })
}

///|
fn heading_level(value : String) -> Int? {
  let chars = value.to_array()
  let mut count = 0
  while count < chars.length() && chars[count] == '#' {
    count += 1
  }
  if count > 0 && count <= 6 && count < chars.length() && chars[count] == ' ' {
    Some(count)
  } else {
    None
  }
}

///|
fn classify_single_block(value : String) -> BlockKind {
  let trimmed = value.trim().to_owned()
  if trimmed.has_prefix("```") {
    Code
  } else {
    match heading_level(trimmed) {
      Some(level) => Heading(level)
      None =>
        if trimmed.has_prefix("> ") {
          Quote
        } else if trimmed.has_prefix("- ") || trimmed.has_prefix("* ") {
          ListItem
        } else {
          Paragraph
        }
    }
  }
}

///|
pub fn parse_markdown_blocks(source : String) -> Array[MarkdownBlock] {
  let blocks : Array[MarkdownBlock] = []
  let paragraph : Array[String] = []
  let code : Array[String] = []
  let mut in_code = false
  let flush_paragraph = fn() {
    if !paragraph.is_empty() {
      push_block(blocks, Paragraph, paragraph.join(" "))
      paragraph.clear()
    }
  }
  for raw in source.split("\n") {
    let line = raw.trim_end().to_owned()
    let value = line.trim().to_owned()
    if value.has_prefix("```") {
      if in_code {
        code.push(line)
        push_block(blocks, Code, code.join("\n"))
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
    } else {
      match heading_level(value) {
        Some(level) => {
          flush_paragraph()
          push_block(blocks, Heading(level), value)
        }
        None =>
          if value.has_prefix("> ") {
            flush_paragraph()
            push_block(blocks, Quote, value)
          } else if value.has_prefix("- ") || value.has_prefix("* ") {
            flush_paragraph()
            push_block(blocks, ListItem, value)
          } else {
            paragraph.push(value)
          }
      }
    }
  }
  if !code.is_empty() {
    push_block(blocks, Code, code.join("\n"))
  }
  flush_paragraph()
  if blocks.is_empty() {
    push_block(blocks, Paragraph, "")
  }
  blocks
}

///|
pub fn serialize_markdown_blocks(blocks : Array[MarkdownBlock]) -> String {
  blocks.map(block => block.markdown).join("\n\n") + "\n"
}

///|
fn visible_markdown(block : MarkdownBlock) -> String {
  match block.kind {
    Heading(level) => block.markdown[level + 1:].to_owned()
    ListItem => "• " + block.markdown[2:].to_owned()
    Quote => block.markdown[2:].to_owned()
    Code => {
      let lines = block.markdown
        .split("\n")
        .map(line => line.to_owned())
        .to_array()
      if lines.length() >= 2 {
        let end = if lines[lines.length() - 1].trim().has_prefix("```") {
          lines.length() - 1
        } else {
          lines.length()
        }
        if end > 1 {
          lines[1:end].to_owned().join("\n")
        } else {
          ""
        }
      } else {
        block.markdown
      }
    }
    Paragraph => block.markdown
  }
}

///|
fn inline_runs(value : String) -> Array[(String, @gpui.RunStyle?)] {
  let chars = value.to_array()
  let runs : Array[(String, @gpui.RunStyle?)] = []
  let plain : Array[Char] = []
  let flush_plain = fn() {
    if !plain.is_empty() {
      runs.push((String::from_array(plain), None))
      plain.clear()
    }
  }
  let mut index = 0
  while index < chars.length() {
    let marker_length = if index + 1 < chars.length() &&
      chars[index] == '*' &&
      chars[index + 1] == '*' {
      2
    } else if chars[index] == '*' || chars[index] == '`' {
      1
    } else {
      0
    }
    if marker_length == 0 {
      plain.push(chars[index])
      index += 1
      continue
    }
    let mut closing = index + marker_length
    while closing + marker_length <= chars.length() {
      let matched = if marker_length == 2 {
        chars[closing] == '*' && chars[closing + 1] == '*'
      } else {
        chars[closing] == chars[index]
      }
      if matched {
        break
      }
      closing += 1
    }
    if closing + marker_length > chars.length() ||
      closing == index + marker_length {
      plain.push(chars[index])
      index += 1
      continue
    }
    flush_plain()
    let content = String::from_array(chars[index + marker_length:closing])
    let style = if marker_length == 2 {
      @gpui.RunStyle::new(weight=700)
    } else if chars[index] == '*' {
      @gpui.RunStyle::new(italic=true)
    } else {
      @gpui.RunStyle::new(
        color=@gpui.Color::rgb(143, 63, 113),
        background=@gpui.Color::rgb(240, 242, 244),
      )
    }
    runs.push((content, Some(style)))
    index = closing + marker_length
  }
  flush_plain()
  runs
}

///|
fn replace_block(
  blocks : Array[MarkdownBlock],
  index : Int,
  markdown : String,
) -> Unit {
  if index >= 0 && index < blocks.length() {
    blocks[index] = {
      id: index,
      kind: classify_single_block(markdown),
      markdown,
    }
  }
}
