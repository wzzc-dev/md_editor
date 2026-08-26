///|
test "get_language_for_ext/typescript" {
  assert_eq(@syntree.get_language_for_ext(".js"), Some("typescript"))
  assert_eq(@syntree.get_language_for_ext(".ts"), Some("typescript"))
  assert_eq(@syntree.get_language_for_ext(".tsx"), Some("typescript"))
  assert_eq(@syntree.get_language_for_ext(".jsx"), Some("typescript"))
  assert_eq(@syntree.get_language_for_ext(".mjs"), Some("typescript"))
  assert_eq(@syntree.get_language_for_ext(".cjs"), Some("typescript"))
}

///|
test "get_language_for_ext/systems" {
  assert_eq(@syntree.get_language_for_ext(".c"), Some("c"))
  assert_eq(@syntree.get_language_for_ext(".h"), Some("c"))
  assert_eq(@syntree.get_language_for_ext(".cpp"), Some("cpp"))
  assert_eq(@syntree.get_language_for_ext(".rs"), Some("rust"))
  assert_eq(@syntree.get_language_for_ext(".go"), Some("go"))
  assert_eq(@syntree.get_language_for_ext(".zig"), Some("zig"))
}

///|
test "get_language_for_ext/scripting" {
  assert_eq(@syntree.get_language_for_ext(".py"), Some("python"))
  assert_eq(@syntree.get_language_for_ext(".rb"), Some("ruby"))
  assert_eq(@syntree.get_language_for_ext(".php"), Some("php"))
  assert_eq(@syntree.get_language_for_ext(".lua"), Some("lua"))
  assert_eq(@syntree.get_language_for_ext(".sh"), Some("bash"))
}

///|
test "get_language_for_ext/jvm" {
  assert_eq(@syntree.get_language_for_ext(".java"), Some("java"))
  assert_eq(@syntree.get_language_for_ext(".kt"), Some("kotlin"))
  assert_eq(@syntree.get_language_for_ext(".scala"), Some("scala"))
}

///|
test "get_language_for_ext/data" {
  assert_eq(@syntree.get_language_for_ext(".json"), Some("json"))
  assert_eq(@syntree.get_language_for_ext(".yaml"), Some("yaml"))
  assert_eq(@syntree.get_language_for_ext(".toml"), Some("toml"))
  assert_eq(@syntree.get_language_for_ext(".xml"), Some("xml"))
  assert_eq(@syntree.get_language_for_ext(".graphql"), Some("graphql"))
}

///|
test "get_language_for_ext/unknown" {
  assert_eq(@syntree.get_language_for_ext(".unknown"), None)
  assert_eq(@syntree.get_language_for_ext(".abc"), None)
}

///|
test "get_language_for_filename/special" {
  assert_eq(
    @syntree.get_language_for_filename("Dockerfile"),
    Some("dockerfile"),
  )
  assert_eq(@syntree.get_language_for_filename("Makefile"), Some("makefile"))
  assert_eq(@syntree.get_language_for_filename("GNUmakefile"), Some("makefile"))
  assert_eq(@syntree.get_language_for_filename(".bashrc"), Some("bash"))
  assert_eq(@syntree.get_language_for_filename(".zshrc"), Some("bash"))
}

///|
test "get_language_for_filename/with_ext" {
  assert_eq(@syntree.get_language_for_filename("app.tsx"), Some("typescript"))
  assert_eq(@syntree.get_language_for_filename("main.rs"), Some("rust"))
  assert_eq(@syntree.get_language_for_filename("config.json"), Some("json"))
  assert_eq(
    @syntree.get_language_for_filename("build.gradle.kts"),
    Some("kotlin"),
  )
}

///|
test "supported_languages" {
  let langs = @syntree.supported_languages()
  assert_true(langs.contains("typescript"))
  assert_true(langs.contains("rust"))
  assert_true(langs.contains("python"))
  assert_true(langs.contains("moonbit"))
  assert_eq(langs.length(), 31)
}

///|
test "get_extensions_for_language" {
  let ts_exts = @syntree.get_extensions_for_language("typescript")
  assert_true(ts_exts.contains(".ts"))
  assert_true(ts_exts.contains(".tsx"))
  assert_true(ts_exts.contains(".js"))
  let rust_exts = @syntree.get_extensions_for_language("rust")
  assert_eq(rust_exts, [".rs"])
  let unknown_exts = @syntree.get_extensions_for_language("unknown")
  assert_eq(unknown_exts, [])
}
