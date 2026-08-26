///|
/// XML syntax highlighting

///|
pub fn xml_highlighter() -> @syntree.Highlighter {
  let h = @syntree.Highlighter::new()
  h.add_rule("TagOpen", TagBracket)
  h.add_rule("TagClose", TagBracket)
  h.add_rule("TagSelfClose", TagBracket)
  h.add_rule("TagName", TagName)
  h.add_rule("AttrName", PropertyName)
  h.add_rule("AttrValue", String)
  h.add_rule("Text", VariableName)
  h.add_rule("Comment", Comment)
  h.add_rule("CData", String)
  h.add_rule("ProcessingInstruction", Meta)
  h.add_rule("DocType", Meta)
  h.add_rule("Entity", String)
  h.add_rule("Equals", Operator)
  h
}

///|
fn token_type_name(t : XmlTokenType) -> String {
  match t {
    TagOpen => "TagOpen"
    TagClose => "TagClose"
    TagSelfClose => "TagSelfClose"
    TagName => "TagName"
    AttrName => "AttrName"
    AttrValue => "AttrValue"
    Text => "Text"
    Comment => "Comment"
    CData => "CData"
    ProcessingInstruction => "ProcessingInstruction"
    DocType => "DocType"
    Entity => "Entity"
    Equals => "Equals"
    Whitespace => "Whitespace"
    Newline => "Newline"
    Unknown => "Unknown"
  }
}

///|
pub fn highlight_xml(source : String) -> Array[@syntree.HighlightToken] {
  let tokenizer = XmlTokenizer::new(source)
  let tokens = tokenizer.tokenize_all()
  let highlighter = xml_highlighter()
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
pub fn highlight_xml_to_html(source : String) -> String {
  let tokens = highlight_xml(source)
  @syntree.tokens_to_html(source, tokens)
}
