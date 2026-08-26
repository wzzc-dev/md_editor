///|
/// OCaml Tokenizer
pub(all) enum OcamlTokenType {
  Keyword
  ModuleKeyword
  String
  Char
  Number
  Identifier
  TypeIdent
  ModuleName
  Constructor
  Label
  Operator
  Comparison
  Logical
  ListCons
  Concat
  Arrow
  Pipe
  Semicolon2
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
  Comment
  Whitespace
  Newline
  Unknown
} derive(Eq, Show)

///|
pub(all) struct OcamlToken {
  token_type : OcamlTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct OcamlTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
let ocaml_keywords : Array[String] = [
  "let", "in", "if", "then", "else", "match", "with", "when", "function", "fun",
  "rec", "and", "or", "not", "as", "of", "type", "val", "mutable", "begin", "end",
  "do", "done", "while", "for", "to", "downto", "try", "exception", "raise", "assert",
  "lazy", "new", "object", "method", "class", "inherit", "virtual", "private", "true",
  "false", "ref", "mod",
]

///|
let ocaml_module_keywords : Array[String] = [
  "module", "sig", "struct", "functor", "open", "include",
]

///|
pub fn OcamlTokenizer::new(input : String) -> OcamlTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
fn OcamlTokenizer::peek_at(self : OcamlTokenizer, offset : Int) -> Char? {
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
  is_id_start(c) || (c >= '0' && c <= '9') || c == '\''
}

///|
fn is_digit(c : Char) -> Bool {
  c >= '0' && c <= '9'
}

///|
fn is_operator_char(c : Char) -> Bool {
  c == '!' ||
  c == '$' ||
  c == '%' ||
  c == '&' ||
  c == '*' ||
  c == '+' ||
  c == '-' ||
  c == '.' ||
  c == '/' ||
  c == ':' ||
  c == '<' ||
  c == '=' ||
  c == '>' ||
  c == '?' ||
  c == '@' ||
  c == '^' ||
  c == '|' ||
  c == '~'
}

///|
fn OcamlTokenizer::read_comment(self : OcamlTokenizer) -> OcamlToken {
  let start = self.pos
  self.pos += 2 // skip (*
  let mut depth = 1
  while self.pos < self.len && depth > 0 {
    let c = self.chars[self.pos]
    if c == '(' && self.peek_at(1) == Some('*') {
      self.pos += 2
      depth += 1
    } else if c == '*' && self.peek_at(1) == Some(')') {
      self.pos += 2
      depth -= 1
    } else {
      self.pos += 1
    }
  }
  { token_type: Comment, from: start, to: self.pos }
}

///|
fn OcamlTokenizer::read_string(self : OcamlTokenizer) -> OcamlToken {
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
fn OcamlTokenizer::read_char(self : OcamlTokenizer) -> OcamlToken {
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
fn OcamlTokenizer::read_number(self : OcamlTokenizer) -> OcamlToken {
  let start = self.pos
  if self.chars[self.pos] == '0' && self.pos + 1 < self.len {
    let next = self.chars[self.pos + 1]
    if next == 'x' ||
      next == 'X' ||
      next == 'o' ||
      next == 'O' ||
      next == 'b' ||
      next == 'B' {
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
  if self.pos < self.len && self.chars[self.pos] == '.' {
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
fn OcamlTokenizer::read_identifier(self : OcamlTokenizer) -> OcamlToken {
  let start = self.pos
  let first = self.chars[self.pos]
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }
  let value = String::from_array(self.chars[start:self.pos])
  let token_type = if ocaml_keywords.contains(value) {
    Keyword
  } else if ocaml_module_keywords.contains(value) {
    ModuleKeyword
  } else if first >= 'A' && first <= 'Z' {
    if self.pos < self.len && self.chars[self.pos] == '.' {
      ModuleName
    } else {
      Constructor
    }
  } else {
    Identifier
  }
  { token_type, from: start, to: self.pos }
}

///|
fn OcamlTokenizer::read_operator(self : OcamlTokenizer) -> OcamlToken {
  let start = self.pos
  while self.pos < self.len && is_operator_char(self.chars[self.pos]) {
    self.pos += 1
  }
  let value = String::from_array(self.chars[start:self.pos])
  let token_type = match value {
    "->" | "=>" => Arrow
    "::" => ListCons
    "@" | "^" => Concat
    "=" | "<>" | "<" | ">" | "<=" | ">=" => Comparison
    "&&" | "||" => Logical
    "|" => Pipe
    _ => Operator
  }
  { token_type, from: start, to: self.pos }
}

///|
pub fn OcamlTokenizer::next_token(self : OcamlTokenizer) -> OcamlToken? {
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
  if c == '(' && self.peek_at(1) == Some('*') {
    return Some(self.read_comment())
  }

  // String
  if c == '"' {
    return Some(self.read_string())
  }

  // Char or type variable
  if c == '\'' {
    if self.pos + 1 < self.len && is_id_start(self.chars[self.pos + 1]) {
      self.pos += 1
      while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
        self.pos += 1
      }
      return Some({ token_type: TypeIdent, from: start, to: self.pos })
    } else {
      return Some(self.read_char())
    }
  }

  // Number
  if is_digit(c) {
    return Some(self.read_number())
  }

  // Label
  if c == '~' || c == '?' {
    if self.pos + 1 < self.len && is_id_start(self.chars[self.pos + 1]) {
      self.pos += 1
      while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
        self.pos += 1
      }
      return Some({ token_type: Label, from: start, to: self.pos })
    }
  }

  // Identifier
  if is_id_start(c) {
    return Some(self.read_identifier())
  }

  // Double semicolon
  if c == ';' && self.peek_at(1) == Some(';') {
    self.pos += 2
    return Some({ token_type: Semicolon2, from: start, to: self.pos })
  }

  // Operator
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
    '_' => Underscore
    _ => Unknown
  }
  self.pos += 1
  Some({ token_type, from: start, to: self.pos })
}

///|
pub fn OcamlTokenizer::tokenize_all(self : OcamlTokenizer) -> Array[OcamlToken] {
  let tokens : Array[OcamlToken] = []
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
