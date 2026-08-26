///|
/// Scala Tokenizer
pub(all) enum ScalaTokenType {
  Keyword
  DeclKeyword
  Modifier
  String
  MultilineString
  StringInterp
  Char
  Symbol
  Number
  Bool
  Null
  Identifier
  TypeName
  Annotation
  Operator
  Comparison
  Assignment
  Logical
  Arrow
  TypeArrow
  Guard
  ParenOpen
  ParenClose
  BracketOpen
  BracketClose
  BraceOpen
  BraceClose
  Comma
  Semicolon
  Colon
  Dot
  Underscore
  LineComment
  BlockComment
  DocComment
  Whitespace
  Newline
  Unknown
} derive(Eq, Show)

///|
pub(all) struct ScalaToken {
  token_type : ScalaTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct ScalaTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
let scala_keywords : Array[String] = [
  "if", "else", "match", "case", "for", "while", "do", "return", "throw", "try",
  "catch", "finally", "new", "this", "super", "with", "extends", "yield", "import",
  "package", "true", "false", "null", "then", "given", "using", "export", "end",
  "enum", "derives", "extension", "infix", "transparent",
]

///|
let scala_decl_keywords : Array[String] = [
  "def", "val", "var", "class", "object", "trait", "type", "lazy",
]

///|
let scala_modifiers : Array[String] = [
  "private", "protected", "public", "abstract", "final", "sealed", "implicit", "override",
  "inline", "opaque", "open", "erased",
]

///|
pub fn ScalaTokenizer::new(input : String) -> ScalaTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
fn ScalaTokenizer::peek_at(self : ScalaTokenizer, offset : Int) -> Char? {
  let idx = self.pos + offset
  if idx >= 0 && idx < self.len {
    Some(self.chars[idx])
  } else {
    None
  }
}

///|
fn is_id_start(c : Char) -> Bool {
  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_' || c == '$'
}

///|
fn is_id_continue(c : Char) -> Bool {
  is_id_start(c) || (c >= '0' && c <= '9')
}

///|
fn is_digit(c : Char) -> Bool {
  c >= '0' && c <= '9'
}

///|
fn is_operator_char(c : Char) -> Bool {
  match c {
    '+'
    | '-'
    | '*'
    | '/'
    | '%'
    | '&'
    | '|'
    | '^'
    | '~'
    | '!'
    | '<'
    | '>'
    | '='
    | ':' => true
    _ => false
  }
}

///|
fn ScalaTokenizer::read_string(self : ScalaTokenizer) -> ScalaToken {
  let start = self.pos
  self.pos += 1

  // Check for multiline string
  let is_multiline = self.peek_at(0) == Some('"') &&
    self.peek_at(1) == Some('"')
  if is_multiline {
    self.pos += 2
    while self.pos < self.len {
      if self.chars[self.pos] == '"' &&
        self.peek_at(1) == Some('"') &&
        self.peek_at(2) == Some('"') {
        self.pos += 3
        break
      }
      self.pos += 1
    }
    return { token_type: MultilineString, from: start, to: self.pos }
  }
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '\\' {
      self.pos += 2
    } else if c == '"' {
      self.pos += 1
      break
    } else {
      self.pos += 1
    }
  }
  { token_type: String, from: start, to: self.pos }
}

///|
fn ScalaTokenizer::read_interpolated_string(
  self : ScalaTokenizer,
) -> ScalaToken {
  let start = self.pos
  // Skip prefix (s, f, raw, etc.)
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }
  if self.pos >= self.len || self.chars[self.pos] != '"' {
    return { token_type: Identifier, from: start, to: self.pos }
  }
  self.pos += 1

  // Check for multiline
  let is_multiline = self.peek_at(0) == Some('"') &&
    self.peek_at(1) == Some('"')
  if is_multiline {
    self.pos += 2
    while self.pos < self.len {
      if self.chars[self.pos] == '"' &&
        self.peek_at(1) == Some('"') &&
        self.peek_at(2) == Some('"') {
        self.pos += 3
        break
      }
      self.pos += 1
    }
  } else {
    while self.pos < self.len {
      let c = self.chars[self.pos]
      if c == '\\' {
        self.pos += 2
      } else if c == '"' {
        self.pos += 1
        break
      } else {
        self.pos += 1
      }
    }
  }
  { token_type: StringInterp, from: start, to: self.pos }
}

