///|
/// Makefile Tokenizer
pub(all) enum MakefileTokenType {
  Target
  Prerequisite
  Variable
  VariableRef
  Function
  String
  Operator
  Assignment
  Colon
  Semicolon
  Pipe
  Recipe
  Comment
  Directive
  Whitespace
  Newline
  Tab
  Unknown
} derive(Eq, Show)

///|
pub(all) struct MakefileToken {
  token_type : MakefileTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct MakefileTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
  priv mut at_line_start : Bool
  priv mut in_recipe : Bool
}

///|
let makefile_directives : Array[String] = [
  "include", "sinclude", "-include", "define", "endef", "undefine", "ifdef", "ifndef",
  "ifeq", "ifneq", "else", "endif", "override", "export", "unexport", "private",
  "vpath",
]

///|
pub fn MakefileTokenizer::new(input : String) -> MakefileTokenizer {
  let chars = input.to_array()
  {
    input,
    chars,
    len: chars.length(),
    pos: 0,
    at_line_start: true,
    in_recipe: false,
  }
}

///|
fn MakefileTokenizer::peek_at(self : MakefileTokenizer, offset : Int) -> Char? {
  let idx = self.pos + offset
  if idx >= 0 && idx < self.len {
    Some(self.chars[idx])
  } else {
    None
  }
}

///|
fn is_name_char(c : Char) -> Bool {
  (c >= 'a' && c <= 'z') ||
  (c >= 'A' && c <= 'Z') ||
  (c >= '0' && c <= '9') ||
  c == '_' ||
  c == '-' ||
  c == '.'
}

///|
fn MakefileTokenizer::read_variable_ref(
  self : MakefileTokenizer,
) -> MakefileToken {
  let start = self.pos
  self.pos += 1 // skip $
  if self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '(' || c == '{' {
      let close = if c == '(' { ')' } else { '}' }
      self.pos += 1
      let mut depth = 1
      while self.pos < self.len && depth > 0 {
        let ch = self.chars[self.pos]
        if ch == c {
          depth += 1
        } else if ch == close {
          depth -= 1
        }
        self.pos += 1
      }
    } else if c == '$' {
      self.pos += 1 // $$
    } else if c == '@' ||
      c == '<' ||
      c == '^' ||
      c == '?' ||
      c == '*' ||
      c == '%' {
      self.pos += 1 // automatic variable
    } else if is_name_char(c) {
      self.pos += 1 // single char variable
    }
  }
  { token_type: VariableRef, from: start, to: self.pos }
}

///|
fn MakefileTokenizer::read_string(
  self : MakefileTokenizer,
  quote : Char,
) -> MakefileToken {
  let start = self.pos
  self.pos += 1
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '\\' && self.pos + 1 < self.len {
      self.pos += 2
    } else if c == quote {
      self.pos += 1
      break
    } else {
      self.pos += 1
    }
  }
  { token_type: String, from: start, to: self.pos }
}

///|
fn MakefileTokenizer::read_name(self : MakefileTokenizer) -> MakefileToken {
  let start = self.pos
  while self.pos < self.len && is_name_char(self.chars[self.pos]) {
    self.pos += 1
  }
  let value = String::from_array(self.chars[start:self.pos])
  let token_type = if makefile_directives.contains(value) {
    Directive
  } else {
    Variable
  }
  { token_type, from: start, to: self.pos }
}

///|
fn MakefileTokenizer::read_recipe_line(
  self : MakefileTokenizer,
) -> MakefileToken {
  let start = self.pos
  while self.pos < self.len && self.chars[self.pos] != '\n' {
    if self.chars[self.pos] == '$' {
      break
    }
    self.pos += 1
  }
  { token_type: Recipe, from: start, to: self.pos }
}

