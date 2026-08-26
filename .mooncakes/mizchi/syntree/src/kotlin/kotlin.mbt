///|
/// Kotlin Tokenizer
pub(all) enum KotlinTokenType {
  Keyword
  DeclKeyword
  Modifier
  String
  MultilineString
  StringTemplate
  Char
  Number
  Bool
  Null
  Identifier
  TypeName
  Annotation
  Label
  Operator
  Comparison
  Assignment
  Logical
  Range
  Elvis
  SafeCall
  NotNull
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
  LineComment
  BlockComment
  DocComment
  Whitespace
  Newline
  Unknown
} derive(Eq, Show)

///|
pub(all) struct KotlinToken {
  token_type : KotlinTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct KotlinTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
let kotlin_keywords : Array[String] = [
  "if", "else", "when", "for", "while", "do", "break", "continue", "return", "throw",
  "try", "catch", "finally", "is", "in", "as", "this", "super", "typeof", "by", "where",
  "get", "set", "init", "constructor", "companion", "object", "it",
]

///|
let kotlin_decl_keywords : Array[String] = [
  "fun", "val", "var", "class", "interface", "enum", "sealed", "data", "annotation",
  "typealias", "import", "package",
]

///|
let kotlin_modifiers : Array[String] = [
  "public", "private", "protected", "internal", "open", "final", "abstract", "override",
  "lateinit", "inline", "noinline", "crossinline", "reified", "suspend", "tailrec",
  "operator", "infix", "external", "const", "inner", "out", "vararg", "expect", "actual",
]

///|
pub fn KotlinTokenizer::new(input : String) -> KotlinTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
fn KotlinTokenizer::peek_at(self : KotlinTokenizer, offset : Int) -> Char? {
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
fn KotlinTokenizer::read_string(self : KotlinTokenizer) -> KotlinToken {
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
    } else if c == '$' {
      // String template - just continue
      self.pos += 1
    } else {
      self.pos += 1
    }
  }
  { token_type: String, from: start, to: self.pos }
}

///|
fn KotlinTokenizer::read_char(self : KotlinTokenizer) -> KotlinToken {
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
fn KotlinTokenizer::read_number(self : KotlinTokenizer) -> KotlinToken {
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
    } else if next == 'b' || next == 'B' {
      self.pos += 2
      while self.pos < self.len {
        let c = self.chars[self.pos]
        if c == '0' || c == '1' || c == '_' {
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
fn KotlinTokenizer::read_number_suffix(self : KotlinTokenizer) -> Unit {
  if self.pos < self.len {
    let c = self.chars[self.pos]
    if c == 'L' || c == 'f' || c == 'F' || c == 'u' || c == 'U' {
      self.pos += 1
    }
  }
}

///|
fn KotlinTokenizer::read_identifier(self : KotlinTokenizer) -> KotlinToken {
  let start = self.pos
  let first = self.chars[self.pos]
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }

  // Check for label
  if self.pos < self.len && self.chars[self.pos] == '@' {
    self.pos += 1
    return { token_type: Label, from: start, to: self.pos }
  }
  let value = String::from_array(self.chars[start:self.pos])
  let token_type = if value == "true" || value == "false" {
    Bool
  } else if value == "null" {
    Null
  } else if kotlin_keywords.contains(value) {
    Keyword
  } else if kotlin_decl_keywords.contains(value) {
    DeclKeyword
  } else if kotlin_modifiers.contains(value) {
    Modifier
  } else if first >= 'A' && first <= 'Z' {
    TypeName
  } else {
    Identifier
  }
  { token_type, from: start, to: self.pos }
}

///|
pub fn KotlinTokenizer::next_token(self : KotlinTokenizer) -> KotlinToken? {
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

  // Char
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

  // Multi-char operators
  let c2 = self.peek_at(1)
  let two_char = match c2 {
    Some(ch) => c.to_string() + ch.to_string()
    None => ""
  }
  match two_char {
    "->" => {
      self.pos += 2
      return Some({ token_type: Arrow, from: start, to: self.pos })
    }
    "?:" => {
      self.pos += 2
      return Some({ token_type: Elvis, from: start, to: self.pos })
    }
    "?." => {
      self.pos += 2
      return Some({ token_type: SafeCall, from: start, to: self.pos })
    }
    "!!" => {
      self.pos += 2
      return Some({ token_type: NotNull, from: start, to: self.pos })
    }
    ".." => {
      self.pos += 2
      return Some({ token_type: Range, from: start, to: self.pos })
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
    ';' => Semicolon
    ':' => Colon
    '.' => Dot
    '+' | '-' | '*' | '/' | '%' => Operator
    '<' | '>' => Comparison
    '=' => Assignment
    '!' => Logical
    '?' => Operator
    _ => Unknown
  }
  self.pos += 1
  Some({ token_type, from: start, to: self.pos })
}

///|
pub fn KotlinTokenizer::tokenize_all(
  self : KotlinTokenizer,
) -> Array[KotlinToken] {
  let tokens : Array[KotlinToken] = []
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
