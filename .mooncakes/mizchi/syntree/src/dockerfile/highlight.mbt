///|
/// Dockerfile syntax highlighting

///|
pub fn dockerfile_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()
  h.add_rule("Instruction", Keyword)
  h.add_rule("String", String)
  h.add_rule("Number", Number)
  h.add_rule("Variable", VariableName)
  h.add_rule("Flag", Meta)
  h.add_rule("Argument", VariableName)
  h.add_rule("Path", String)
  h.add_rule("Equals", Operator)
  h.add_rule("Comment", Comment)
  h
}

///|
fn token_type_name(t : DockerfileTokenType) -> String {
  match t {
    Instruction => "Instruction"
    String => "String"
    Number => "Number"
    Variable => "Variable"
    Flag => "Flag"
    Argument => "Argument"
    Path => "Path"
    Equals => "Equals"
    Comment => "Comment"
    Whitespace => "Whitespace"
    Newline => "Newline"
    Continuation => "Continuation"
    Unknown => "Unknown"
  }
}

///|
pub fn highlight_dockerfile(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = DockerfileTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = dockerfile_highlighter()
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
pub fn highlight_dockerfile_to_html(source : String) -> String {
  let tokens = highlight_dockerfile(source)
  @syntree.tokens_to_html(source, tokens)
}
