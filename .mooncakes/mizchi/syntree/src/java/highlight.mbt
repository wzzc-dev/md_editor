///| Java syntax highlighting

// =============================================================================
// Java Highlighter
// =============================================================================

///|
/// Create a highlighter configured for Java
pub fn java_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()

  // Keywords
  h.add_rule("Keyword", Keyword)
  h.add_rule("Modifier", Keyword)

  // Literals
  h.add_rule("String", String)
  h.add_rule("TextBlock", String)
  h.add_rule("Char", String)
  h.add_rule("Number", Number)

  // Identifiers
  h.add_rule("Identifier", VariableName)
  h.add_rule("TypeKeyword", TypeName)
  h.add_rule("TypeName", ClassName)
  h.add_rule("Annotation", Meta)

  // Operators
  h.add_rule("Operator", Operator)
  h.add_rule("Comparison", Operator)
  h.add_rule("Assignment", Operator)
  h.add_rule("Logical", Operator)
  h.add_rule("Bitwise", Operator)
  h.add_rule("Increment", Operator)
  h.add_rule("Ternary", Operator)
  h.add_rule("Arrow", Operator)
  h.add_rule("DoubleColon", Operator)

  // Delimiters
  h.add_rule("ParenOpen", Paren)
  h.add_rule("ParenClose", Paren)
  h.add_rule("BracketOpen", Bracket)
  h.add_rule("BracketClose", Bracket)
  h.add_rule("BraceOpen", Brace)
  h.add_rule("BraceClose", Brace)
  h.add_rule("Comma", Punctuation)
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
fn token_type_name(t : JavaTokenType) -> String {
  match t {
    Keyword => "Keyword"
    Modifier => "Modifier"
    String => "String"
    TextBlock => "TextBlock"
    Char => "Char"
    Number => "Number"
    Identifier => "Identifier"
    TypeKeyword => "TypeKeyword"
    TypeName => "TypeName"
    Annotation => "Annotation"
    Operator => "Operator"
    Comparison => "Comparison"
    Assignment => "Assignment"
    Logical => "Logical"
    Bitwise => "Bitwise"
    Increment => "Increment"
    Ternary => "Ternary"
    Arrow => "Arrow"
    DoubleColon => "DoubleColon"
    ParenOpen => "ParenOpen"
    ParenClose => "ParenClose"
    BracketOpen => "BracketOpen"
    BracketClose => "BracketClose"
    BraceOpen => "BraceOpen"
    BraceClose => "BraceClose"
    Comma => "Comma"
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
/// Highlight Java source code
pub fn highlight_java(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = JavaTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = java_highlighter()
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
/// Convenience: highlight Java and generate simple HTML output
pub fn highlight_java_to_html(source : String) -> String {
  let tokens = highlight_java(source)
  @syntree.tokens_to_html(source, tokens)
}
