///| OCaml syntax highlighting

// =============================================================================
// OCaml Highlighter
// =============================================================================

///|
/// Create a highlighter configured for OCaml
pub fn ocaml_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()

  // Keywords
  h.add_rule("Keyword", Keyword)
  h.add_rule("ModuleKeyword", Keyword)

  // Literals
  h.add_rule("String", String)
  h.add_rule("Char", String)
  h.add_rule("Number", Number)

  // Identifiers
  h.add_rule("Identifier", VariableName)
  h.add_rule("TypeIdent", TypeName)
  h.add_rule("ModuleName", ClassName)
  h.add_rule("Constructor", TypeName)
  h.add_rule("Label", Meta)

  // Operators
  h.add_rule("Operator", Operator)
  h.add_rule("Comparison", Operator)
  h.add_rule("Logical", Operator)
  h.add_rule("ListCons", Operator)
  h.add_rule("Concat", Operator)
  h.add_rule("Arrow", Operator)
  h.add_rule("Pipe", Operator)

  // Delimiters
  h.add_rule("ParenOpen", Paren)
  h.add_rule("ParenClose", Paren)
  h.add_rule("BracketOpen", Bracket)
  h.add_rule("BracketClose", Bracket)
  h.add_rule("BraceOpen", Brace)
  h.add_rule("BraceClose", Brace)
  h.add_rule("Comma", Punctuation)
  h.add_rule("Semicolon", Punctuation)
  h.add_rule("Semicolon2", Punctuation)
  h.add_rule("Colon", Punctuation)
  h.add_rule("Dot", Punctuation)
  h.add_rule("Underscore", Keyword)

  // Comments
  h.add_rule("Comment", Comment)
  h
}

///|
/// Convert token type to string for highlighter lookup
fn token_type_name(t : OcamlTokenType) -> String {
  match t {
    Keyword => "Keyword"
    ModuleKeyword => "ModuleKeyword"
    String => "String"
    Char => "Char"
    Number => "Number"
    Identifier => "Identifier"
    TypeIdent => "TypeIdent"
    ModuleName => "ModuleName"
    Constructor => "Constructor"
    Label => "Label"
    Operator => "Operator"
    Comparison => "Comparison"
    Logical => "Logical"
    ListCons => "ListCons"
    Concat => "Concat"
    Arrow => "Arrow"
    Pipe => "Pipe"
    Semicolon2 => "Semicolon2"
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
    Underscore => "Underscore"
    Comment => "Comment"
    Whitespace => "Whitespace"
    Newline => "Newline"
    Unknown => "Unknown"
  }
}

///|
/// Highlight OCaml source code
pub fn highlight_ocaml(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = OcamlTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = ocaml_highlighter()
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
/// Convenience: highlight OCaml and generate simple HTML output
pub fn highlight_ocaml_to_html(source : String) -> String {
  let tokens = highlight_ocaml(source)
  @syntree.tokens_to_html(source, tokens)
}
