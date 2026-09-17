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
  // Single pass over one char-array decode of the source. The previous
  // split("\n")-based scan
  // (split + trim_end + trim + to_owned), which on the 5MB stress fixture
  // cost ~300 ms of allocation/GC churn before the first frame.
  let chars = source.to_array()
  let n = chars.length()
  let blocks : Array[MarkdownBlockItem] = []
  let paragraph : StringBuilder = StringBuilder()
  let paragraph_len : Ref[Int] = Ref(0)
  let code : StringBuilder = StringBuilder()
  let code_lines : Ref[Int] = Ref(0)
  let mut in_code = false
  let mut first_para_line = true
  let mut first_code_line = true
  let flush_paragraph = fn() {
    if paragraph_len.val > 0 {
      push_markdown_block(blocks, paragraph.to_string())
      paragraph.reset()
      paragraph_len.val = 0
      first_para_line = true
    }
  }
  let push_line_to_code = fn(text : String) {
    if first_code_line {
      first_code_line = false
    } else {
      code.write_char('\n')
    }
    code.write_string(text)
    code_lines.val = code_lines.val + 1
  }
  let mut i = 0
  while i <= n {
    // Find the line end and the trimmed range in one scan.
    let line_end = if i == n {
      n
    } else if chars[i] == '\n' {
      i
    } else {
      let mut j = i
      while j < n && chars[j] != '\n' {
        j = j + 1
      }
      j
    }
    let had_newline = line_end < n
    let line_break = if line_end < n { line_end + 1 } else { n }
    // trim_end: strip trailing whitespace from [i, line_end)
    let mut t_end = line_end
    while t_end > i && chars[t_end - 1].is_whitespace() {
      t_end = t_end - 1
    }
    // trim: strip leading whitespace from [i, t_end)
    let mut v_start = i
    while v_start < t_end && chars[v_start].is_whitespace() {
      v_start = v_start + 1
    }
    let value_len = t_end - v_start
    let is_fence = value_len >= 3 &&
      chars[v_start] == '`' &&
      chars[v_start + 1] == '`' &&
      chars[v_start + 2] == '`'
    if is_fence {
      let fence_text = {
        let sb = StringBuilder()
        for k = v_start; k < t_end; k = k + 1 {
          sb.write_char(chars[k])
        }
        sb.to_string()
      }
      if in_code {
        push_line_to_code(fence_text)
        push_markdown_block(blocks, code.to_string())
        code.reset()
        code_lines.val = 0
        first_code_line = true
      } else {
        flush_paragraph()
        push_line_to_code(fence_text)
      }
      in_code = !in_code
    } else if in_code {
      // Code lines keep the trim_end form.
      let line_text = {
        let sb = StringBuilder()
        for k = i; k < t_end; k = k + 1 {
          sb.write_char(chars[k])
        }
        sb.to_string()
      }
      push_line_to_code(line_text)
    } else if value_len == 0 {
      flush_paragraph()
    } else {
      let is_structural = chars[v_start] == '#' ||
        (value_len >= 2 &&
        chars[v_start] == '>' &&
        chars[v_start + 1] == ' ') ||
        (value_len >= 2 &&
        chars[v_start] == '-' &&
        chars[v_start + 1] == ' ') ||
        (value_len >= 2 &&
        chars[v_start] == '*' &&
        chars[v_start + 1] == ' ')
      if is_structural {
        flush_paragraph()
        let structural_text = {
          let sb = StringBuilder()
          for k = v_start; k < t_end; k = k + 1 {
            sb.write_char(chars[k])
          }
          sb.to_string()
        }
        push_markdown_block(blocks, structural_text)
      } else {
        // Paragraph line: join lines with a single space, matching the
        // original `paragraph.join(" ")` semantics.
        if !first_para_line {
          paragraph.write_char(' ')
        }
        for k = v_start; k < t_end; k = k + 1 {
          paragraph.write_char(chars[k])
        }
        paragraph_len.val = paragraph_len.val + 1
        first_para_line = false
      }
    }
    i = line_break
    if i == n && !had_newline {
      break
    }
  }
  if in_code && code_lines.val > 0 {
    push_markdown_block(blocks, code.to_string())
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
