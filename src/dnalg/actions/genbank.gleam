import gleam/bit_array
import gleam/list
import gleam/result
import gleam/string

import dnalg/core/file.{type File}
import dnalg/core/sequence
import dnalg/core/tools

pub type GenbankParseError {
  InvalidFormat(msg: String)
}

/// This function takes a string which represents the contents of a `.gb` file.
/// Always returns a `GenBank` type
/// TODO:
pub fn parse(_input: String) -> File {
  file.gb_empty
}

// Extracts data from the 'SOURCE' region of a GenBank file.
pub fn parse_source(input: String) {
  case input |> string.split_once("SOURCE") {
    Ok(#(_, source)) -> {
      case source |> string.split("\n") |> list.first() {
        Ok(first) -> Ok(first |> string.trim())
        Error(_) -> Error(InvalidFormat)
      }
    }
    Error(_) -> Error(InvalidFormat)
  }
}

// Extracts data from the 'ORIGIN' region of a GenBank file. This represents
// the DNA sequence for this accession
pub fn parse_sequence(input: String) {
  let trimmed = input |> string.trim()
  case trimmed |> string.split_once("ORIGIN") {
    Ok(#(_, origin)) -> {
      let new_o =
        origin
        |> string.split("\n")
        |> list.map(fn(str) { str |> bit_array.from_string() })
        |> list.rest()
      let bits = {
        use val <- result.try(new_o)
        let new =
          val
          |> list.map(fn(bit_arr) {
            case bit_arr {
              <<_:10-bytes, rest:bytes>> ->
                rest
                |> bit_array.to_string()
                |> result.unwrap("")
                |> tools.normalize_sequence()
              _ -> ""
            }
          })

        Ok(new |> string.join("") |> sequence.new)
      }
      Ok(bits |> result.unwrap(sequence.empty))
    }
    _, _ ->
      Error(InvalidFormat("GenBank input does not contain an 'ORIGIN' section."))
  }
}
