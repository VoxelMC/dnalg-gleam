import dnalg/core/sequence.{type DnaSequence}
import gleam/bit_array
import gleam/list
import gleam/string

pub fn as_fasta(seq: DnaSequence) -> String {
  let #(seq, name) = sequence.unwrap_named(seq)
  let title = ">" <> name
  let out = title <> "\n" <> format_as_fasta(seq)
  out
}

fn format_as_fasta(to_format: String) {
  do_format_fasta(to_format, [])
  |> string.join("\n")
}

// Uses a line width of 80; standard for FASTA. 
// Compiling to JS (which we do) does not allow for dynamic sizing of the byte
// array, so we cannot do it (YET).
fn do_format_fasta(rest: String, acc: List(String)) {
  case rest |> bit_array.from_string() {
    <<first:bytes-size(80), rest:bytes>> -> {
      let assert Ok(head) = first |> bit_array.to_string()
      let acc = acc |> list.append([head])
      let assert Ok(rest) = rest |> bit_array.to_string()
      do_format_fasta(rest, acc)
    }
    <<>> -> acc
    <<rest:bytes>> -> {
      let assert Ok(tail) = rest |> bit_array.to_string()
      acc |> list.append([tail])
    }
    _ -> acc
  }
}
