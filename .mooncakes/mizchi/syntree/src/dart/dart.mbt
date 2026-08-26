///|
/// Dart Tokenizer
pub(all) enum DartTokenType {
  Keyword
  DeclKeyword
  Modifier
  BuiltinType
  String
  MultilineString
  RawString
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
  Bitwise
  Increment
  NullAware
  Cascade
  Arrow
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
  Question
  LineComment
  BlockComment
  DocComment
  Whitespace
  Newline
  Unknown
} derive(Eq, Show)

///|
pub(all) struct DartToken {
  token_type : DartTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct DartTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
let dart_keywords : Array[String] = [
  "if", "else", "for", "while", "do", "switch", "case", "default", "break", "continue",
  "return", "throw", "try", "catch", "finally", "on", "rethrow", "assert", "new",
  "const", "final", "var", "is", "as", "in", "this", "super", "true", "false", "null",
  "await", "async", "sync", "yield", "with", "show", "hide", "deferred", "import",
  "export", "library", "part", "of",
]

///|
let dart_decl_keywords : Array[String] = [
  "class", "enum", "extends", "implements", "mixin", "abstract", "interface", "typedef",
  "extension", "sealed", "base", "factory", "operator", "get", "set",
]

///|
let dart_modifiers : Array[String] = [
  "static", "final", "const", "late", "required", "covariant", "external",
]

///|
let dart_builtin_types : Array[String] = [
  "void", "dynamic", "Object", "int", "double", "num", "bool", "String", "List",
  "Map", "Set", "Future", "Stream", "Iterable", "Function", "Never",
]

///|
pub fn DartTokenizer::new(input : String) -> DartTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
fn DartTokenizer::peek_at(self : DartTokenizer, offset : Int) -> Char? {
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
fn DartTokenizer::read_string(self : DartTokenizer, quote : Char) -> DartToken {
  let start = self.pos
  self.pos += 1

  // Check for multiline string
  let is_multiline = self.peek_at(0) == Some(quote) &&
    self.peek_at(1) == Some(quote)
  if is_multiline {
    self.pos += 2
    while self.pos < self.len {
      let c = self.chars[self.pos]
      if c == '\\' {
        self.pos += 2
      } else if c == quote &&
        self.peek_at(1) == Some(quote) &&
        self.peek_at(2) == Some(quote) {
        self.pos += 3
        break
      } else {
        self.pos += 1
      }
    }
    return { token_type: MultilineString, from: start, to: self.pos }
  }
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '\\' {
      self.pos += 2
    } else if c == quote {
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
fn DartTokenizer::read_raw_string(
  self : DartTokenizer,
  quote : Char,
) -> DartToken {
  let start = self.pos
  self.pos += 2 // skip r" or r'

  // Check for multiline
  let is_multiline = self.peek_at(0) == Some(quote) &&
    self.peek_at(1) == Some(quote)
  if is_multiline {
    self.pos += 2
    while self.pos < self.len {
      if self.chars[self.pos] == quote &&
        self.peek_at(1) == Some(quote) &&
        self.peek_at(2) == Some(quote) {
        self.pos += 3
        break
      }
      self.pos += 1
    }
  } else {
    while self.pos < self.len &&
          self.chars[self.pos] != quote &&
          self.chars[self.pos] != '\n' {
      self.pos += 1
    }
    if self.pos < self.len && self.chars[self.pos] == quote {
      self.pos += 1
    }
  }
  { token_type: RawString, from: start, to: self.pos }
}

///|
fn DartTokenizer::read_number(self : DartTokenizer) -> DartToken {
  let start = self.pos
  if self.chars[self.pos] == '0' && self.pos + 1 < self.len {
    let next = self.chars[self.pos + 1]
    if next == 'x' || next == 'X' {
      self.pos += 2
      while self.pos < self.len {
        let c = self.chars[self.pos]
        if (c >= '0' && c <= '9') ||
          (c >= 'a' && c <= 'f') ||
          (c >= 'A' && c <= 'F') {
          self.pos += 1
        } else {
          break
        }
      }
      return { token_type: Number, from: start, to: self.pos }
    }
  }
  while self.pos < self.len && is_digit(self.chars[self.pos]) {
    self.pos += 1
  }
  if self.pos < self.len &&
    self.chars[self.pos] == '.' &&
    self.pos + 1 < self.len &&
    is_digit(self.chars[self.pos + 1]) {
    self.pos += 1
    while self.pos < self.len && is_digit(self.chars[self.pos]) {
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
    while self.pos < self.len && is_digit(self.chars[self.pos]) {
      self.pos += 1
    }
  }
  { token_type: Number, from: start, to: self.pos }
}

///|
fn DartTokenizer::read_identifier(self : DartTokenizer) -> DartToken {
  let start = self.pos
  let first = self.chars[self.pos]
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }

  // Check for raw string
  if self.pos - start == 1 && first == 'r' && self.pos < self.len {
    let next = self.chars[self.pos]
    if next == '"' || next == '\'' {
      return self.read_raw_string(next)
    }
  }
  let value = String::from_array(self.chars[start:self.pos])
  let token_type = if value == "true" || value == "false" {
    Bool
  } else if value == "null" {
    Null
  } else if dart_keywords.contains(value) {
    Keyword
  } else if dart_decl_keywords.contains(value) {
    DeclKeyword
  } else if dart_modifiers.contains(value) {
    Modifier
  } else if dart_builtin_types.contains(value) {
    BuiltinType
  } else if first >= 'A' && first <= 'Z' {
    TypeName
  } else {
    Identifier
  }
  { token_type, from: start, to: self.pos }
}

///|
pub fn DartTokenizer::next_token(self : DartTokenizer) -> DartToken? {
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
  if c == '"' || c == '\'' {
    return Some(self.read_string(c))
  }

  // Number
  if is_digit(c) {
    return Some(self.read_number())
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
  match two_char {
    "=>" => {
      self.pos += 2
      return Some({ token_type: Arrow, from: start, to: self.pos })
    }
    ".." => {
      self.pos += 2
      return Some({ token_type: Cascade, from: start, to: self.pos })
    }
    "??" | "?." => {
      self.pos += 2
      return Some({ token_type: NullAware, from: start, to: self.pos })
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
    "+=" | "-=" | "*=" | "/=" | "%=" | "&=" | "|=" | "^=" | "~/=" => {
      self.pos += 2
      return Some({ token_type: Assignment, from: start, to: self.pos })
    }
    "<<" | ">>" | "~/" => {
      self.pos += 2
      return Some({ token_type: Operator, from: start, to: self.pos })
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
    ':' => Colon
    '.' => Dot
    '?' => Question
    '+' | '-' | '*' | '/' | '%' | '~' => Operator
    '<' | '>' => Comparison
    '=' => Assignment
    '!' => Logical
    '&' | '|' | '^' => Bitwise
    _ => Unknown
  }
  self.pos += 1
  Some({ token_type, from: start, to: self.pos })
}

///|
pub fn DartTokenizer::tokenize_all(self : DartTokenizer) -> Array[DartToken] {
  let tokens : Array[DartToken] = []
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
