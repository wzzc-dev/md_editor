///|
/// Lua Tokenizer
pub(all) enum LuaTokenType {
  Keyword
  String
  LongString
  Number
  Bool
  Nil
  Identifier
  Operator
  Comparison
  Assignment
  Logical
  Concat
  Length
  Vararg
  ParenOpen
  ParenClose
  BracketOpen
  BracketClose
  BraceOpen
  BraceClose
  Comma
  Semicolon
  Colon
  DoubleColon
  Dot
  LineComment
  BlockComment
  Whitespace
  Newline
  Unknown
} derive(Eq, Show)

///|
pub(all) struct LuaToken {
  token_type : LuaTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct LuaTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
let lua_keywords : Array[String] = [
  "and", "break", "do", "else", "elseif", "end", "for", "function", "goto", "if",
  "in", "local", "not", "or", "repeat", "return", "then", "until", "while",
]

///|
pub fn LuaTokenizer::new(input : String) -> LuaTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
fn LuaTokenizer::peek_at(self : LuaTokenizer, offset : Int) -> Char? {
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
fn LuaTokenizer::count_equals(self : LuaTokenizer) -> Int {
  let mut count = 0
  while self.pos + count < self.len && self.chars[self.pos + count] == '=' {
    count += 1
  }
  count
}

///|
fn LuaTokenizer::read_long_string(self : LuaTokenizer) -> LuaToken {
  let start = self.pos
  self.pos += 1 // skip [
  let equals = self.count_equals()
  self.pos += equals
  if self.pos < self.len && self.chars[self.pos] == '[' {
    self.pos += 1
    // Read until ]=*]
    while self.pos < self.len {
      if self.chars[self.pos] == ']' {
        self.pos += 1
        let close_equals = self.count_equals()
        if close_equals == equals &&
          self.pos < self.len &&
          self.chars[self.pos] == ']' {
          self.pos += 1
          break
        }
      } else {
        self.pos += 1
      }
    }
  }
  { token_type: LongString, from: start, to: self.pos }
}

///|
fn LuaTokenizer::read_string(self : LuaTokenizer, quote : Char) -> LuaToken {
  let start = self.pos
  self.pos += 1
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
fn LuaTokenizer::read_number(self : LuaTokenizer) -> LuaToken {
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
      // Hex float
      if self.pos < self.len &&
        (self.chars[self.pos] == 'p' || self.chars[self.pos] == 'P') {
        self.pos += 1
        if self.pos < self.len &&
          (self.chars[self.pos] == '+' || self.chars[self.pos] == '-') {
          self.pos += 1
        }
        while self.pos < self.len && is_digit(self.chars[self.pos]) {
          self.pos += 1
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
fn LuaTokenizer::read_identifier(self : LuaTokenizer) -> LuaToken {
  let start = self.pos
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }
  let value = String::from_array(self.chars[start:self.pos])
  let token_type = if value == "true" || value == "false" {
    Bool
  } else if value == "nil" {
    Nil
  } else if value == "and" || value == "or" || value == "not" {
    Logical
  } else if lua_keywords.contains(value) {
    Keyword
  } else {
    Identifier
  }
  { token_type, from: start, to: self.pos }
}

///|
fn LuaTokenizer::read_long_comment(self : LuaTokenizer) -> LuaToken {
  let start = self.pos
  self.pos += 2 // skip --
  if self.pos < self.len && self.chars[self.pos] == '[' {
    self.pos += 1
    let equals = self.count_equals()
    if self.pos < self.len && self.chars[self.pos] == '[' {
      self.pos += 1
      // Read until ]=*]
      while self.pos < self.len {
        if self.chars[self.pos] == ']' {
          self.pos += 1
          let close_equals = self.count_equals()
          if close_equals == equals &&
            self.pos < self.len &&
            self.chars[self.pos] == ']' {
            self.pos += 1
            return { token_type: BlockComment, from: start, to: self.pos }
          }
        } else {
          self.pos += 1
        }
      }
      return { token_type: BlockComment, from: start, to: self.pos }
    }
    self.pos = start + 2 // reset to after --
  }
  // Line comment
  while self.pos < self.len && self.chars[self.pos] != '\n' {
    self.pos += 1
  }
  { token_type: LineComment, from: start, to: self.pos }
}

///|
pub fn LuaTokenizer::next_token(self : LuaTokenizer) -> LuaToken? {
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

  // Comment
  if c == '-' && self.peek_at(1) == Some('-') {
    return Some(self.read_long_comment())
  }

  // Long string
  if c == '[' && (self.peek_at(1) == Some('[') || self.peek_at(1) == Some('=')) {
    return Some(self.read_long_string())
  }

  // String
  if c == '"' || c == '\'' {
    return Some(self.read_string(c))
  }

  // Number
  if is_digit(c) || (c == '.' && self.peek_at(1).map(is_digit).unwrap_or(false)) {
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
    "::" => {
      self.pos += 2
      return Some({ token_type: DoubleColon, from: start, to: self.pos })
    }
    ".." => {
      if self.peek_at(2) == Some('.') {
        self.pos += 3
        return Some({ token_type: Vararg, from: start, to: self.pos })
      }
      self.pos += 2
      return Some({ token_type: Concat, from: start, to: self.pos })
    }
    "==" | "~=" | "<=" | ">=" => {
      self.pos += 2
      return Some({ token_type: Comparison, from: start, to: self.pos })
    }
    "<<" | ">>" | "//" => {
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
    '#' => Length
    '+' | '-' | '*' | '/' | '%' | '^' | '&' | '|' | '~' => Operator
    '<' | '>' => Comparison
    '=' => Assignment
    _ => Unknown
  }
  self.pos += 1
  Some({ token_type, from: start, to: self.pos })
}

///|
pub fn LuaTokenizer::tokenize_all(self : LuaTokenizer) -> Array[LuaToken] {
  let tokens : Array[LuaToken] = []
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
