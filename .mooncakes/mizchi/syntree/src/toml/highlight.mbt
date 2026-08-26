///| TOML syntax highlighting

// =============================================================================
// TOML Highlighter
// =============================================================================

///|
/// Create a highlighter configured for TOML
pub fn toml_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()

  // Structure
  h.add_rule("Key", PropertyName)
  h.add_rule("TableHeader", Meta)
  h.add_rule("ArrayTable", Meta)

  // Literals
  h.add_rule("String", String)
  h.add_rule("MultilineString", String)
  h.add_rule("Number", Number)
  h.add_rule("Bool", Bool)
  h.add_rule("DateTime", Number)

  // Punctuation
  h.add_rule("Equals", Operator)
  h.add_rule("Dot", Punctuation)
  h.add_rule("Comma", Punctuation)
  h.add_rule("BracketOpen", Bracket)
  h.add_rule("BracketClose", Bracket)
  h.add_rule("BraceOpen", Brace)
  h.add_rule("BraceClose", Brace)

  // Comments
  h.add_rule("Comment", Comment)
  h
}

///|
/// Convert token type to string for highlighter lookup
fn token_type_name(t : TomlTokenType) -> String {
  match t {
    Key => "Key"
    TableHeader => "TableHeader"
    ArrayTable => "ArrayTable"
    String => "String"
    MultilineString => "MultilineString"
    Number => "Number"
    Bool => "Bool"
    DateTime => "DateTime"
    Equals => "Equals"
    Dot => "Dot"
    Comma => "Comma"
    BracketOpen => "BracketOpen"
    BracketClose => "BracketClose"
    BraceOpen => "BraceOpen"
    BraceClose => "BraceClose"
    Comment => "Comment"
    Whitespace => "Whitespace"
    Newline => "Newline"
    Unknown => "Unknown"
  }
}

///|
/// Highlight TOML source code
pub fn highlight_toml(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = TomlTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = toml_highlighter()
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
/// Convenience: highlight TOML and generate simple HTML output
pub fn highlight_toml_to_html(source : String) -> String {
  let tokens = highlight_toml(source)
  @syntree.tokens_to_html(source, tokens)
}
