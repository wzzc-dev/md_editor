///| Zig syntax highlighting

// =============================================================================
// Zig Highlighter
// =============================================================================

///|
/// Create a highlighter configured for Zig
pub fn zig_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()

  // Keywords
  h.add_rule("Keyword", Keyword)
  h.add_rule("TypeKeyword", TypeName)
  h.add_rule("Builtin", Meta)

  // Identifiers
  h.add_rule("Identifier", VariableName)
  h.add_rule("TypeName", TypeName)

  // Literals
  h.add_rule("Number", Number)
  h.add_rule("String", String)
  h.add_rule("MultilineString", String)
  h.add_rule("Char", String)

  // Operators
  h.add_rule("Operator", Operator)
  h.add_rule("Assignment", Operator)
  h.add_rule("Comparison", Operator)
  h.add_rule("Arrow", Operator)
  h.add_rule("Optional", Operator)
  h.add_rule("ErrorUnion", Operator)
  h.add_rule("Pointer", Operator)
  h.add_rule("Range", Operator)

  // Punctuation
  h.add_rule("Semicolon", Punctuation)
  h.add_rule("Comma", Punctuation)
  h.add_rule("Colon", Punctuation)
  h.add_rule("Dot", Punctuation)
  h.add_rule("ParenOpen", Paren)
  h.add_rule("ParenClose", Paren)
  h.add_rule("BraceOpen", Brace)
  h.add_rule("BraceClose", Brace)
  h.add_rule("BracketOpen", Bracket)
  h.add_rule("BracketClose", Bracket)
  h.add_rule("Pipe", Operator)

  // Comments
  h.add_rule("LineComment", Comment)
  h.add_rule("DocComment", DocComment)
  h
}

///|
/// Convert token type to string for highlighter lookup
fn token_type_name(t : ZigTokenType) -> String {
  match t {
    Keyword => "Keyword"
    TypeKeyword => "TypeKeyword"
    Builtin => "Builtin"
    Identifier => "Identifier"
    TypeName => "TypeName"
    Number => "Number"
    String => "String"
    MultilineString => "MultilineString"
    Char => "Char"
    Operator => "Operator"
    Assignment => "Assignment"
    Comparison => "Comparison"
    Arrow => "Arrow"
    Optional => "Optional"
    ErrorUnion => "ErrorUnion"
    Pointer => "Pointer"
    Range => "Range"
    Semicolon => "Semicolon"
    Comma => "Comma"
    Colon => "Colon"
    Dot => "Dot"
    ParenOpen => "ParenOpen"
    ParenClose => "ParenClose"
    BraceOpen => "BraceOpen"
    BraceClose => "BraceClose"
    BracketOpen => "BracketOpen"
    BracketClose => "BracketClose"
    Pipe => "Pipe"
    LineComment => "LineComment"
    DocComment => "DocComment"
    Error => "Error"
  }
}

///|
/// Highlight Zig source code
pub fn highlight_zig(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = ZigTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = zig_highlighter()
  let result : Array[@syntree.HighlightToken] = []
  for token in tokens {
    let name = token_type_name(token.token_type)
    let tag = highlighter.get_tag(name)
    if tag != @syntree.HighlightTag::None {
      result.push(@syntree.HighlightToken::new(token.from, token.to, tag))
    }
  }
  result
}

///|
/// Convenience: highlight Zig and generate simple HTML output
pub fn highlight_zig_to_html(source : String) -> String {
  let tokens = highlight_zig(source)
  @syntree.tokens_to_html(source, tokens)
}
