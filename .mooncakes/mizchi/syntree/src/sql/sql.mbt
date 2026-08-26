///|
/// SQL Tokenizer
pub(all) enum SqlTokenType {
  Keyword
  DMLKeyword
  DDLKeyword
  Function
  DataType
  String
  Number
  Null
  Identifier
  QuotedIdent
  Parameter
  Operator
  Comparison
  Logical
  Assignment
  ParenOpen
  ParenClose
  Comma
  Semicolon
  Dot
  Star
  LineComment
  BlockComment
  Whitespace
  Newline
  Unknown
} derive(Eq, Show)

///|
pub(all) struct SqlToken {
  token_type : SqlTokenType
  from : Int
  to : Int
} derive(Eq, Show)

///|
pub(all) struct SqlTokenizer {
  input : String
  priv chars : Array[Char]
  priv len : Int
  priv mut pos : Int
}

///|
let sql_keywords : Array[String] = [
  "SELECT", "FROM", "WHERE", "AND", "OR", "NOT", "IN", "LIKE", "BETWEEN", "IS", "NULL",
  "TRUE", "FALSE", "AS", "ON", "JOIN", "INNER", "LEFT", "RIGHT", "OUTER", "FULL",
  "CROSS", "ORDER", "BY", "GROUP", "HAVING", "LIMIT", "OFFSET", "UNION", "ALL", "DISTINCT",
  "CASE", "WHEN", "THEN", "ELSE", "END", "EXISTS", "WITH", "VALUES", "SET", "INTO",
  "RETURNING", "ASC", "DESC",
]

///|
let sql_dml_keywords : Array[String] = [
  "INSERT", "UPDATE", "DELETE", "MERGE", "TRUNCATE",
]

///|
let sql_ddl_keywords : Array[String] = [
  "CREATE", "DROP", "ALTER", "TABLE", "INDEX", "VIEW", "DATABASE", "SCHEMA", "PRIMARY",
  "KEY", "FOREIGN", "REFERENCES", "UNIQUE", "CHECK", "DEFAULT", "CASCADE", "IF",
  "EXISTS", "TEMPORARY",
]

///|
let sql_functions : Array[String] = [
  "COUNT", "SUM", "AVG", "MIN", "MAX", "COALESCE", "NULLIF", "CAST", "SUBSTRING",
  "TRIM", "UPPER", "LOWER", "LENGTH", "CONCAT", "REPLACE", "ROUND", "FLOOR", "CEIL",
  "ABS", "NOW", "DATE", "TIME",
]

///|
let sql_data_types : Array[String] = [
  "INT", "INTEGER", "BIGINT", "SMALLINT", "DECIMAL", "NUMERIC", "FLOAT", "REAL",
  "DOUBLE", "VARCHAR", "CHAR", "TEXT", "BOOLEAN", "BOOL", "DATE", "TIME", "TIMESTAMP",
  "DATETIME", "UUID", "JSON", "SERIAL",
]

///|
pub fn SqlTokenizer::new(input : String) -> SqlTokenizer {
  let chars = input.to_array()
  { input, chars, len: chars.length(), pos: 0 }
}

///|
fn SqlTokenizer::peek_at(self : SqlTokenizer, offset : Int) -> Char? {
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
fn to_upper(s : String) -> String {
  let buf = StringBuilder::new()
  for i = 0; i < s.length(); i = i + 1 {
    let c = s.iter().nth(i).unwrap()
    let upper = if c >= 'a' && c <= 'z' {
      (c.to_int() - 32).unsafe_to_char()
    } else {
      c
    }
    buf.write_char(upper)
  }
  buf.to_string()
}

///|
fn SqlTokenizer::read_string(self : SqlTokenizer) -> SqlToken {
  let start = self.pos
  self.pos += 1
  while self.pos < self.len {
    let c = self.chars[self.pos]
    if c == '\'' {
      self.pos += 1
      if self.pos < self.len && self.chars[self.pos] == '\'' {
        self.pos += 1
      } else {
        break
      }
    } else {
      self.pos += 1
    }
  }
  { token_type: String, from: start, to: self.pos }
}

///|
fn SqlTokenizer::read_quoted_identifier(self : SqlTokenizer) -> SqlToken {
  let start = self.pos
  let quote = self.chars[self.pos]
  let end_quote = if quote == '[' { ']' } else { quote }
  self.pos += 1
  while self.pos < self.len && self.chars[self.pos] != end_quote {
    self.pos += 1
  }
  if self.pos < self.len {
    self.pos += 1
  }
  { token_type: QuotedIdent, from: start, to: self.pos }
}

///|
fn SqlTokenizer::read_number(self : SqlTokenizer) -> SqlToken {
  let start = self.pos
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
fn SqlTokenizer::read_identifier(self : SqlTokenizer) -> SqlToken {
  let start = self.pos
  while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
    self.pos += 1
  }
  let value = String::from_array(self.chars[start:self.pos])
  let upper = to_upper(value)
  let token_type = if upper == "NULL" {
    Null
  } else if upper == "AND" || upper == "OR" || upper == "NOT" {
    Logical
  } else if sql_keywords.contains(upper) {
    Keyword
  } else if sql_dml_keywords.contains(upper) {
    DMLKeyword
  } else if sql_ddl_keywords.contains(upper) {
    DDLKeyword
  } else if sql_functions.contains(upper) {
    Function
  } else if sql_data_types.contains(upper) {
    DataType
  } else {
    Identifier
  }
  { token_type, from: start, to: self.pos }
}

///|
pub fn SqlTokenizer::next_token(self : SqlTokenizer) -> SqlToken? {
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
    while self.pos < self.len && self.chars[self.pos] != '\n' {
      self.pos += 1
    }
    return Some({ token_type: LineComment, from: start, to: self.pos })
  }

  // Block comment
  if c == '/' && self.peek_at(1) == Some('*') {
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

  // String
  if c == '\'' {
    return Some(self.read_string())
  }

  // Quoted identifier
  if c == '"' || c == '`' || c == '[' {
    return Some(self.read_quoted_identifier())
  }

  // Parameter
  if c == ':' || c == '@' || c == '$' {
    self.pos += 1
    while self.pos < self.len && is_id_continue(self.chars[self.pos]) {
      self.pos += 1
    }
    return Some({ token_type: Parameter, from: start, to: self.pos })
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
    "<>" | "!=" | "<=" | ">=" => {
      self.pos += 2
      return Some({ token_type: Comparison, from: start, to: self.pos })
    }
    ":=" => {
      self.pos += 2
      return Some({ token_type: Assignment, from: start, to: self.pos })
    }
    "||" => {
      self.pos += 2
      return Some({ token_type: Operator, from: start, to: self.pos })
    }
    _ => ()
  }

  // Single-char tokens
  let token_type = match c {
    '(' => ParenOpen
    ')' => ParenClose
    ',' => Comma
    ';' => Semicolon
    '.' => Dot
    '*' => Star
    '+' | '-' | '/' | '%' => Operator
    '=' | '<' | '>' => Comparison
    _ => Unknown
  }
  self.pos += 1
  Some({ token_type, from: start, to: self.pos })
}

///|
pub fn SqlTokenizer::tokenize_all(self : SqlTokenizer) -> Array[SqlToken] {
  let tokens : Array[SqlToken] = []
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
