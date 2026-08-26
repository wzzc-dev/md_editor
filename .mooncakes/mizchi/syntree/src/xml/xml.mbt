///|
/// XML Tokenizer
pub(all) enum XmlTokenType {
  TagOpen
  TagClose
  TagSelfClose
  TagName
  AttrName
  AttrValue
  Text
  Comment
  CData
  ProcessingInstruction
  DocType
  Entity
  Equals
  Whitespace
  Newline
  Unknown
} derive(Eq, Show)

///|
pub(all) struct XmlToken {
  token_type : XmlTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct XmlTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
  priv mut in_tag : Bool
}

///|
pub fn XmlTokenizer::new(input : String) -> XmlTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0, in_tag: false }
}

///|
fn XmlTokenizer::peek_at(self : XmlTokenizer, offset : Int) -> Char? {
  let idx = self.pos + offset
  if idx >= 0 && idx < self.len {
    Some(self.chars[idx])
  } else {
    None
  }
}

///|
fn is_name_start(c : Char) -> Bool {
  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_' || c == ':'
}

///|
fn is_name_char(c : Char) -> Bool {
  is_name_start(c) || (c >= '0' && c <= '9') || c == '-' || c == '.'
}

///|
fn XmlTokenizer::read_name(self : XmlTokenizer) -> XmlToken {
  let start = self.pos
  while self.pos < self.len && is_name_char(self.chars[self.pos]) {
    self.pos += 1
  }
  let token_type = if self.in_tag { AttrName } else { TagName }
  { token_type, from: start, to: self.pos }
}

///|
fn XmlTokenizer::read_attr_value(self : XmlTokenizer) -> XmlToken {
  let start = self.pos
  let quote = self.chars[self.pos]
  self.pos += 1
  while self.pos < self.len && self.chars[self.pos] != quote {
    self.pos += 1
  }
  if self.pos < self.len {
    self.pos += 1
  }
  { token_type: AttrValue, from: start, to: self.pos }
}

///|
fn XmlTokenizer::read_comment(self : XmlTokenizer) -> XmlToken {
  let start = self.pos
  self.pos += 4 // skip <!--
  while self.pos + 2 < self.len {
    if self.chars[self.pos] == '-' &&
      self.chars[self.pos + 1] == '-' &&
      self.chars[self.pos + 2] == '>' {
      self.pos += 3
      break
    }
    self.pos += 1
  }
  { token_type: Comment, from: start, to: self.pos }
}

///|
fn XmlTokenizer::read_cdata(self : XmlTokenizer) -> XmlToken {
  let start = self.pos
  self.pos += 9 // skip <![CDATA[
  while self.pos + 2 < self.len {
    if self.chars[self.pos] == ']' &&
      self.chars[self.pos + 1] == ']' &&
      self.chars[self.pos + 2] == '>' {
      self.pos += 3
      break
    }
    self.pos += 1
  }
  { token_type: CData, from: start, to: self.pos }
}

///|
fn XmlTokenizer::read_processing_instruction(self : XmlTokenizer) -> XmlToken {
  let start = self.pos
  self.pos += 2 // skip <?
  while self.pos + 1 < self.len {
    if self.chars[self.pos] == '?' && self.chars[self.pos + 1] == '>' {
      self.pos += 2
      break
    }
    self.pos += 1
  }
  { token_type: ProcessingInstruction, from: start, to: self.pos }
}

///|
fn XmlTokenizer::read_doctype(self : XmlTokenizer) -> XmlToken {
  let start = self.pos
  self.pos += 9 // skip <!DOCTYPE
  let mut depth = 1
  while self.pos < self.len && depth > 0 {
    let c = self.chars[self.pos]
    if c == '<' {
      depth += 1
    } else if c == '>' {
      depth -= 1
    }
    self.pos += 1
  }
  { token_type: DocType, from: start, to: self.pos }
}

