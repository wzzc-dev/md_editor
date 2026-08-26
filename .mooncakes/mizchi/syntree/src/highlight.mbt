///| Syntax highlighting support for syntax trees

///|

///| Provides highlight token generation from parsed syntax trees.

// =============================================================================
// Highlight tags inspired by established syntax highlighters
// =============================================================================

///|
/// Standard highlight tags for syntax highlighting
pub(all) enum HighlightTag {
  // Keywords & Operators
  Keyword
  Operator
  Punctuation
  // Literals
  String
  Number
  Regexp // Regular expression literals
  Bool
  Null
  // Names
  PropertyName
  VariableName
  FunctionName
  TypeName
  ClassName
  PrivateName // #privateField
  // Meta
  Meta // @decorator
  // Structure
  Bracket
  Brace
  Paren
  // Comments & Documentation
  Comment
  DocComment
  // JSX/XML
  TagName // JSX/HTML tag name: div, span, MyComponent
  TagBracket // JSX/XML delimiters: < > /> </
  // Errors
  Invalid
  // No highlighting
  None
} derive(Eq, Show)

///|
/// Convert HighlightTag to CSS class name
pub fn HighlightTag::to_class(self : HighlightTag) -> String {
  match self {
    Keyword => "hl-keyword"
    Operator => "hl-operator"
    Punctuation => "hl-punctuation"
    String => "hl-string"
    Number => "hl-number"
    Regexp => "hl-regexp"
    Bool => "hl-bool"
    Null => "hl-null"
    PropertyName => "hl-property"
    VariableName => "hl-variable"
    FunctionName => "hl-function"
    TypeName => "hl-type"
    ClassName => "hl-class"
    PrivateName => "hl-private"
    Meta => "hl-meta"
    Bracket => "hl-bracket"
    Brace => "hl-brace"
    Paren => "hl-paren"
    Comment => "hl-comment"
    DocComment => "hl-doc-comment"
    TagName => "hl-tag"
    TagBracket => "hl-tag-bracket"
    Invalid => "hl-invalid"
    None => ""
  }
}

// =============================================================================
// Highlight Token
// =============================================================================

///|
/// A highlighted span of text
pub(all) struct HighlightToken {
  from : Int
  to : Int
  tag : HighlightTag
} derive(Eq, Show)

///|
/// Create a highlight token
pub fn HighlightToken::new(
  from : Int,
  to : Int,
  tag : HighlightTag,
) -> HighlightToken {
  { from, to, tag }
}

// =============================================================================
// Highlighter
// =============================================================================

///|
/// Highlighter configuration - maps node types to highlight tags
pub(all) struct Highlighter {
  /// Map from node type name to highlight tag
  rules : Map[String, HighlightTag]
}

///|
/// Create a new highlighter
pub fn Highlighter::new() -> Highlighter {
  { rules: {} }
}

///|
/// Add a highlighting rule
pub fn Highlighter::add_rule(
  self : Highlighter,
  node_name : String,
  tag : HighlightTag,
) -> Unit {
  self.rules[node_name] = tag
}

///|
/// Get highlight tag for a node type
pub fn Highlighter::get_tag(
  self : Highlighter,
  node_name : String,
) -> HighlightTag {
  match self.rules.get(node_name) {
    Some(tag) => tag
    _ => HighlightTag::None
  }
}

///|
/// Generate highlight tokens from a tree
pub fn Highlighter::highlight(
  self : Highlighter,
  tree : Tree,
) -> Array[HighlightToken] {
  let tokens : Array[HighlightToken] = []
  for node in tree.iter() {
    match node.node_type() {
      Some(nt) => {
        let tag = self.get_tag(nt.name)
        // Only add tokens for leaf nodes with a highlight tag
        match (tag, node) {
          (HighlightTag::None, _) => ()
          (_, Leaf(..)) =>
            tokens.push(HighlightToken::new(node.from(), node.to(), tag))
          (_, _) => ()
        }
      }
      _ => ()
    }
  }
  tokens
}

// =============================================================================
// HTML Generation
// =============================================================================

///|
/// Escape HTML special characters
pub fn escape_html(s : String) -> String {
  let result = StringBuilder::new()
  escape_html_to(s, result)
  result.to_string()
}

///|
/// Escape HTML special characters directly to StringBuilder (zero-alloc)
fn escape_html_to(s : String, buf : StringBuilder) -> Unit {
  for c in s {
    match c {
      '<' => buf.write_string("&lt;")
      '>' => buf.write_string("&gt;")
      '&' => buf.write_string("&amp;")
      '"' => buf.write_string("&quot;")
      _ => buf.write_char(c)
    }
  }
}

///|
/// Escape HTML from char slice directly to StringBuilder (zero-alloc)
pub fn escape_html_slice_to(
  chars : Array[Char],
  from : Int,
  to : Int,
  buf : StringBuilder,
) -> Unit {
  for i = from; i < to; i = i + 1 {
    match chars[i] {
      '<' => buf.write_string("&lt;")
      '>' => buf.write_string("&gt;")
      '&' => buf.write_string("&amp;")
      '"' => buf.write_string("&quot;")
      c => buf.write_char(c)
    }
  }
}

// =============================================================================
// Line Cache for Incremental Highlighting
// =============================================================================

///|
/// Line-based cache for incremental syntax highlighting
/// Works with any language by accepting a highlight function
pub(all) struct LineCache {
  /// Highlight tokens grouped by line
  lines : Array[Array[HighlightToken]]
  /// Start position of each line in source
  mut line_starts : Array[Int]
  /// Source text
  mut source : String
}

