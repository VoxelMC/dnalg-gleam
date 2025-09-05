import glint.{type Flag}

@internal
pub fn restriction() -> Flag(String) {
  glint.string_flag("rsite")
  |> glint.flag_default("")
  |> glint.flag_help("Specify a restriction recognition site.")
}

@internal
pub fn silent_splash() -> Flag(Bool) {
  glint.bool_flag("n")
  |> glint.flag_default(True)
  |> glint.flag_help("Suppress the splash message.")
}

@internal
pub fn output() -> Flag(String) {
  glint.string_flag("out")
  |> glint.flag_default("")
  |> glint.flag_help("Specify output path")
}