///|
fn ScalaTokenizer::read_char(self : ScalaTokenizer) -> ScalaToken {
  let start = self.pos
  self.pos += 1
  // Check for symbol 'identifier
  if self.pos < self.len && is_id_start(self.chars[self.pos]) {
    while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
      self.pos += 1
    }
    // If not followed by ', it's a symbol
    if self.pos >= self.len || self.chars[self.pos] != '\'' {
      return { token_type: Symbol, from: start, to: self.pos }
    }
    self.pos += 1
    return { token_type: Char, from: start, to: self.pos }
  }
  if self.pos < self.len && self.chars[self.pos] == '\\' {
    self.pos += 2
  } else if self.pos < self.len {
    self.pos += 1
  }
  if self.pos < self.len && self.chars[self.pos] == '\'' {
    self.pos += 1
  }
  { token_type: Char, from: start, to: self.pos }
}

///|
fn ScalaTokenizer::read_number(self : ScalaTokenizer) -> ScalaToken {
  let start = self.pos
  if self.chars[self.pos] == '0' && self.pos + 1 < self.len {
    let next = self.chars[self.pos + 1]
    if next == 'x' || next == 'X' {
      self.pos += 2
      while self.pos < self.len {
        let c = self.chars[self.pos]
        if (c >= '0' && c <= '9') ||
          (c >= 'a' && c <= 'f') ||
          (c >= 'A' && c <= 'F') ||
          c == '_' {
          self.pos += 1
        } else {
          break
        }
      }
      self.read_number_suffix()
      return { token_type: Number, from: start, to: self.pos }
    }
  }
  while self.pos < self.len &&
        (is_digit(self.chars[self.pos]) || self.chars[self.pos] == '_') {
    self.pos += 1
  }
  if self.pos < self.len &&
    self.chars[self.pos] == '.' &&
    self.pos + 1 < self.len &&
    is_digit(self.chars[self.pos + 1]) {
    self.pos += 1
    while self.pos < self.len &&
          (is_digit(self.chars[self.pos]) || self.chars[self.pos] == '_') {
      self.pos += 1
    }
  }
  if self.pos < self.len &&
    (self.chars[self.pos] == 'e' || self.chars[self.pos] == 'E') {
    self.pos += 1
    if self.pos < self.len &&
      (self.chars[self.pos] == '+' || self.chars[self.pos] == '-') {
      self.pos += 1
    }
    while self.pos < self.len &&
          (is_digit(self.chars[self.pos]) || self.chars[self.pos] == '_') {
      self.pos += 1
    }
  }
  self.read_number_suffix()
  { token_type: Number, from: start, to: self.pos }
}

///|
fn ScalaTokenizer::read_number_suffix(self : ScalaTokenizer) -> Unit {
  if self.pos < self.len {
    let c = self.chars[self.pos]
    if c == 'L' || c == 'l' || c == 'F' || c == 'f' || c == 'D' || c == 'd' {
      self.pos += 1
    }
  }
}

