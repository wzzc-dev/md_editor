///| SQL syntax highlighting

// =============================================================================
// SQL Highlighter
// =============================================================================

///|
/// Create a highlighter configured for SQL
pub fn sql_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()

  // Keywords
  h.add_rule("Keyword", Keyword)
  h.add_rule("DMLKeyword", Keyword)
  h.add_rule("DDLKeyword", Keyword)
  h.add_rule("Logical", Keyword)
  h.add_rule("Function", FunctionName)
  h.add_rule("DataType", TypeName)

  // Literals
  h.add_rule("String", String)
  h.add_rule("Number", Number)
  h.add_rule("Null", Null)

  // Identifiers
  h.add_rule("Identifier", VariableName)
  h.add_rule("QuotedIdent", VariableName)
  h.add_rule("Parameter", Meta)

  // Operators
  h.add_rule("Operator", Operator)
  h.add_rule("Comparison", Operator)
  h.add_rule("Assignment", Operator)
  h.add_rule("Star", Operator)

  // Delimiters
  h.add_rule("ParenOpen", Paren)
  h.add_rule("ParenClose", Paren)
  h.add_rule("Comma", Punctuation)
  h.add_rule("Semicolon", Punctuation)
  h.add_rule("Dot", Punctuation)

  // Comments
  h.add_rule("LineComment", Comment)
  h.add_rule("BlockComment", Comment)
  h
}

///|
/// Convert token type to string for highlighter lookup
fn token_type_name(t : SqlTokenType) -> String {
  match t {
    Keyword => "Keyword"
    DMLKeyword => "DMLKeyword"
    DDLKeyword => "DDLKeyword"
    Function => "Function"
    DataType => "DataType"
    String => "String"
    Number => "Number"
    Null => "Null"
    Identifier => "Identifier"
    QuotedIdent => "QuotedIdent"
    Parameter => "Parameter"
    Operator => "Operator"
    Comparison => "Comparison"
    Logical => "Logical"
    Assignment => "Assignment"
    ParenOpen => "ParenOpen"
    ParenClose => "ParenClose"
    Comma => "Comma"
    Semicolon => "Semicolon"
    Dot => "Dot"
    Star => "Star"
    LineComment => "LineComment"
    BlockComment => "BlockComment"
    Whitespace => "Whitespace"
    Newline => "Newline"
    Unknown => "Unknown"
  }
}

///|
/// Highlight SQL source code
pub fn highlight_sql(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = SqlTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = sql_highlighter()
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
/// Convenience: highlight SQL and generate simple HTML output
pub fn highlight_sql_to_html(source : String) -> String {
  let tokens = highlight_sql(source)
  @syntree.tokens_to_html(source, tokens)
}
