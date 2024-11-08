import core/tools
import gleam/io
import gleam/list
import gleam/string

pub fn validate_base(base: String) {
  case base {
    "A" | "T" | "C" | "G" -> Ok(base)
    _ -> Error(base)
  }
}

/// Returns a string which accumulates invalid bases present in the sequence.
/// If the sequence is valid, it will return an empty string.
/// You can use this to validate a DNA sequence by matching on the empty
/// string.
pub fn validate_sequence(sequence: String) {
  sequence
  |> tools.normalize_sequence
  |> string.split("")
  |> list.fold("", fn(acc, curr) {
    case curr |> validate_base {
      Ok(_) -> acc
      Error(base) -> acc <> base
    }
  })
}

pub fn main() {
  let valid = "ATCG"
  let invalid = "ATCGX"

  let valid_result = valid |> validate_sequence
  let invalid_result = invalid |> validate_sequence

  valid_result |> io.println
  invalid_result |> io.println
}
