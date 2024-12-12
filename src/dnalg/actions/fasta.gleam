import dnalg/core/file.{type File, fasta}
import dnalg/core/sequence
import gleam/list
import gleam/result
import gleam/string

pub type FastaParseError {
  InvalidFormat(msg: String)
}

/// Parses the first entry of a FASTA formatted string/file.
pub fn parse_head(input: String) -> Result(List(File), FastaParseError) {
  case input |> string.split_once("\n") {
    Ok(#(first, s)) -> {
      let assert [second, ..] = s |> string.split(">")
      case first, second |> sequence.new {
        ">" <> title, sequence -> Ok([fasta(title:, sequence:)])
        _, _ ->
          Error(InvalidFormat("Input does not begin with a '>' character."))
      }
    }
    Error(_) -> Error(InvalidFormat("Input does not contain enough newlines."))
  }
}

/// Parses all entries of a FASTA formatted string/file.
pub fn parse(input: String) -> Result(List(File), FastaParseError) {
  case input |> string.split_once(">") {
    Ok(#(_, in)) -> tail_parse(in, [])
    _ -> Error(InvalidFormat("Input does not begin with a '>' character."))
  }
}

fn tail_parse(input: String, acc: List(Result(File, FastaParseError))) {
  case input |> string.split_once("\n") {
    Ok(#(title, s)) -> {
      case s |> string.split_once(">") {
        Ok(#(seq, rest)) -> {
          let sequence = seq |> sequence.new()
          tail_parse(
            rest,
            acc
              |> list.append([Ok(fasta(title:, sequence:))]),
          )
        }
        _ -> {
          let sequence = s |> sequence.new
          acc
          |> list.append([Ok(fasta(title:, sequence:))])
          |> result.all
        }
      }
    }
    Error(_) -> Error(InvalidFormat("Input does not contain enough newlines."))
  }
}
