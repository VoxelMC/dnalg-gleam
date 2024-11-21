import dnalg/core/tools
import gleam/io
import gleam/list
import gleam/string

// TODO: Move this to core/sequence and add DnaSequence type
pub type DnaTranscription {
  Transcription(translation: List(String), trimmed: Int)
  TranscriptionError(DnaParseError)
}

pub type DnaParseError {
  UnknownParseError
  InvalidBaseError(base: String)
  InvalidLengthError(length: Int)
  NoStartCodon
}

pub opaque type DnaSequence {
  DnaSequence(sequence: String)
}

pub fn new(sequence: String) {
  DnaSequence(sequence |> tools.normalize_sequence())
}

pub const empty = DnaSequence("")

pub fn raw(dna_seq: DnaSequence) {
  dna_seq.sequence
}

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
