///| Swift syntax highlighting

// =============================================================================
// Swift Highlighter
// =============================================================================

///|
/// Create a highlighter configured for Swift
pub fn swift_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()

  // Keywords
  h.add_rule("Keyword", Keyword)
  h.add_rule("DeclKeyword", Keyword)
  h.add_rule("Modifier", Keyword)
  h.add_rule("Bool", Bool)

  // Literals
  h.add_rule("String", String)
  h.add_rule("MultilineString", String)
  h.add_rule("StringInterp", String)
  h.add_rule("Number", Number)

  // Identifiers
  h.add_rule("Identifier", VariableName)
  h.add_rule("TypeName", TypeName)
  h.add_rule("Attribute", Meta)

  // Operators
  h.add_rule("Operator", Operator)
  h.add_rule("Comparison", Operator)
  h.add_rule("Assignment", Operator)
  h.add_rule("Logical", Operator)
  h.add_rule("Range", Operator)
  h.add_rule("Optional", Operator)
  h.add_rule("Arrow", Operator)

  // Delimiters
  h.add_rule("ParenOpen", Paren)
  h.add_rule("ParenClose", Paren)
  h.add_rule("BracketOpen", Bracket)
  h.add_rule("BracketClose", Bracket)
  h.add_rule("BraceOpen", Brace)
  h.add_rule("BraceClose", Brace)
  h.add_rule("Comma", Punctuation)
  h.add_rule("Colon", Punctuation)
  h.add_rule("Semicolon", Punctuation)
  h.add_rule("Dot", Punctuation)

  // Comments
  h.add_rule("LineComment", Comment)
  h.add_rule("BlockComment", Comment)
  h.add_rule("DocComment", DocComment)
  h
}

///|
/// Convert token type to string for highlighter lookup
fn token_type_name(t : SwiftTokenType) -> String {
  match t {
    Keyword => "Keyword"
    DeclKeyword => "DeclKeyword"
    Modifier => "Modifier"
    String => "String"
    MultilineString => "MultilineString"
    StringInterp => "StringInterp"
    Number => "Number"
    Bool => "Bool"
    Identifier => "Identifier"
    TypeName => "TypeName"
    Attribute => "Attribute"
    Operator => "Operator"
    Comparison => "Comparison"
    Assignment => "Assignment"
    Logical => "Logical"
    Range => "Range"
    Optional => "Optional"
    Arrow => "Arrow"
    ParenOpen => "ParenOpen"
    ParenClose => "ParenClose"
    BracketOpen => "BracketOpen"
    BracketClose => "BracketClose"
    BraceOpen => "BraceOpen"
    BraceClose => "BraceClose"
    Comma => "Comma"
    Colon => "Colon"
    Semicolon => "Semicolon"
    Dot => "Dot"
    LineComment => "LineComment"
    BlockComment => "BlockComment"
    DocComment => "DocComment"
    Whitespace => "Whitespace"
    Newline => "Newline"
    Unknown => "Unknown"
  }
}

///|
/// Highlight Swift source code
pub fn highlight_swift(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = SwiftTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = swift_highlighter()
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
/// Convenience: highlight Swift and generate simple HTML output
pub fn highlight_swift_to_html(source : String) -> String {
  let tokens = highlight_swift(source)
  @syntree.tokens_to_html(source, tokens)
}
