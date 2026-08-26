///|
/// Lua syntax highlighting

///|
pub fn lua_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()
  h.add_rule("Keyword", Keyword)
  h.add_rule("String", String)
  h.add_rule("LongString", String)
  h.add_rule("Number", Number)
  h.add_rule("Bool", Bool)
  h.add_rule("Nil", Null)
  h.add_rule("Identifier", VariableName)
  h.add_rule("Operator", Operator)
  h.add_rule("Comparison", Operator)
  h.add_rule("Assignment", Operator)
  h.add_rule("Logical", Keyword)
  h.add_rule("Concat", Operator)
  h.add_rule("Length", Operator)
  h.add_rule("Vararg", Operator)
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
  h.add_rule("LineComment", Comment)
  h.add_rule("BlockComment", Comment)
  h
}

///|
fn token_type_name(t : LuaTokenType) -> String {
  match t {
    Keyword => "Keyword"
    String => "String"
    LongString => "LongString"
    Number => "Number"
    Bool => "Bool"
    Nil => "Nil"
    Identifier => "Identifier"
    Operator => "Operator"
    Comparison => "Comparison"
    Assignment => "Assignment"
    Logical => "Logical"
    Concat => "Concat"
    Length => "Length"
    Vararg => "Vararg"
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
    LineComment => "LineComment"
    BlockComment => "BlockComment"
    Whitespace => "Whitespace"
    Newline => "Newline"
    Unknown => "Unknown"
  }
}

///|
pub fn highlight_lua(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = LuaTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = lua_highlighter()
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
pub fn highlight_lua_to_html(source : String) -> String {
  let tokens = highlight_lua(source)
  @syntree.tokens_to_html(source, tokens)
}
