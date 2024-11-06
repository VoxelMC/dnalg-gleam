import gleam/string.{replace, uppercase}

pub fn normalize_sequence(sequence: String) -> String {
  sequence |> replace(each: " ", with: "") |> uppercase()
}
