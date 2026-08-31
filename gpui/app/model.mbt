///|
pub(all) enum BlockKind {
  Heading(Int)
  Paragraph
  ListItem
  OrderedListItem
  TaskListItem(Bool)
  Quote
  Code
  Divider
} derive(Eq, Debug)

///|
pub(all) struct MarkdownBlock {
  id : Int
  kind : BlockKind
  markdown : String
} derive(Eq, Debug)

///|
priv struct InlineSegment {
  source : String
  display : String
  style : @gpui.RunStyle?
}

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
fn ordered_marker_length(value : String) -> Int? {
  let chars = value.to_array()
  let mut index = 0
  while index < chars.length() && chars[index] >= '0' && chars[index] <= '9' {
    index += 1
  }
  if index > 0 &&
    index + 1 < chars.length() &&
    chars[index] == '.' &&
    chars[index + 1] == ' ' {
    Some(index + 2)
  } else {
    None
  }
}

///|
fn task_marker(value : String) -> (Bool, Int)? {
  if value.has_prefix("- [ ] ") {
    Some((false, 6))
  } else if value.has_prefix("- [x] ") || value.has_prefix("- [X] ") {
    Some((true, 6))
  } else {
    None
  }
}

///|
fn is_divider(value : String) -> Bool {
  value == "---" || value == "***" || value == "___"
}

