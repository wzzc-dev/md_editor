///|
/// Haskell Tokenizer
pub(all) enum HaskellTokenType {
  Keyword
  ModuleKeyword
  TypeKeyword
  String
  Char
  Number
  Bool
  Identifier
  TypeName
  TypeVar
  Constructor
  Operator
  Comparison
  Assignment
  Arrow
  FatArrow
  TypeArrow
  Constraint
  Guard
  Lambda
  ParenOpen
  ParenClose
  BracketOpen
  BracketClose
  BraceOpen
  BraceClose
  Comma
  Semicolon
  Backtick
  At
  Underscore
  LineComment
  BlockComment
  Pragma
  Whitespace
  Newline
  Unknown
} derive(Eq, Show)

///|
pub(all) struct HaskellToken {
  token_type : HaskellTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct HaskellTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
let haskell_keywords : Array[String] = [
  "case", "of", "if", "then", "else", "let", "in", "where", "do", "return", "deriving",
  "instance", "default", "forall", "mdo", "rec", "proc",
]

///|
let haskell_module_keywords : Array[String] = [
  "module", "import", "qualified", "as", "hiding", "export",
]

///|
let haskell_type_keywords : Array[String] = [
  "data", "type", "newtype", "class", "family", "infix", "infixl", "infixr",
]

///|
pub fn HaskellTokenizer::new(input : String) -> HaskellTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
fn HaskellTokenizer::peek_at(self : HaskellTokenizer, offset : Int) -> Char? {
  let idx = self.pos + offset
  if idx >= 0 && idx < self.len {
    Some(self.chars[idx])
  } else {
    None
  }
}

///|
fn is_lower(c : Char) -> Bool {
  (c >= 'a' && c <= 'z') || c == '_'
}

///|
fn is_upper(c : Char) -> Bool {
  c >= 'A' && c <= 'Z'
}

///|
fn is_id_start(c : Char) -> Bool {
  is_lower(c) || is_upper(c)
}

///|
fn is_id_continue(c : Char) -> Bool {
  is_id_start(c) || (c >= '0' && c <= '9') || c == '\''
}

///|
fn is_digit(c : Char) -> Bool {
  c >= '0' && c <= '9'
}

///|
fn is_operator_char(c : Char) -> Bool {
  match c {
    '!'
    | '#'
    | '$'
    | '%'
    | '&'
    | '*'
    | '+'
    | '.'
    | '/'
    | '<'
    | '='
    | '>'
    | '?'
    | '@'
    | '\\'
    | '^'
    | '|'
    | '-'
    | '~'
    | ':' => true
    _ => false
  }
}

///|
fn HaskellTokenizer::read_string(self : HaskellTokenizer) -> HaskellToken {
  let start = self.pos
  self.pos += 1
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
fn HaskellTokenizer::read_char(self : HaskellTokenizer) -> HaskellToken {
  let start = self.pos
  self.pos += 1
  if self.pos < self.len && self.chars[self.pos] == '\\' {
    self.pos += 1
    // Handle escape sequences
    if self.pos < self.len {
      self.pos += 1
    }
  } else if self.pos < self.len {
    self.pos += 1
  }
  if self.pos < self.len && self.chars[self.pos] == '\'' {
    self.pos += 1
  }
  { token_type: Char, from: start, to: self.pos }
}

///|
fn HaskellTokenizer::read_number(self : HaskellTokenizer) -> HaskellToken {
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
      return { token_type: Number, from: start, to: self.pos }
    } else if next == 'o' || next == 'O' {
      self.pos += 2
      while self.pos < self.len {
        let c = self.chars[self.pos]
        if (c >= '0' && c <= '7') || c == '_' {
          self.pos += 1
        } else {
          break
        }
      }
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
fn HaskellTokenizer::read_identifier(self : HaskellTokenizer) -> HaskellToken {
  let start = self.pos
  let first = self.chars[self.pos]
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }
  let value = String::from_array(self.chars[start:self.pos])
  let token_type = if value == "True" || value == "False" {
    Bool
  } else if haskell_keywords.contains(value) {
    Keyword
  } else if haskell_module_keywords.contains(value) {
    ModuleKeyword
  } else if haskell_type_keywords.contains(value) {
    TypeKeyword
  } else if is_upper(first) {
    Constructor
  } else if value == "_" {
    Underscore
  } else {
    Identifier
  }
  { token_type, from: start, to: self.pos }
}

///|
fn HaskellTokenizer::read_operator(self : HaskellTokenizer) -> HaskellToken {
  let start = self.pos

  // Check for special operators
  let c = self.chars[self.pos]

  // Lambda
  if c == '\\' {
    self.pos += 1
    return { token_type: Lambda, from: start, to: self.pos }
  }

  // Read operator chars
  while self.pos < self.len && is_operator_char(self.chars[self.pos]) {
    self.pos += 1
  }
  let op = String::from_array(self.chars[start:self.pos])
  let token_type = match op {
    "->" => Arrow
    "<-" => Assignment
    "=>" => Constraint
    "::" => TypeArrow
    "=" => Assignment
    "|" => Guard
    "==" | "/=" | "<" | ">" | "<=" | ">=" => Comparison
    _ if op.length() > 0 && op.iter().nth(0).unwrap() == ':' => Constructor
    _ => Operator
  }
  { token_type, from: start, to: self.pos }
}

///|
pub fn HaskellTokenizer::next_token(self : HaskellTokenizer) -> HaskellToken? {
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

  // Line comment
  if c == '-' && self.peek_at(1) == Some('-') {
    // Check if it's not an operator
    if self.peek_at(2).map(fn(x) { not(is_operator_char(x)) }).unwrap_or(true) {
      while self.pos < self.len && self.chars[self.pos] != '\n' {
        self.pos += 1
      }
      return Some({ token_type: LineComment, from: start, to: self.pos })
    }
  }

  // Block comment or pragma
  if c == '{' && self.peek_at(1) == Some('-') {
    self.pos += 2
    let is_pragma = self.pos < self.len && self.chars[self.pos] == '#'
    let mut depth = 1
    while self.pos < self.len && depth > 0 {
      if self.chars[self.pos] == '{' && self.peek_at(1) == Some('-') {
        depth += 1
        self.pos += 2
      } else if self.chars[self.pos] == '-' && self.peek_at(1) == Some('}') {
        depth -= 1
        self.pos += 2
      } else {
        self.pos += 1
      }
    }
    let token_type = if is_pragma { Pragma } else { BlockComment }
    return Some({ token_type, from: start, to: self.pos })
  }

  // String
  if c == '"' {
    return Some(self.read_string())
  }

  // Char
  if c == '\'' {
    // Check if it's a char or a type variable suffix
    if self.pos + 1 < self.len && is_id_start(self.chars[self.pos + 1]) {
      // Could be 'a (type var) - need more context, treat as char for now
      return Some(self.read_char())
    }
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

  // Backtick operator
  if c == '`' {
    self.pos += 1
    return Some({ token_type: Backtick, from: start, to: self.pos })
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
    '@' => At
    _ => Unknown
  }
  self.pos += 1
  Some({ token_type, from: start, to: self.pos })
}

///|
pub fn HaskellTokenizer::tokenize_all(
  self : HaskellTokenizer,
) -> Array[HaskellToken] {
  let tokens : Array[HaskellToken] = []
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
