import gleam/string.{replace, uppercase}
import gleam_community/ansi

pub fn normalize_sequence(sequence: String) -> String {
  sequence |> replace(each: " ", with: "") |> uppercase()
}

pub fn as_error(msg: String) -> String {
  "\n" <> ansi.red("! ") <> msg <> "\n"
}