///|
/// Create a new line cache from source
pub fn LineCache::new(
  source : String,
  highlight_fn : (String) -> Array[HighlightToken],
) -> LineCache {
  let cache : LineCache = { lines: [], line_starts: [], source }
  cache.build_full(highlight_fn)
  cache
}

///|
/// Build line starts array from source
fn LineCache::compute_line_starts(source : String) -> Array[Int] {
  let starts : Array[Int] = [0] // First line starts at 0
  let chars = source.to_array()
  for i, c in chars {
    if c == '\n' && i + 1 < chars.length() {
      starts.push(i + 1)
    }
  }
  starts
}

///|
/// Find which line a position belongs to (binary search)
fn LineCache::find_line(self : LineCache, pos : Int) -> Int {
  let starts = self.line_starts
  let mut low = 0
  let mut high = starts.length() - 1
  while low < high {
    let mid = (low + high + 1) / 2
    if starts[mid] <= pos {
      low = mid
    } else {
      high = mid - 1
    }
  }
  low
}

///|
/// Build the full cache
fn LineCache::build_full(
  self : LineCache,
  highlight_fn : (String) -> Array[HighlightToken],
) -> Unit {
  self.lines.clear()
  self.line_starts = LineCache::compute_line_starts(self.source)
  let num_lines = self.line_starts.length()

  // Initialize empty lines
  for i = 0; i < num_lines; i = i + 1 {
    self.lines.push([])
  }

  // Tokenize and distribute to lines
  let tokens = highlight_fn(self.source)
  for token in tokens {
    let line = self.find_line(token.from)
    if line < self.lines.length() {
      self.lines[line].push(token)
    }
  }
}

///|
/// Get all tokens flattened
pub fn LineCache::all_tokens(self : LineCache) -> Array[HighlightToken] {
  let result : Array[HighlightToken] = []
  for line in self.lines {
    for token in line {
      result.push(token)
    }
  }
  result
}

///|
/// Get number of lines
pub fn LineCache::line_count(self : LineCache) -> Int {
  self.lines.length()
}

///|
/// Get tokens for a specific line
pub fn LineCache::get_line_tokens(
  self : LineCache,
  line : Int,
) -> Array[HighlightToken] {
  if line >= 0 && line < self.lines.length() {
    self.lines[line]
  } else {
    []
  }
}

///|
/// Get source text
pub fn LineCache::get_source(self : LineCache) -> String {
  self.source
}

///|
/// Update cache when source changes
/// Re-tokenizes from the edited line onwards
/// Returns the range of lines that were affected (start_line, end_line)
pub fn LineCache::update(
  self : LineCache,
  new_source : String,
  edit_line : Int,
  highlight_fn : (String) -> Array[HighlightToken],
) -> (Int, Int) {
  self.source = new_source
  let new_line_starts = LineCache::compute_line_starts(new_source)
  let new_num_lines = new_line_starts.length()

  // Determine the start position for re-tokenization
  let start_line = if edit_line > 0 { edit_line - 1 } else { 0 }
  let start_pos = if start_line < new_line_starts.length() {
    new_line_starts[start_line]
  } else {
    0
  }

  // Re-tokenize the entire source (simpler and more reliable)
  let tokens = highlight_fn(new_source)

  // Rebuild line_starts
  self.line_starts = new_line_starts

  // Truncate lines to start_line
  while self.lines.length() > start_line {
    let _ = self.lines.pop()

  }

  // Add new empty lines
  for i = self.lines.length(); i < new_num_lines; i = i + 1 {
    self.lines.push([])
  }

  // Distribute tokens to lines (only from start_line onwards)
  for token in tokens {
    if token.from >= start_pos {
      let line = self.find_line(token.from)
      if line < self.lines.length() {
        self.lines[line].push(token)
      }
    } else {
      // Token before edit region - keep in its original line
      let line = self.find_line(token.from)
      if line < start_line && line < self.lines.length() {
        // Already preserved, skip
        ()
      }
    }
  }
  (start_line, new_num_lines)
}

///|
/// Rebuild the entire cache with new source
pub fn LineCache::rebuild(
  self : LineCache,
  new_source : String,
  highlight_fn : (String) -> Array[HighlightToken],
) -> Unit {
  self.source = new_source
  self.build_full(highlight_fn)
}

///|
/// Generate highlighted HTML from source and tokens
/// Note: tokens are assumed to be already sorted by position (as produced by tokenizers)
pub fn tokens_to_html(
  source : String,
  tokens : Array[HighlightToken],
) -> String {
  let result = StringBuilder::new()
  let chars = source.to_array()
  let len = chars.length()
  let mut pos = 0

  // Tokens are already sorted by position from tokenizers, no need to copy/sort
  for token in tokens {
    // Add unhighlighted text before this token
    if token.from > pos {
      escape_html_slice_to(chars, pos, token.from, result)
    }

    // Add highlighted token
    let class_name = token.tag.to_class()
    if class_name != "" {
      result.write_string("<span class=\"")
      result.write_string(class_name)
      result.write_string("\">")
      escape_html_slice_to(chars, token.from, token.to, result)
      result.write_string("</span>")
    } else {
      escape_html_slice_to(chars, token.from, token.to, result)
    }
    pos = token.to
  }

  // Add remaining text
  if pos < len {
    escape_html_slice_to(chars, pos, len, result)
  }
  result.to_string()
}