///|
fn XmlTokenizer::read_text(self : XmlTokenizer) -> XmlToken {
  let start = self.pos
  while self.pos < self.len && self.chars[self.pos] != '<' {
    self.pos += 1
  }
  { token_type: Text, from: start, to: self.pos }
}

///|
fn XmlTokenizer::check_prefix(self : XmlTokenizer, prefix : String) -> Bool {
  let chars_arr = prefix.to_array()
  for i = 0; i < chars_arr.length(); i = i + 1 {
    if self.pos + i >= self.len || self.chars[self.pos + i] != chars_arr[i] {
      return false
    }
  }
  true
}

///|
pub fn XmlTokenizer::next_token(self : XmlTokenizer) -> XmlToken? {
  if self.pos >= self.len {
    return None
  }
  let start = self.pos
  let c = self.chars[self.pos]

  // Inside tag
  if self.in_tag {
    // Whitespace
    if c == ' ' || c == '\t' || c == '\r' {
      while self.pos < self.len {
        let ch = self.chars[self.pos]
        if ch == ' ' || ch == '\t' || ch == '\r' {
          self.pos += 1
        } else {
          break
        }
      }
      return Some({ token_type: Whitespace, from: start, to: self.pos })
    }

    // Newline
    if c == '\n' {
      self.pos += 1
      return Some({ token_type: Newline, from: start, to: self.pos })
    }

    // Self-closing tag end
    if c == '/' && self.peek_at(1) == Some('>') {
      self.pos += 2
      self.in_tag = false
      return Some({ token_type: TagSelfClose, from: start, to: self.pos })
    }

    // Tag end
    if c == '>' {
      self.pos += 1
      self.in_tag = false
      return Some({ token_type: TagClose, from: start, to: self.pos })
    }

    // Equals
    if c == '=' {
      self.pos += 1
      return Some({ token_type: Equals, from: start, to: self.pos })
    }

    // Attribute value
    if c == '"' || c == '\'' {
      return Some(self.read_attr_value())
    }

    // Attribute name
    if is_name_start(c) {
      return Some(self.read_name())
    }
    self.pos += 1
    return Some({ token_type: Unknown, from: start, to: self.pos })
  }

  // Outside tag
  // Comment
  if self.check_prefix("<!--") {
    return Some(self.read_comment())
  }

  // CDATA
  if self.check_prefix("<![CDATA[") {
    return Some(self.read_cdata())
  }

  // DOCTYPE
  if self.check_prefix("<!DOCTYPE") {
    return Some(self.read_doctype())
  }

  // Processing instruction
  if c == '<' && self.peek_at(1) == Some('?') {
    return Some(self.read_processing_instruction())
  }

  // End tag
  if c == '<' && self.peek_at(1) == Some('/') {
    self.pos += 2
    self.in_tag = true
    return Some({ token_type: TagOpen, from: start, to: self.pos })
  }

  // Start tag
  if c == '<' {
    self.pos += 1
    self.in_tag = true
    return Some({ token_type: TagOpen, from: start, to: self.pos })
  }

  // Entity
  if c == '&' {
    self.pos += 1
    while self.pos < self.len &&
          self.chars[self.pos] != ';' &&
          self.chars[self.pos] != '<' {
      self.pos += 1
    }
    if self.pos < self.len && self.chars[self.pos] == ';' {
      self.pos += 1
    }
    return Some({ token_type: Entity, from: start, to: self.pos })
  }

  // Text content
  if c != '<' {
    return Some(self.read_text())
  }
  self.pos += 1
  Some({ token_type: Unknown, from: start, to: self.pos })
}

///|
pub fn XmlTokenizer::tokenize_all(self : XmlTokenizer) -> Array[XmlToken] {
  let tokens : Array[XmlToken] = []
  while true {
    match self.next_token() {
      Some(token) =>
        match token.token_type {
          Whitespace | Newline => ()
          _ => tokens.push(token)
        }
      None => break
    }
  }
  tokens
}
