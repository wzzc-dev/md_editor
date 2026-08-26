///|
/// GraphQL Tokenizer
pub(all) enum GraphqlTokenType {
  Keyword
  TypeKeyword
  DirectiveKeyword
  String
  BlockString
  Number
  Bool
  Null
  Name
  TypeName
  Variable
  Directive
  Operator
  Spread
  ParenOpen
  ParenClose
  BracketOpen
  BracketClose
  BraceOpen
  BraceClose
  Colon
  Equals
  Bang
  Pipe
  Amp
  At
  Dollar
  Comment
  Whitespace
  Newline
  Unknown
} derive(Eq, Show)

///|
pub(all) struct GraphqlToken {
  token_type : GraphqlTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct GraphqlTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
let graphql_keywords : Array[String] = [
  "query", "mutation", "subscription", "fragment", "on", "implements",
]

///|
let graphql_type_keywords : Array[String] = [
  "type", "interface", "union", "enum", "input", "scalar", "extend", "schema",
]

///|
let graphql_directive_keywords : Array[String] = ["directive", "repeatable"]

///|
pub fn GraphqlTokenizer::new(input : String) -> GraphqlTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
fn GraphqlTokenizer::peek_at(self : GraphqlTokenizer, offset : Int) -> Char? {
  let idx = self.pos + offset
  if idx >= 0 && idx < self.len {
    Some(self.chars[idx])
  } else {
    None
  }
}

///|
fn is_name_start(c : Char) -> Bool {
  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_'
}

///|
fn is_name_char(c : Char) -> Bool {
  is_name_start(c) || (c >= '0' && c <= '9')
}

///|
fn is_digit(c : Char) -> Bool {
  c >= '0' && c <= '9'
}

///|
fn GraphqlTokenizer::read_string(self : GraphqlTokenizer) -> GraphqlToken {
  let start = self.pos

  // Check for block string
  if self.peek_at(1) == Some('"') && self.peek_at(2) == Some('"') {
    self.pos += 3
    while self.pos < self.len {
      if self.chars[self.pos] == '"' &&
        self.peek_at(1) == Some('"') &&
        self.peek_at(2) == Some('"') {
        self.pos += 3
        break
      }
      self.pos += 1
    }
    return { token_type: BlockString, from: start, to: self.pos }
  }
  self.pos += 1
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '\\' {
      self.pos += 2
    } else if c == '"' {
      self.pos += 1
      break
    } else if c == '\n' {
      break
    } else {
      self.pos += 1
    }
  }
  { token_type: String, from: start, to: self.pos }
}

///|
fn GraphqlTokenizer::read_number(self : GraphqlTokenizer) -> GraphqlToken {
  let start = self.pos

  // Sign
  if self.chars[self.pos] == '-' {
    self.pos += 1
  }

  // Integer part
  while self.pos < self.len && is_digit(self.chars[self.pos]) {
    self.pos += 1
  }

  // Decimal part
  if self.pos < self.len &&
    self.chars[self.pos] == '.' &&
    self.pos + 1 < self.len &&
    is_digit(self.chars[self.pos + 1]) {
    self.pos += 1
    while self.pos < self.len && is_digit(self.chars[self.pos]) {
      self.pos += 1
    }
  }

  // Exponent
  if self.pos < self.len &&
    (self.chars[self.pos] == 'e' || self.chars[self.pos] == 'E') {
    self.pos += 1
    if self.pos < self.len &&
      (self.chars[self.pos] == '+' || self.chars[self.pos] == '-') {
      self.pos += 1
    }
    while self.pos < self.len && is_digit(self.chars[self.pos]) {
      self.pos += 1
    }
  }
  { token_type: Number, from: start, to: self.pos }
}

///|
fn GraphqlTokenizer::read_name(self : GraphqlTokenizer) -> GraphqlToken {
  let start = self.pos
  let first = self.chars[self.pos]
  while self.pos < self.len && is_name_char(self.chars[self.pos]) {
    self.pos += 1
  }
  let value = String::from_array(self.chars[start:self.pos])
  let token_type = if value == "true" || value == "false" {
    Bool
  } else if value == "null" {
    Null
  } else if graphql_keywords.contains(value) {
    Keyword
  } else if graphql_type_keywords.contains(value) {
    TypeKeyword
  } else if graphql_directive_keywords.contains(value) {
    DirectiveKeyword
  } else if first >= 'A' && first <= 'Z' {
    TypeName
  } else {
    Name
  }
  { token_type, from: start, to: self.pos }
}

///|
pub fn GraphqlTokenizer::next_token(self : GraphqlTokenizer) -> GraphqlToken? {
  if self.pos >= self.len {
    return None
  }
  let start = self.pos
  let c = self.chars[self.pos]

  // Whitespace (including comma which is insignificant in GraphQL)
  if c == ' ' || c == '\t' || c == '\r' || c == ',' {
    while self.pos < self.len {
      let ch = self.chars[self.pos]
      if ch == ' ' || ch == '\t' || ch == '\r' || ch == ',' {
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

  // Comment
  if c == '#' {
    while self.pos < self.len && self.chars[self.pos] != '\n' {
      self.pos += 1
    }
    return Some({ token_type: Comment, from: start, to: self.pos })
  }

  // String
  if c == '"' {
    return Some(self.read_string())
  }

  // Number
  if is_digit(c) || (c == '-' && self.peek_at(1).map(is_digit).unwrap_or(false)) {
    return Some(self.read_number())
  }

  // Variable
  if c == '$' {
    self.pos += 1
    while self.pos < self.len && is_name_char(self.chars[self.pos]) {
      self.pos += 1
    }
    return Some({ token_type: Variable, from: start, to: self.pos })
  }

  // Directive
  if c == '@' {
    self.pos += 1
    while self.pos < self.len && is_name_char(self.chars[self.pos]) {
      self.pos += 1
    }
    return Some({ token_type: Directive, from: start, to: self.pos })
  }

  // Spread
  if c == '.' && self.peek_at(1) == Some('.') && self.peek_at(2) == Some('.') {
    self.pos += 3
    return Some({ token_type: Spread, from: start, to: self.pos })
  }

  // Name
  if is_name_start(c) {
    return Some(self.read_name())
  }

  // Single-char tokens
  let token_type = match c {
    '(' => ParenOpen
    ')' => ParenClose
    '[' => BracketOpen
    ']' => BracketClose
    '{' => BraceOpen
    '}' => BraceClose
    ':' => Colon
    '=' => Equals
    '!' => Bang
    '|' => Pipe
    '&' => Amp
    _ => Unknown
  }
  self.pos += 1
  Some({ token_type, from: start, to: self.pos })
}

///|
pub fn GraphqlTokenizer::tokenize_all(
  self : GraphqlTokenizer,
) -> Array[GraphqlToken] {
  let tokens : Array[GraphqlToken] = []
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
