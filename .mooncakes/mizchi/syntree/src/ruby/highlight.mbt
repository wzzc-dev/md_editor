///|
/// Ruby syntax highlighting

///|
pub fn ruby_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()
  h.add_rule("Keyword", Keyword)
  h.add_rule("DeclKeyword", Keyword)
  h.add_rule("Modifier", Keyword)
  h.add_rule("String", String)
  h.add_rule("HeredocString", String)
  h.add_rule("Regex", Regexp)
  h.add_rule("Symbol", String)
  h.add_rule("Number", Number)
  h.add_rule("Bool", Bool)
  h.add_rule("Nil", Null)
  h.add_rule("Identifier", VariableName)
  h.add_rule("Constant", TypeName)
  h.add_rule("InstanceVar", PropertyName)
  h.add_rule("ClassVar", PropertyName)
  h.add_rule("GlobalVar", VariableName)
  h.add_rule("Operator", Operator)
  h.add_rule("Comparison", Operator)
  h.add_rule("Assignment", Operator)
  h.add_rule("Logical", Operator)
  h.add_rule("Range", Operator)
  h.add_rule("Splat", Operator)
  h.add_rule("BlockArg", Operator)
  h.add_rule("ParenOpen", Paren)
  h.add_rule("ParenClose", Paren)
  h.add_rule("BracketOpen", Bracket)
  h.add_rule("BracketClose", Bracket)
  h.add_rule("BraceOpen", Brace)
  h.add_rule("BraceClose", Brace)
  h.add_rule("Comma", Punctuation)
  h.add_rule("Semicolon", Punctuation)
  h.add_rule("Colon", Punctuation)
  h.add_rule("DoubleColon", Punctuation)
  h.add_rule("Dot", Punctuation)
  h.add_rule("Question", Punctuation)
  h.add_rule("Comment", Comment)
  h
}

///|
fn token_type_name(t : RubyTokenType) -> String {
  match t {
    Keyword => "Keyword"
    DeclKeyword => "DeclKeyword"
    Modifier => "Modifier"
    String => "String"
    HeredocString => "HeredocString"
    Regex => "Regex"
    Symbol => "Symbol"
    Number => "Number"
    Bool => "Bool"
    Nil => "Nil"
    Identifier => "Identifier"
    Constant => "Constant"
    InstanceVar => "InstanceVar"
    ClassVar => "ClassVar"
    GlobalVar => "GlobalVar"
    Operator => "Operator"
    Comparison => "Comparison"
    Assignment => "Assignment"
    Logical => "Logical"
    Range => "Range"
    Splat => "Splat"
    BlockArg => "BlockArg"
    ParenOpen => "ParenOpen"
    ParenClose => "ParenClose"
    BracketOpen => "BracketOpen"
    BracketClose => "BracketClose"
    BraceOpen => "BraceOpen"
    BraceClose => "BraceClose"
    Comma => "Comma"
    Semicolon => "Semicolon"
    Colon => "Colon"
    DoubleColon => "DoubleColon"
    Dot => "Dot"
    Question => "Question"
    Comment => "Comment"
    Whitespace => "Whitespace"
    Newline => "Newline"
    Unknown => "Unknown"
  }
}

///|
pub fn highlight_ruby(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = RubyTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = ruby_highlighter()
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
pub fn highlight_ruby_to_html(source : String) -> String {
  let tokens = highlight_ruby(source)
  @syntree.tokens_to_html(source, tokens)
}
