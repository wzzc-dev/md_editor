///|
/// Extension to language name mapping for DCE-friendly imports
/// Returns only language names as strings, allowing consumers to selectively import
/// only the language packages they need.

///|
/// Get language name for a file extension (with leading dot)
/// Returns None if the extension is not recognized
pub fn get_language_for_ext(ext : String) -> String? {
  match ext {
    // JavaScript/TypeScript
    ".js" | ".jsx" | ".mjs" | ".cjs" | ".ts" | ".tsx" | ".mts" | ".cts" =>
      Some("typescript")
    // Web
    ".html" | ".htm" => Some("html")
    ".css" => Some("css")
    // Data formats
    ".json" | ".jsonc" | ".json5" => Some("json")
    ".yaml" | ".yml" => Some("yaml")
    ".toml" => Some("toml")
    ".xml" | ".svg" | ".xhtml" | ".xsl" | ".xslt" => Some("xml")
    ".graphql" | ".gql" => Some("graphql")
    // Documentation
    ".md" | ".mdx" | ".markdown" => Some("mdx")
    // Systems programming
    ".c" | ".h" => Some("c")
    ".cpp" | ".cc" | ".cxx" | ".hpp" | ".hxx" | ".hh" => Some("cpp")
    ".rs" => Some("rust")
    ".go" => Some("go")
    ".zig" => Some("zig")
    // JVM languages
    ".java" => Some("java")
    ".kt" | ".kts" => Some("kotlin")
    ".scala" | ".sc" => Some("scala")
    // .NET
    ".cs" => Some("csharp")
    // Apple
    ".swift" => Some("swift")
    // Scripting
    ".py" | ".pyw" | ".pyi" => Some("python")
    ".rb" | ".rake" | ".gemspec" => Some("ruby")
    ".php" | ".phtml" => Some("php")
    ".lua" => Some("lua")
    ".sh" | ".bash" | ".zsh" | ".bashrc" | ".zshrc" => Some("bash")
    // ML family
    ".ml" | ".mli" => Some("ocaml")
    ".hs" | ".lhs" => Some("haskell")
    // Mobile
    ".dart" => Some("dart")
    // Database
    ".sql" => Some("sql")
    // MoonBit
    ".mbt" => Some("moonbit")
    // Build/Config
    "Dockerfile" | ".dockerfile" => Some("dockerfile")
    "Makefile" | ".makefile" | ".mk" => Some("makefile")
    _ => None
  }
}

///|
/// Get language name for a filename (handles special files without extensions)
pub fn get_language_for_filename(filename : String) -> String? {
  // Check for special filenames first
  match filename {
    "Dockerfile" => Some("dockerfile")
    "Makefile" | "GNUmakefile" | "makefile" => Some("makefile")
    ".bashrc" | ".bash_profile" | ".zshrc" | ".zshenv" | ".profile" =>
      Some("bash")
    ".gitignore" | ".dockerignore" | ".npmignore" => Some("bash") // gitignore uses bash-like syntax
    _ => {
      // Find extension
      let chars = filename.to_array()
      let mut last_dot = -1
      for i = chars.length() - 1; i >= 0; i = i - 1 {
        if chars[i] == '.' {
          last_dot = i
          break
        }
      }
      if last_dot > 0 {
        let ext = String::from_array(chars[last_dot:])
        get_language_for_ext(ext)
      } else {
        None
      }
    }
  }
}

///|
/// List of all supported language names
pub fn supported_languages() -> Array[String] {
  [
    "bash", "c", "cpp", "csharp", "css", "dart", "dockerfile", "go", "graphql", "haskell",
    "html", "java", "json", "kotlin", "lua", "makefile", "mdx", "moonbit", "ocaml",
    "php", "python", "ruby", "rust", "scala", "sql", "swift", "toml", "typescript",
    "xml", "yaml", "zig",
  ]
}

///|
/// Get all extensions for a language name
pub fn get_extensions_for_language(lang : String) -> Array[String] {
  match lang {
    "typescript" =>
      [".js", ".jsx", ".mjs", ".cjs", ".ts", ".tsx", ".mts", ".cts"]
    "html" => [".html", ".htm"]
    "css" => [".css"]
    "json" => [".json", ".jsonc", ".json5"]
    "yaml" => [".yaml", ".yml"]
    "toml" => [".toml"]
    "xml" => [".xml", ".svg", ".xhtml", ".xsl", ".xslt"]
    "graphql" => [".graphql", ".gql"]
    "mdx" => [".md", ".mdx", ".markdown"]
    "c" => [".c", ".h"]
    "cpp" => [".cpp", ".cc", ".cxx", ".hpp", ".hxx", ".hh"]
    "rust" => [".rs"]
    "go" => [".go"]
    "zig" => [".zig"]
    "java" => [".java"]
    "kotlin" => [".kt", ".kts"]
    "scala" => [".scala", ".sc"]
    "csharp" => [".cs"]
    "swift" => [".swift"]
    "python" => [".py", ".pyw", ".pyi"]
    "ruby" => [".rb", ".rake", ".gemspec"]
    "php" => [".php", ".phtml"]
    "lua" => [".lua"]
    "bash" => [".sh", ".bash", ".zsh"]
    "ocaml" => [".ml", ".mli"]
    "haskell" => [".hs", ".lhs"]
    "dart" => [".dart"]
    "sql" => [".sql"]
    "moonbit" => [".mbt"]
    "dockerfile" => ["Dockerfile", ".dockerfile"]
    "makefile" => ["Makefile", ".mk"]
    _ => []
  }
}
