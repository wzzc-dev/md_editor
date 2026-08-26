///|
/// Makefile syntax highlighting

///|
pub fn makefile_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()
  h.add_rule("Target", FunctionName)
  h.add_rule("Prerequisite", VariableName)
  h.add_rule("Variable", VariableName)
  h.add_rule("VariableRef", VariableName)
  h.add_rule("Function", FunctionName)
  h.add_rule("String", String)
  h.add_rule("Operator", Operator)
  h.add_rule("Assignment", Operator)
  h.add_rule("Colon", Punctuation)
  h.add_rule("Semicolon", Punctuation)
  h.add_rule("Pipe", Operator)
  h.add_rule("Recipe", String)
  h.add_rule("Comment", Comment)
  h.add_rule("Directive", Keyword)
  h
}

///|
fn token_type_name(t : MakefileTokenType) -> String {
  match t {
    Target => "Target"
    Prerequisite => "Prerequisite"
    Variable => "Variable"
    VariableRef => "VariableRef"
    Function => "Function"
    String => "String"
    Operator => "Operator"
    Assignment => "Assignment"
    Colon => "Colon"
    Semicolon => "Semicolon"
    Pipe => "Pipe"
    Recipe => "Recipe"
    Comment => "Comment"
    Directive => "Directive"
    Whitespace => "Whitespace"
    Newline => "Newline"
    Tab => "Tab"
    Unknown => "Unknown"
  }
}

///|
pub fn highlight_makefile(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = MakefileTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = makefile_highlighter()
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
pub fn highlight_makefile_to_html(source : String) -> String {
  let tokens = highlight_makefile(source)
  @syntree.tokens_to_html(source, tokens)
}
