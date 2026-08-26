///|
/// Haskell syntax highlighting

///|
pub fn haskell_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()
  h.add_rule("Keyword", Keyword)
  h.add_rule("ModuleKeyword", Keyword)
  h.add_rule("TypeKeyword", Keyword)
  h.add_rule("String", String)
  h.add_rule("Char", String)
  h.add_rule("Number", Number)
  h.add_rule("Bool", Bool)
  h.add_rule("Identifier", VariableName)
  h.add_rule("TypeName", TypeName)
  h.add_rule("TypeVar", TypeName)
  h.add_rule("Constructor", TypeName)
  h.add_rule("Operator", Operator)
  h.add_rule("Comparison", Operator)
  h.add_rule("Assignment", Operator)
  h.add_rule("Arrow", Operator)
  h.add_rule("FatArrow", Operator)
  h.add_rule("TypeArrow", Operator)
  h.add_rule("Constraint", Operator)
  h.add_rule("Guard", Operator)
  h.add_rule("Lambda", Keyword)
  h.add_rule("ParenOpen", Paren)
  h.add_rule("ParenClose", Paren)
  h.add_rule("BracketOpen", Bracket)
  h.add_rule("BracketClose", Bracket)
  h.add_rule("BraceOpen", Brace)
  h.add_rule("BraceClose", Brace)
  h.add_rule("Comma", Punctuation)
  h.add_rule("Semicolon", Punctuation)
  h.add_rule("Backtick", Punctuation)
  h.add_rule("At", Operator)
  h.add_rule("Underscore", Keyword)
  h.add_rule("LineComment", Comment)
  h.add_rule("BlockComment", Comment)
  h.add_rule("Pragma", Meta)
  h
}

///|
fn token_type_name(t : HaskellTokenType) -> String {
  match t {
    Keyword => "Keyword"
    ModuleKeyword => "ModuleKeyword"
    TypeKeyword => "TypeKeyword"
    String => "String"
    Char => "Char"
    Number => "Number"
    Bool => "Bool"
    Identifier => "Identifier"
    TypeName => "TypeName"
    TypeVar => "TypeVar"
    Constructor => "Constructor"
    Operator => "Operator"
    Comparison => "Comparison"
    Assignment => "Assignment"
    Arrow => "Arrow"
    FatArrow => "FatArrow"
    TypeArrow => "TypeArrow"
    Constraint => "Constraint"
    Guard => "Guard"
    Lambda => "Lambda"
    ParenOpen => "ParenOpen"
    ParenClose => "ParenClose"
    BracketOpen => "BracketOpen"
    BracketClose => "BracketClose"
    BraceOpen => "BraceOpen"
    BraceClose => "BraceClose"
    Comma => "Comma"
    Semicolon => "Semicolon"
    Backtick => "Backtick"
    At => "At"
    Underscore => "Underscore"
    LineComment => "LineComment"
    BlockComment => "BlockComment"
    Pragma => "Pragma"
    Whitespace => "Whitespace"
    Newline => "Newline"
    Unknown => "Unknown"
  }
}

///|
pub fn highlight_haskell(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = HaskellTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = haskell_highlighter()
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
pub fn highlight_haskell_to_html(source : String) -> String {
  let tokens = highlight_haskell(source)
  @syntree.tokens_to_html(source, tokens)
}
