import glint.{type Flag}

pub fn caps_flag() -> Flag(Bool) {
  // create a new boolean flag with key "caps"
  // this flag will be called as --caps=true (or simply --caps as glint handles boolean flags in a bit of a special manner) from the command line
  glint.bool_flag("caps")
  // set the flag default value to False
  |> glint.flag_default(False)
  //  set the flag help text
  |> glint.flag_help("Capitalize the hello message")
}

pub fn restriction() -> Flag(String) {
  glint.string_flag("rsite")
  |> glint.flag_default("")
  |> glint.flag_help("Specify a restriction recognition site.")
}

pub fn silent_splash() -> Flag(Bool) {
  glint.bool_flag("n")
  |> glint.flag_default(False)
  |> glint.flag_help("Suppress the splash message.")
}

pub fn output() -> Flag(String) {
  glint.string_flag("out")
  |> glint.flag_default("")
  |> glint.flag_help("Specify output path")
}
