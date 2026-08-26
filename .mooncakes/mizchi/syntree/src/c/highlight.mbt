///| C syntax highlighting

// =============================================================================
// C Highlighter
// =============================================================================

///|
/// Create a highlighter configured for C
pub fn c_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()

  // Keywords
  h.add_rule("Keyword", Keyword)
  h.add_rule("TypeKeyword", TypeName)
  h.add_rule("StorageClass", Keyword)

  // Identifiers
  h.add_rule("Identifier", VariableName)
  h.add_rule("TypeName", TypeName)

  // Literals
  h.add_rule("Number", Number)
  h.add_rule("String", String)
  h.add_rule("Char", String)

  // Preprocessor
  h.add_rule("Preprocessor", Meta)
  h.add_rule("Include", String)

  // Operators
  h.add_rule("Operator", Operator)
  h.add_rule("Assignment", Operator)
  h.add_rule("Comparison", Operator)
  h.add_rule("Logical", Operator)
  h.add_rule("Bitwise", Operator)
  h.add_rule("Arrow", Operator)
  h.add_rule("Dot", Operator)
  h.add_rule("Increment", Operator)
  h.add_rule("Ternary", Operator)

  // Punctuation
  h.add_rule("Semicolon", Punctuation)
  h.add_rule("Comma", Punctuation)
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
fn token_type_name(t : CTokenType) -> String {
  match t {
    Keyword => "Keyword"
    TypeKeyword => "TypeKeyword"
    StorageClass => "StorageClass"
    Identifier => "Identifier"
    TypeName => "TypeName"
    Number => "Number"
    String => "String"
    Char => "Char"
    Preprocessor => "Preprocessor"
    Include => "Include"
    Operator => "Operator"
    Assignment => "Assignment"
    Comparison => "Comparison"
    Logical => "Logical"
    Bitwise => "Bitwise"
    Arrow => "Arrow"
    Dot => "Dot"
    Increment => "Increment"
    Ternary => "Ternary"
    Semicolon => "Semicolon"
    Comma => "Comma"
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
/// Highlight C source code
pub fn highlight_c(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = CTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = c_highlighter()
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
/// Convenience: highlight C and generate simple HTML output
pub fn highlight_c_to_html(source : String) -> String {
  let tokens = highlight_c(source)
  @syntree.tokens_to_html(source, tokens)
}
