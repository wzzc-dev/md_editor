///| Python syntax highlighting

// =============================================================================
// Python Highlighter
// =============================================================================

///|
/// Create a highlighter configured for Python
pub fn python_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()

  // Keywords
  h.add_rule("Keyword", Keyword)
  h.add_rule("Logical", Keyword)

  // Literals
  h.add_rule("String", String)
  h.add_rule("FString", String)
  h.add_rule("Number", Number)

  // Identifiers
  h.add_rule("Identifier", VariableName)
  h.add_rule("Decorator", Meta)
  h.add_rule("BuiltinFunc", FunctionName)
  h.add_rule("BuiltinType", TypeName)
  h.add_rule("ClassName", ClassName)

  // Operators
  h.add_rule("Operator", Operator)
  h.add_rule("Comparison", Operator)
  h.add_rule("Assignment", Operator)
  h.add_rule("Bitwise", Operator)
  h.add_rule("Walrus", Operator)
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
  h.add_rule("Ellipsis", Punctuation)

  // Comments
  h.add_rule("Comment", Comment)
  h
}

///|
/// Convert token type to string for highlighter lookup
fn token_type_name(t : PythonTokenType) -> String {
  match t {
    Keyword => "Keyword"
    String => "String"
    FString => "FString"
    Number => "Number"
    Identifier => "Identifier"
    Decorator => "Decorator"
    BuiltinFunc => "BuiltinFunc"
    BuiltinType => "BuiltinType"
    ClassName => "ClassName"
    Operator => "Operator"
    Comparison => "Comparison"
    Assignment => "Assignment"
    Logical => "Logical"
    Bitwise => "Bitwise"
    Walrus => "Walrus"
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
    Ellipsis => "Ellipsis"
    Comment => "Comment"
    Whitespace => "Whitespace"
    Newline => "Newline"
    Unknown => "Unknown"
  }
}

///|
/// Highlight Python source code
pub fn highlight_python(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = PythonTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = python_highlighter()
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
/// Convenience: highlight Python and generate simple HTML output
pub fn highlight_python_to_html(source : String) -> String {
  let tokens = highlight_python(source)
  @syntree.tokens_to_html(source, tokens)
}