///|
pub fn MakefileTokenizer::next_token(
  self : MakefileTokenizer,
) -> MakefileToken? {
  if self.pos >= self.len {
    return None
  }
  let start = self.pos
  let c = self.chars[self.pos]

  // Tab at line start indicates recipe
  if self.at_line_start && c == '\t' {
    self.pos += 1
    self.at_line_start = false
    self.in_recipe = true
    return Some({ token_type: Tab, from: start, to: self.pos })
  }

  // Recipe line content
  if self.in_recipe && c != '\n' && c != '$' {
    return Some(self.read_recipe_line())
  }

  // Whitespace (not tab at line start)
  if c == ' ' || (c == '\t' && not(self.at_line_start)) {
    while self.pos < self.len {
      let ch = self.chars[self.pos]
      if ch == ' ' || ch == '\t' {
        self.pos += 1
      } else {
        break
      }
    }
    self.at_line_start = false
    return Some({ token_type: Whitespace, from: start, to: self.pos })
  }

  // Newline
  if c == '\n' {
    self.pos += 1
    self.at_line_start = true
    self.in_recipe = false
    return Some({ token_type: Newline, from: start, to: self.pos })
  }

  // Comment
  if c == '#' {
    while self.pos < self.len && self.chars[self.pos] != '\n' {
      self.pos += 1
    }
    return Some({ token_type: Comment, from: start, to: self.pos })
  }

  // Variable reference
  if c == '$' {
    self.at_line_start = false
    return Some(self.read_variable_ref())
  }

  // String
  if c == '"' || c == '\'' {
    self.at_line_start = false
    return Some(self.read_string(c))
  }

  // Assignment operators
  if c == ':' && self.peek_at(1) == Some('=') {
    self.pos += 2
    self.at_line_start = false
    return Some({ token_type: Assignment, from: start, to: self.pos })
  }
  if c == '+' && self.peek_at(1) == Some('=') {
    self.pos += 2
    self.at_line_start = false
    return Some({ token_type: Assignment, from: start, to: self.pos })
  }
  if c == '?' && self.peek_at(1) == Some('=') {
    self.pos += 2
    self.at_line_start = false
    return Some({ token_type: Assignment, from: start, to: self.pos })
  }
  if c == '!' && self.peek_at(1) == Some('=') {
    self.pos += 2
    self.at_line_start = false
    return Some({ token_type: Assignment, from: start, to: self.pos })
  }

  // Single-char tokens
  if c == ':' {
    self.pos += 1
    self.at_line_start = false
    return Some({ token_type: Colon, from: start, to: self.pos })
  }
  if c == ';' {
    self.pos += 1
    self.at_line_start = false
    self.in_recipe = true
    return Some({ token_type: Semicolon, from: start, to: self.pos })
  }
  if c == '|' {
    self.pos += 1
    self.at_line_start = false
    return Some({ token_type: Pipe, from: start, to: self.pos })
  }
  if c == '=' {
    self.pos += 1
    self.at_line_start = false
    return Some({ token_type: Assignment, from: start, to: self.pos })
  }
  if c == '\\' && self.peek_at(1) == Some('\n') {
    self.pos += 2
    return Some({ token_type: Whitespace, from: start, to: self.pos })
  }

  // Name (variable, target, prerequisite)
  if is_name_char(c) {
    self.at_line_start = false
    return Some(self.read_name())
  }

  // Other operator chars
  if c == '%' || c == '*' || c == '@' || c == '<' || c == '>' || c == '/' {
    self.pos += 1
    self.at_line_start = false
    return Some({ token_type: Operator, from: start, to: self.pos })
  }
  self.pos += 1
  self.at_line_start = false
  Some({ token_type: Unknown, from: start, to: self.pos })
}

///|
pub fn MakefileTokenizer::tokenize_all(
  self : MakefileTokenizer,
) -> Array[MakefileToken] {
  let tokens : Array[MakefileToken] = []
  while true {
    match self.next_token() {
      Some(token) =>
        match token.token_type {
          Whitespace | Newline | Tab => ()
          _ => tokens.push(token)
        }
      None => break
    }
  }
  tokens
}
