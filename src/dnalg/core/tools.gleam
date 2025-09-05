import gleam/string.{replace, uppercase}
import gleam_community/ansi

/// Normalizes a given string for further processing. *Does not validate.*
pub fn normalize_sequence(sequence: String) -> String {
  sequence
  |> replace(each: " ", with: "")
  |> uppercase()
  |> replace(each: "\n", with: "")
}

/// Prepare a string to be reported as an error for CLI output.
@internal
pub fn as_error(msg: String) -> String {
  "\n" <> ansi.red("! ") <> msg <> "\n"
}