///|
fn ScalaTokenizer::read_identifier(self : ScalaTokenizer) -> ScalaToken {
  let start = self.pos
  let first = self.chars[self.pos]
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }

  // Check for string interpolation prefix
  if self.pos < self.len && self.chars[self.pos] == '"' {
    let value = String::from_array(self.chars[start:self.pos])
    if value == "s" || value == "f" || value == "raw" {
      self.pos = start
      return self.read_interpolated_string()
    }
  }
  let value = String::from_array(self.chars[start:self.pos])
  let token_type = if value == "true" || value == "false" {
    Bool
  } else if value == "null" {
    Null
  } else if value == "_" {
    Underscore
  } else if scala_keywords.contains(value) {
    Keyword
  } else if scala_decl_keywords.contains(value) {
    DeclKeyword
  } else if scala_modifiers.contains(value) {
    Modifier
  } else if first >= 'A' && first <= 'Z' {
    TypeName
  } else {
    Identifier
  }
  { token_type, from: start, to: self.pos }
}

///|
fn ScalaTokenizer::read_operator(self : ScalaTokenizer) -> ScalaToken {
  let start = self.pos
  while self.pos < self.len && is_operator_char(self.chars[self.pos]) {
    self.pos += 1
  }
  let op = String::from_array(self.chars[start:self.pos])
  let token_type = match op {
    "=>" | "->" => Arrow
    "<:" | ">:" | "#" => TypeArrow
    "==" | "!=" | "<" | ">" | "<=" | ">=" => Comparison
    "&&" | "||" | "!" => Logical
    "=" | "+=" | "-=" | "*=" | "/=" | "%=" => Assignment
    _ => Operator
  }
  { token_type, from: start, to: self.pos }
}

///|
pub fn ScalaTokenizer::next_token(self : ScalaTokenizer) -> ScalaToken? {
  if self.pos >= self.len {
    return None
  }
  let start = self.pos
  let c = self.chars[self.pos]

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

  // Comments
  if c == '/' {
    if self.peek_at(1) == Some('/') {
      while self.pos < self.len && self.chars[self.pos] != '\n' {
        self.pos += 1
      }
      return Some({ token_type: LineComment, from: start, to: self.pos })
    } else if self.peek_at(1) == Some('*') {
      self.pos += 2
      let is_doc = self.pos < self.len && self.chars[self.pos] == '*'
      while self.pos < self.len {
        if self.chars[self.pos] == '*' && self.peek_at(1) == Some('/') {
          self.pos += 2
          break
        }
        self.pos += 1
      }
      let token_type = if is_doc { DocComment } else { BlockComment }
      return Some({ token_type, from: start, to: self.pos })
    }
  }

  // Annotation
  if c == '@' {
    self.pos += 1
    while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
      self.pos += 1
    }
    return Some({ token_type: Annotation, from: start, to: self.pos })
  }

  // String
  if c == '"' {
    return Some(self.read_string())
  }

  // Char or symbol
  if c == '\'' {
    return Some(self.read_char())
  }

  // Number
  if is_digit(c) {
    return Some(self.read_number())
  }

  // Identifier
  if is_id_start(c) {
    return Some(self.read_identifier())
  }

  // Backtick identifier
  if c == '`' {
    self.pos += 1
    while self.pos < self.len && self.chars[self.pos] != '`' {
      self.pos += 1
    }
    if self.pos < self.len {
      self.pos += 1
    }
    return Some({ token_type: Identifier, from: start, to: self.pos })
  }

  // Guard pattern
  if c == '|' && self.peek_at(1) != Some('|') && self.peek_at(1) != Some('=') {
    self.pos += 1
    return Some({ token_type: Guard, from: start, to: self.pos })
  }

  // Operators
  if is_operator_char(c) {
    return Some(self.read_operator())
  }

  // Single-char tokens
  let token_type = match c {
    '(' => ParenOpen
    ')' => ParenClose
    '[' => BracketOpen
    ']' => BracketClose
    '{' => BraceOpen
    '}' => BraceClose
    ',' => Comma
    ';' => Semicolon
    '.' => Dot
    _ => Unknown
  }
  self.pos += 1
  Some({ token_type, from: start, to: self.pos })
}

///|
pub fn ScalaTokenizer::tokenize_all(self : ScalaTokenizer) -> Array[ScalaToken] {
  let tokens : Array[ScalaToken] = []
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
