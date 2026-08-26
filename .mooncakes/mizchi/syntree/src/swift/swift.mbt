///|
/// Swift Tokenizer
pub(all) enum SwiftTokenType {
  Keyword
  DeclKeyword
  Modifier
  String
  MultilineString
  StringInterp
  Number
  Bool
  Identifier
  TypeName
  Attribute
  Operator
  Comparison
  Assignment
  Logical
  Range
  Optional
  Arrow
  ParenOpen
  ParenClose
  BracketOpen
  BracketClose
  BraceOpen
  BraceClose
  Comma
  Colon
  Semicolon
  Dot
  LineComment
  BlockComment
  DocComment
  Whitespace
  Newline
  Unknown
} derive(Eq, Show)

///|
pub(all) struct SwiftToken {
  token_type : SwiftTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct SwiftTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
let swift_keywords : Array[String] = [
  "if", "else", "guard", "switch", "case", "default", "where", "for", "while", "repeat",
  "do", "break", "continue", "fallthrough", "return", "throw", "throws", "try", "catch",
  "defer", "as", "is", "in", "nil", "self", "Self", "super", "init", "deinit", "get",
  "set", "async", "await",
]

///|
let swift_decl_keywords : Array[String] = [
  "var", "let", "func", "class", "struct", "enum", "protocol", "extension", "import",
  "operator", "typealias",
]

///|
let swift_modifiers : Array[String] = [
  "public", "private", "internal", "fileprivate", "open", "static", "final", "override",
  "required", "convenience", "lazy", "weak", "unowned", "mutating",
]

///|
pub fn SwiftTokenizer::new(input : String) -> SwiftTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
fn SwiftTokenizer::peek_at(self : SwiftTokenizer, offset : Int) -> Char? {
  let idx = self.pos + offset
  if idx >= 0 && idx < self.len {
    Some(self.chars[idx])
  } else {
    None
  }
}

///|
fn is_id_start(c : Char) -> Bool {
  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_'
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
fn SwiftTokenizer::read_string(self : SwiftTokenizer) -> SwiftToken {
  let start = self.pos
  self.pos += 1
  let is_multiline = self.peek_at(0) == Some('"') &&
    self.peek_at(1) == Some('"')
  if is_multiline {
    self.pos += 2
  }
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '\\' {
      self.pos += 2
    } else if c == '"' {
      if is_multiline {
        if self.peek_at(1) == Some('"') && self.peek_at(2) == Some('"') {
          self.pos += 3
          break
        } else {
          self.pos += 1
        }
      } else {
        self.pos += 1
        break
      }
    } else {
      self.pos += 1
    }
  }
  let token_type = if is_multiline { MultilineString } else { String }
  { token_type, from: start, to: self.pos }
}

///|
fn SwiftTokenizer::read_number(self : SwiftTokenizer) -> SwiftToken {
  let start = self.pos
  if self.chars[self.pos] == '0' && self.pos + 1 < self.len {
    let next = self.chars[self.pos + 1]
    if next == 'x' ||
      next == 'X' ||
      next == 'b' ||
      next == 'B' ||
      next == 'o' ||
      next == 'O' {
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
  { token_type: Number, from: start, to: self.pos }
}

///|
fn SwiftTokenizer::read_identifier(self : SwiftTokenizer) -> SwiftToken {
  let start = self.pos
  let first = self.chars[self.pos]
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }
  let value = String::from_array(self.chars[start:self.pos])
  let token_type = if value == "true" || value == "false" {
    Bool
  } else if swift_keywords.contains(value) {
    Keyword
  } else if swift_decl_keywords.contains(value) {
    DeclKeyword
  } else if swift_modifiers.contains(value) {
    Modifier
  } else if first >= 'A' && first <= 'Z' {
    TypeName
  } else {
    Identifier
  }
  { token_type, from: start, to: self.pos }
}

///|
pub fn SwiftTokenizer::next_token(self : SwiftTokenizer) -> SwiftToken? {
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
      let is_doc = self.peek_at(2) == Some('/')
      while self.pos < self.len && self.chars[self.pos] != '\n' {
        self.pos += 1
      }
      let token_type = if is_doc { DocComment } else { LineComment }
      return Some({ token_type, from: start, to: self.pos })
    } else if self.peek_at(1) == Some('*') {
      self.pos += 2
      while self.pos < self.len {
        if self.chars[self.pos] == '*' && self.peek_at(1) == Some('/') {
          self.pos += 2
          break
        }
        self.pos += 1
      }
      return Some({ token_type: BlockComment, from: start, to: self.pos })
    }
  }

  // String
  if c == '"' {
    return Some(self.read_string())
  }

  // Number
  if is_digit(c) {
    return Some(self.read_number())
  }

  // Attribute
  if c == '@' {
    self.pos += 1
    while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
      self.pos += 1
    }
    return Some({ token_type: Attribute, from: start, to: self.pos })
  }

  // Identifier
  if is_id_start(c) {
    return Some(self.read_identifier())
  }

  // Multi-char operators
  let c2 = self.peek_at(1)
  let two_char = match c2 {
    Some(ch) => c.to_string() + ch.to_string()
    None => ""
  }

  // Three-char operators
  if self.pos + 2 < self.len {
    let c3 = self.chars[self.pos + 2]
    let three_char = two_char + c3.to_string()
    if three_char == "..." || three_char == "..<" {
      self.pos += 3
      return Some({ token_type: Range, from: start, to: self.pos })
    }
  }
  match two_char {
    "->" | "=>" => {
      self.pos += 2
      return Some({ token_type: Arrow, from: start, to: self.pos })
    }
    "==" | "!=" | "<=" | ">=" => {
      self.pos += 2
      return Some({ token_type: Comparison, from: start, to: self.pos })
    }
    "&&" | "||" => {
      self.pos += 2
      return Some({ token_type: Logical, from: start, to: self.pos })
    }
    "+=" | "-=" | "*=" | "/=" | "%=" => {
      self.pos += 2
      return Some({ token_type: Assignment, from: start, to: self.pos })
    }
    _ => ()
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
    ':' => Colon
    ';' => Semicolon
    '.' => Dot
    '+' | '-' | '*' | '/' | '%' | '&' | '|' | '^' | '~' => Operator
    '<' | '>' => Comparison
    '=' => Assignment
    '!' => Logical
    '?' => Optional
    _ => Unknown
  }
  self.pos += 1
  Some({ token_type, from: start, to: self.pos })
}

///|
pub fn SwiftTokenizer::tokenize_all(self : SwiftTokenizer) -> Array[SwiftToken] {
  let tokens : Array[SwiftToken] = []
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
