///| Go syntax highlighting

// =============================================================================
// Go Highlighter
// =============================================================================

///|
/// Create a highlighter configured for Go
pub fn go_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()

  // Keywords
  h.add_rule("Keyword", Keyword)
  h.add_rule("TypeKeyword", TypeName)
  h.add_rule("DeclKeyword", Keyword)

  // Identifiers
  h.add_rule("Identifier", VariableName)
  h.add_rule("TypeName", TypeName)
  h.add_rule("PackageName", VariableName)

  // Literals
  h.add_rule("Number", Number)
  h.add_rule("String", String)
  h.add_rule("Rune", String)

  // Operators
  h.add_rule("Operator", Operator)
  h.add_rule("Assignment", Operator)
  h.add_rule("Comparison", Operator)
  h.add_rule("Logical", Operator)
  h.add_rule("Bitwise", Operator)
  h.add_rule("Arrow", Operator)
  h.add_rule("Ellipsis", Operator)

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

  // Comments
  h.add_rule("LineComment", Comment)
  h.add_rule("BlockComment", Comment)
  h
}

///|
/// Convert token type to string for highlighter lookup
fn token_type_name(t : GoTokenType) -> String {
  match t {
    Keyword => "Keyword"
    TypeKeyword => "TypeKeyword"
    DeclKeyword => "DeclKeyword"
    Identifier => "Identifier"
    TypeName => "TypeName"
    PackageName => "PackageName"
    Number => "Number"
    String => "String"
    Rune => "Rune"
    Operator => "Operator"
    Assignment => "Assignment"
    Comparison => "Comparison"
    Logical => "Logical"
    Bitwise => "Bitwise"
    Arrow => "Arrow"
    Ellipsis => "Ellipsis"
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
    LineComment => "LineComment"
    BlockComment => "BlockComment"
    Error => "Error"
  }
}

///|
/// Highlight Go source code
pub fn highlight_go(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = GoTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = go_highlighter()
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
/// Convenience: highlight Go and generate simple HTML output
pub fn highlight_go_to_html(source : String) -> String {
  let tokens = highlight_go(source)
  @syntree.tokens_to_html(source, tokens)
}
