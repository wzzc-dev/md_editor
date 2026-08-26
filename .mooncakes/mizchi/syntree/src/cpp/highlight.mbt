///|
/// C++ syntax highlighting

///|
pub fn cpp_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()
  h.add_rule("Keyword", Keyword)
  h.add_rule("Modifier", Keyword)
  h.add_rule("String", String)
  h.add_rule("RawString", String)
  h.add_rule("Char", String)
  h.add_rule("Number", Number)
  h.add_rule("Identifier", VariableName)
  h.add_rule("TypeKeyword", TypeName)
  h.add_rule("TypeName", TypeName)
  h.add_rule("Preprocessor", Meta)
  h.add_rule("Operator", Operator)
  h.add_rule("Comparison", Operator)
  h.add_rule("Assignment", Operator)
  h.add_rule("Logical", Operator)
  h.add_rule("Bitwise", Operator)
  h.add_rule("Increment", Operator)
  h.add_rule("Arrow", Operator)
  h.add_rule("Scope", Punctuation)
  h.add_rule("ParenOpen", Paren)
  h.add_rule("ParenClose", Paren)
  h.add_rule("BracketOpen", Bracket)
  h.add_rule("BracketClose", Bracket)
  h.add_rule("BraceOpen", Brace)
  h.add_rule("BraceClose", Brace)
  h.add_rule("Comma", Punctuation)
  h.add_rule("Semicolon", Punctuation)
  h.add_rule("Colon", Punctuation)
  h.add_rule("Dot", Punctuation)
  h.add_rule("Ellipsis", Punctuation)
  h.add_rule("LineComment", Comment)
  h.add_rule("BlockComment", Comment)
  h
}

///|
fn token_type_name(t : CppTokenType) -> String {
  match t {
    Keyword => "Keyword"
    Modifier => "Modifier"
    String => "String"
    RawString => "RawString"
    Char => "Char"
    Number => "Number"
    Identifier => "Identifier"
    TypeKeyword => "TypeKeyword"
    TypeName => "TypeName"
    Preprocessor => "Preprocessor"
    Operator => "Operator"
    Comparison => "Comparison"
    Assignment => "Assignment"
    Logical => "Logical"
    Bitwise => "Bitwise"
    Increment => "Increment"
    Arrow => "Arrow"
    Scope => "Scope"
    ParenOpen => "ParenOpen"
    ParenClose => "ParenClose"
    BracketOpen => "BracketOpen"
    BracketClose => "BracketClose"
    BraceOpen => "BraceOpen"
    BraceClose => "BraceClose"
    Comma => "Comma"
    Semicolon => "Semicolon"
    Colon => "Colon"
    Dot => "Dot"
    Ellipsis => "Ellipsis"
    LineComment => "LineComment"
    BlockComment => "BlockComment"
    Whitespace => "Whitespace"
    Newline => "Newline"
    Unknown => "Unknown"
  }
}

///|
pub fn highlight_cpp(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = CppTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = cpp_highlighter()
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
pub fn highlight_cpp_to_html(source : String) -> String {
  let tokens = highlight_cpp(source)
  @syntree.tokens_to_html(source, tokens)
}
