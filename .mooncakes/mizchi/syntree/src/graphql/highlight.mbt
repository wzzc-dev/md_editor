///|
/// GraphQL syntax highlighting

///|
pub fn graphql_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()
  h.add_rule("Keyword", Keyword)
  h.add_rule("TypeKeyword", Keyword)
  h.add_rule("DirectiveKeyword", Keyword)
  h.add_rule("String", String)
  h.add_rule("BlockString", String)
  h.add_rule("Number", Number)
  h.add_rule("Bool", Bool)
  h.add_rule("Null", Null)
  h.add_rule("Name", VariableName)
  h.add_rule("TypeName", TypeName)
  h.add_rule("Variable", VariableName)
  h.add_rule("Directive", Meta)
  h.add_rule("Operator", Operator)
  h.add_rule("Spread", Operator)
  h.add_rule("ParenOpen", Paren)
  h.add_rule("ParenClose", Paren)
  h.add_rule("BracketOpen", Bracket)
  h.add_rule("BracketClose", Bracket)
  h.add_rule("BraceOpen", Brace)
  h.add_rule("BraceClose", Brace)
  h.add_rule("Colon", Punctuation)
  h.add_rule("Equals", Operator)
  h.add_rule("Bang", Operator)
  h.add_rule("Pipe", Operator)
  h.add_rule("Amp", Operator)
  h.add_rule("At", Meta)
  h.add_rule("Dollar", Operator)
  h.add_rule("Comment", Comment)
  h
}

///|
fn token_type_name(t : GraphqlTokenType) -> String {
  match t {
    Keyword => "Keyword"
    TypeKeyword => "TypeKeyword"
    DirectiveKeyword => "DirectiveKeyword"
    String => "String"
    BlockString => "BlockString"
    Number => "Number"
    Bool => "Bool"
    Null => "Null"
    Name => "Name"
    TypeName => "TypeName"
    Variable => "Variable"
    Directive => "Directive"
    Operator => "Operator"
    Spread => "Spread"
    ParenOpen => "ParenOpen"
    ParenClose => "ParenClose"
    BracketOpen => "BracketOpen"
    BracketClose => "BracketClose"
    BraceOpen => "BraceOpen"
    BraceClose => "BraceClose"
    Colon => "Colon"
    Equals => "Equals"
    Bang => "Bang"
    Pipe => "Pipe"
    Amp => "Amp"
    At => "At"
    Dollar => "Dollar"
    Comment => "Comment"
    Whitespace => "Whitespace"
    Newline => "Newline"
    Unknown => "Unknown"
  }
}

///|
pub fn highlight_graphql(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = GraphqlTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = graphql_highlighter()
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
pub fn highlight_graphql_to_html(source : String) -> String {
  let tokens = highlight_graphql(source)
  @syntree.tokens_to_html(source, tokens)
}