///|
fn classify_single_block(value : String) -> BlockKind {
  let trimmed = value.trim().to_owned()
  if trimmed.has_prefix("```") {
    Code
  } else if is_divider(trimmed) {
    Divider
  } else {
    match heading_level(trimmed) {
      Some(level) => Heading(level)
      None =>
        if trimmed.has_prefix("> ") {
          Quote
        } else {
          match task_marker(trimmed) {
            Some((checked, _)) => TaskListItem(checked)
            None =>
              match ordered_marker_length(trimmed) {
                Some(_) => OrderedListItem
                None =>
                  if trimmed.has_prefix("- ") || trimmed.has_prefix("* ") {
                    ListItem
                  } else {
                    Paragraph
                  }
              }
          }
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
      let kind = classify_single_block(value)
      match kind {
        Heading(_)
        | Quote
        | ListItem
        | OrderedListItem
        | TaskListItem(_)
        | Divider => {
          flush_paragraph()
          push_block(blocks, kind, value)
        }
        Paragraph => paragraph.push(value)
        Code => paragraph.push(value)
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
fn inline_segment(
  source : String,
  display : String,
  style : @gpui.RunStyle?,
) -> InlineSegment {
  { source, display, style }
}

///|
fn marker_at(
  chars : Array[Char],
  index : Int,
  marker : Char,
  length : Int,
) -> Bool {
  index + length <= chars.length() &&
  chars[index] == marker &&
  (length == 1 || chars[index + 1] == marker)
}

///|
fn find_marker(
  chars : Array[Char],
  start : Int,
  marker : Char,
  length : Int,
) -> Int? {
  let mut index = start
  while index + length <= chars.length() {
    if marker_at(chars, index, marker, length) {
      return Some(index)
    }
    index += 1
  }
  None
}

///|
fn is_inline_marker(value : Char) -> Bool {
  value == '*' || value == '_' || value == '~' || value == '`' || value == '['
}

///|
fn bold_style() -> @gpui.RunStyle {
  @gpui.RunStyle::new(weight=700)
}

///|
fn italic_style() -> @gpui.RunStyle {
  @gpui.RunStyle::new(italic=true)
}

///|
fn strike_style() -> @gpui.RunStyle {
  @gpui.RunStyle::new(strikethrough=true)
}

///|
fn code_style() -> @gpui.RunStyle {
  @gpui.RunStyle::new(
    color=@gpui.Color::rgb(143, 63, 113),
    background=@gpui.Color::rgb(240, 242, 244),
  )
}

///|
fn link_style() -> @gpui.RunStyle {
  @gpui.RunStyle::new(color=@gpui.Color::rgb(38, 95, 170), underline=true)
}

///|
fn inline_segments(value : String) -> Array[InlineSegment] {
  let chars = value.to_array()
  let segments : Array[InlineSegment] = []
  let plain : Array[Char] = []
  let flush_plain = fn() {
    if !plain.is_empty() {
      let text = String::from_array(plain)
      segments.push(inline_segment(text, text, None))
      plain.clear()
    }
  }
  let mut index = 0
  while index < chars.length() {
    if chars[index] == '\\' &&
      index + 1 < chars.length() &&
      is_inline_marker(chars[index + 1]) {
      flush_plain()
      segments.push(
        inline_segment(String::from_array(chars[index:index + 1]), "", None),
      )
      let escaped = String::from_array(chars[index + 1:index + 2])
      segments.push(inline_segment(escaped, escaped, None))
      index += 2
      continue
    }

    // Links remain source-preserving while only their label is painted.
    if chars[index] == '[' {
      let mut label_end = index + 1
      while label_end < chars.length() && chars[label_end] != ']' {
        label_end += 1
      }
      if label_end < chars.length() &&
        label_end + 1 < chars.length() &&
        chars[label_end + 1] == '(' {
        let mut url_end = label_end + 2
        while url_end < chars.length() && chars[url_end] != ')' {
          url_end += 1
        }
        if url_end < chars.length() {
          flush_plain()
          segments.push(inline_segment("[", "", None))
          let label = String::from_array(chars[index + 1:label_end])
          segments.push(inline_segment(label, label, Some(link_style())))
          segments.push(
            inline_segment(
              String::from_array(chars[label_end:url_end + 1]),
              "",
              None,
            ),
          )
          index = url_end + 1
          continue
        }
      }
    }

    let (marker, length, style) = if marker_at(chars, index, '*', 2) {
      ('*', 2, Some(bold_style()))
    } else if marker_at(chars, index, '_', 2) {
      ('_', 2, Some(bold_style()))
    } else if marker_at(chars, index, '~', 2) {
      ('~', 2, Some(strike_style()))
    } else if chars[index] == '*' || chars[index] == '_' {
      (chars[index], 1, Some(italic_style()))
    } else if chars[index] == '`' {
      ('`', 1, Some(code_style()))
    } else {
      ('\u{0}', 0, None)
    }
    if length == 0 {
      plain.push(chars[index])
      index += 1
      continue
    }
    match find_marker(chars, index + length, marker, length) {
      Some(closing) if closing > index + length => {
        flush_plain()
        let open = String::from_array(chars[index:index + length])
        segments.push(inline_segment(open, "", None))
        let content = String::from_array(chars[index + length:closing])
        segments.push(inline_segment(content, content, style))
        let close = String::from_array(chars[closing:closing + length])
        segments.push(inline_segment(close, "", None))
        index = closing + length
      }
      _ => {
        plain.push(chars[index])
        index += 1
      }
    }
  }
  flush_plain()
  segments
}

///|
fn append_inline_segments(
  target : Array[InlineSegment],
  additions : Array[InlineSegment],
) -> Unit {
  for segment in additions {
    target.push(segment)
  }
}

///|
fn code_segments(value : String) -> Array[InlineSegment] {
  let lines = value.split("\n").to_array()
  if lines.length() < 2 {
    return inline_segments(value)
  }
  let segments : Array[InlineSegment] = []
  let last = lines.length() - 1
  for index in 0..<lines.length() {
    let line = lines[index].to_owned()
    let display = if index == 0 ||
      (index == last && line.trim().has_prefix("```")) {
      ""
    } else {
      line + (if index < last { " ↵" } else { "" })
    }
    segments.push(inline_segment(line, display, None))
    if index < last {
      segments.push(inline_segment("\n", "", None))
    }
  }
  segments
}

///|
fn block_segments(block : MarkdownBlock) -> Array[InlineSegment] {
  match block.kind {
    Heading(level) => {
      let prefix_length = level + 1
      let segments = [
        inline_segment(block.markdown[:prefix_length].to_owned(), "", None),
      ]
      append_inline_segments(
        segments,
        inline_segments(block.markdown[prefix_length:].to_owned()),
      )
      segments
    }
    ListItem => {
      let segments = [
        inline_segment(block.markdown[:2].to_owned(), "• ", None),
      ]
      append_inline_segments(
        segments,
        inline_segments(block.markdown[2:].to_owned()),
      )
      segments
    }
    OrderedListItem => {
      let prefix_length = ordered_marker_length(block.markdown).unwrap_or(0)
      let segments = [
        inline_segment(
          block.markdown[:prefix_length].to_owned(),
          block.markdown[:prefix_length].to_owned(),
          None,
        ),
      ]
      append_inline_segments(
        segments,
        inline_segments(block.markdown[prefix_length:].to_owned()),
      )
      segments
    }
    TaskListItem(checked) => {
      let marker = if checked { "☑ " } else { "☐ " }
      let segments = [
        inline_segment(block.markdown[:6].to_owned(), marker, None),
      ]
      append_inline_segments(
        segments,
        inline_segments(block.markdown[6:].to_owned()),
      )
      segments
    }
    Quote => {
      let segments = [
        inline_segment(block.markdown[:2].to_owned(), "│ ", None),
      ]
      append_inline_segments(
        segments,
        inline_segments(block.markdown[2:].to_owned()),
      )
      segments
    }
    Divider =>
      [
        inline_segment(
          block.markdown,
          "────────────────",
          None,
        ),
      ]
    Code => code_segments(block.markdown)
    Paragraph => inline_segments(block.markdown)
  }
}

///|
fn block_display_segments(
  block : MarkdownBlock,
) -> Array[(String, @gpui.RunStyle?)] {
  block_segments(block).map(segment => (segment.display, segment.style))
}

///|
fn block_projection(
  block : MarkdownBlock,
) -> Array[@gpui.InputProjectionSegment] {
  block_segments(block).map(segment => {
    let source = input_text_of_markdown(segment.source)
    match segment.style {
      Some(style) =>
        @gpui.InputProjectionSegment::styled(source, segment.display, style)
      None => @gpui.InputProjectionSegment::new(source, segment.display)
    }
  })
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
