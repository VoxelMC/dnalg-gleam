import dnalg/core/tools
import gleam/io
import gleam/list
import gleam/string

// TODO: Move this to core/sequence and add DnaSequence type
pub type DnaTranscription {
  Transcription(transcript: List(String), trimmed: Int)
  TranscriptionError(DnaParseError)
}

/// Represents one of many possible errors encountered when parsing data into a
/// `DnaSequence`
pub type DnaParseError {
  /// Something very strange...
  UnknownParseError
  /// A non-canonical letter has been included in the sequence.
  InvalidBaseError(base: String)
  /// The sequence is not a multiple of three
  InvalidLengthError(length: Int)
  /// A start codon is not present in the entire sequence, so a reading frame
  /// cannot be established.
  NoStartCodon
}

/// Represents a sequence of DNA which has been validated.
pub opaque type DnaSequence {
  DnaSequence(sequence: String)
}

/// Construct a new `DnaSequence`
pub fn new(sequence: String) {
  DnaSequence(sequence |> tools.normalize_sequence())
}

/// Constructor for an empty `DnaSequence`. Can be used as a placeholder, but 
/// shouldn't be used often.
pub const empty = DnaSequence("")

/// Gets the raw sequence from a constructed `DnaSequence`
pub fn raw(dna_seq: DnaSequence) {
  dna_seq.sequence
}

/// Gets the raw DNA transcription from a constructed `DnaTranscription`.
pub fn raw_transcript(transcript: DnaTranscription) {
  case transcript {
    Transcription(t, _) -> t |> string.join("")
    TranscriptionError(_) -> ""
  }
}

/// Validate a single base. For a predicate, use `validate_base_p(String)`
pub fn validate_base(base: String) {
  case base {
    "A" | "T" | "C" | "G" -> Ok(base)
    _ -> Error(base)
  }
}

/// Validate a single base. Serves as a predicate for a fold `fn` such as
/// `list.any()`. If you need the base returned, use `validate_base(String)`
pub fn validate_base_p(base: String) {
  case base {
    "A" | "T" | "C" | "G" -> True
    _ -> False
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
