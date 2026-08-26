///| YAML syntax highlighting

// =============================================================================
// YAML Highlighter
// =============================================================================

///|
/// Create a highlighter configured for YAML
pub fn yaml_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()

  // Structure
  h.add_rule("Key", PropertyName)
  h.add_rule("Value", String)
  h.add_rule("ListItem", Punctuation)

  // Scalars
  h.add_rule("String", String)
  h.add_rule("UnquotedString", String)
  h.add_rule("Number", Number)
  h.add_rule("Bool", Bool)
  h.add_rule("Null", Null)

  // Special
  h.add_rule("Anchor", Meta)
  h.add_rule("Alias", Meta)
  h.add_rule("Tag", Meta)
  h.add_rule("Directive", Meta)

  // Punctuation
  h.add_rule("Colon", Punctuation)
  h.add_rule("Dash", Punctuation)
  h.add_rule("Comma", Punctuation)
  h.add_rule("BracketOpen", Bracket)
  h.add_rule("BracketClose", Bracket)
  h.add_rule("BraceOpen", Brace)
  h.add_rule("BraceClose", Brace)
  h.add_rule("Pipe", Operator)
  h.add_rule("Greater", Operator)

  // Comments
  h.add_rule("Comment", Comment)
  h
}

///|
/// Convert token type to string for highlighter lookup
fn token_type_name(t : YamlTokenType) -> String {
  match t {
    Key => "Key"
    Value => "Value"
    ListItem => "ListItem"
    String => "String"
    UnquotedString => "UnquotedString"
    Number => "Number"
    Bool => "Bool"
    Null => "Null"
    Anchor => "Anchor"
    Alias => "Alias"
    Tag => "Tag"
    Directive => "Directive"
    Colon => "Colon"
    Dash => "Dash"
    Comma => "Comma"
    BracketOpen => "BracketOpen"
    BracketClose => "BracketClose"
    BraceOpen => "BraceOpen"
    BraceClose => "BraceClose"
    Pipe => "Pipe"
    Greater => "Greater"
    Comment => "Comment"
    Error => "Error"
  }
}

///|
/// Highlight YAML source code
pub fn highlight_yaml(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = YamlTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = yaml_highlighter()
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
/// Convenience: highlight YAML and generate simple HTML output
pub fn highlight_yaml_to_html(source : String) -> String {
  let tokens = highlight_yaml(source)
  @syntree.tokens_to_html(source, tokens)
}
