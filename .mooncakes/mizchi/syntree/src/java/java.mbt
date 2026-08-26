///|
/// Java Tokenizer
pub(all) enum JavaTokenType {
  Keyword
  Modifier
  String
  TextBlock
  Char
  Number
  Identifier
  TypeKeyword
  TypeName
  Annotation
  Operator
  Comparison
  Assignment
  Logical
  Bitwise
  Increment
  Ternary
  Arrow
  DoubleColon
  ParenOpen
  ParenClose
  BracketOpen
  BracketClose
  BraceOpen
  BraceClose
  Comma
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
pub(all) struct JavaToken {
  token_type : JavaTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct JavaTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
let java_keywords : Array[String] = [
  "if", "else", "for", "while", "do", "switch", "case", "default", "break", "continue",
  "return", "throw", "throws", "try", "catch", "finally", "new", "instanceof", "this",
  "super", "class", "interface", "enum", "extends", "implements", "import", "package",
  "true", "false", "null", "assert", "synchronized", "volatile", "transient", "native",
  "record", "sealed", "permits", "yield", "var",
]

///|
let java_modifiers : Array[String] = [
  "public", "private", "protected", "static", "final", "abstract", "default",
]

///|
let java_type_keywords : Array[String] = [
  "void", "boolean", "byte", "char", "short", "int", "long", "float", "double",
]

///|
pub fn JavaTokenizer::new(input : String) -> JavaTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
fn JavaTokenizer::peek_at(self : JavaTokenizer, offset : Int) -> Char? {
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
fn JavaTokenizer::read_string(self : JavaTokenizer) -> JavaToken {
  let start = self.pos
  self.pos += 1

  // Check for text block
  let is_text_block = self.peek_at(0) == Some('"') &&
    self.peek_at(1) == Some('"')
  if is_text_block {
    self.pos += 2
    while self.pos < self.len && self.chars[self.pos] != '\n' {
      self.pos += 1
    }
    if self.pos < self.len && self.chars[self.pos] == '\n' {
      self.pos += 1
    }
    while self.pos < self.len {
      if self.chars[self.pos] == '"' &&
        self.peek_at(1) == Some('"') &&
        self.peek_at(2) == Some('"') {
        self.pos += 3
        break
      }
      self.pos += 1
    }
    return { token_type: TextBlock, from: start, to: self.pos }
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
fn JavaTokenizer::read_char(self : JavaTokenizer) -> JavaToken {
  let start = self.pos
  self.pos += 1
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
fn JavaTokenizer::read_number(self : JavaTokenizer) -> JavaToken {
  let start = self.pos
  if self.chars[self.pos] == '0' && self.pos + 1 < self.len {
    let next = self.chars[self.pos + 1]
    if next == 'x' || next == 'X' || next == 'b' || next == 'B' {
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
      // Suffix
      if self.pos < self.len &&
        (self.chars[self.pos] == 'l' || self.chars[self.pos] == 'L') {
        self.pos += 1
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

  // Suffix
  if self.pos < self.len {
    let s = self.chars[self.pos]
    if s == 'l' || s == 'L' || s == 'f' || s == 'F' || s == 'd' || s == 'D' {
      self.pos += 1
    }
  }
  { token_type: Number, from: start, to: self.pos }
}

///|
fn JavaTokenizer::read_identifier(self : JavaTokenizer) -> JavaToken {
  let start = self.pos
  let first = self.chars[self.pos]
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }
  let value = String::from_array(self.chars[start:self.pos])
  let token_type = if java_keywords.contains(value) {
    Keyword
  } else if java_modifiers.contains(value) {
    Modifier
  } else if java_type_keywords.contains(value) {
    TypeKeyword
  } else if first >= 'A' && first <= 'Z' {
    TypeName
  } else {
    Identifier
  }
  { token_type, from: start, to: self.pos }
}

///|
pub fn JavaTokenizer::next_token(self : JavaTokenizer) -> JavaToken? {
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
      let is_doc = self.pos < self.len &&
        self.chars[self.pos] == '*' &&
        self.peek_at(1) != Some('/')
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

  // String
  if c == '"' {
    return Some(self.read_string())
  }

  // Char
  if c == '\'' {
    return Some(self.read_char())
  }

  // Number
  if is_digit(c) {
    return Some(self.read_number())
  }

  // Annotation
  if c == '@' {
    self.pos += 1
    while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
      self.pos += 1
    }
    return Some({ token_type: Annotation, from: start, to: self.pos })
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
    if three_char == ">>>" || three_char == "<<=" || three_char == ">>=" {
      self.pos += 3
      let token_type = if three_char == ">>>" { Bitwise } else { Assignment }
      return Some({ token_type, from: start, to: self.pos })
    }
  }
  match two_char {
    "->" => {
      self.pos += 2
      return Some({ token_type: Arrow, from: start, to: self.pos })
    }
    "::" => {
      self.pos += 2
      return Some({ token_type: DoubleColon, from: start, to: self.pos })
    }
    "==" | "!=" | "<=" | ">=" => {
      self.pos += 2
      return Some({ token_type: Comparison, from: start, to: self.pos })
    }
    "&&" | "||" => {
      self.pos += 2
      return Some({ token_type: Logical, from: start, to: self.pos })
    }
    "++" | "--" => {
      self.pos += 2
      return Some({ token_type: Increment, from: start, to: self.pos })
    }
    "+=" | "-=" | "*=" | "/=" | "%=" | "&=" | "|=" | "^=" => {
      self.pos += 2
      return Some({ token_type: Assignment, from: start, to: self.pos })
    }
    "<<" | ">>" => {
      self.pos += 2
      return Some({ token_type: Bitwise, from: start, to: self.pos })
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
    ';' => Semicolon
    '.' => Dot
    '+' | '-' | '*' | '/' | '%' => Operator
    '<' | '>' => Comparison
    '=' => Assignment
    '!' => Logical
    '&' | '|' | '^' | '~' => Bitwise
    '?' | ':' => Ternary
    _ => Unknown
  }
  self.pos += 1
  Some({ token_type, from: start, to: self.pos })
}

///|
pub fn JavaTokenizer::tokenize_all(self : JavaTokenizer) -> Array[JavaToken] {
  let tokens : Array[JavaToken] = []
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
