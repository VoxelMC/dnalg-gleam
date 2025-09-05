import dnalg/actions/translation
import gleam/io
import gleam/iterator
import gleam/list
import gleam/result
import gleam/string

import dnalg/core/codon
import dnalg/core/residue.{type Residue, Residue, Stop}
import dnalg/core/sequence.{
  type DnaParseError, type DnaSequence, type DnaTranscriptionResult,
  InvalidBaseError, InvalidLengthError, NoStartCodon, Transcription,
  TranscriptionError,
}
import dnalg/core/tools

// FIX: THIS NEEDS TO BE MOVED!!!!
// Also consider using phantom types for translations instead of using
// translation error type. Or something??
pub type TranslationError {
  NoStart
}

// NOTE: Future signature: 
// pub fn transcribe(sequence: DnaSequence) -> DnaTranscription
// Review the name here as well. This is not really a transcription nor
// translation. Maybe just rename to reading_frame() or orf() ????
/// Retrieve the first reading frame from a DNA Sequence. Requires a start and
/// stop codon to succeed.
pub fn transcribe(sequence: String) -> DnaTranscriptionResult {
  let split = sequence |> tools.normalize_sequence() |> string.split_once("ATG")
  case split {
    Error(_) -> TranscriptionError(NoStartCodon)
    Ok(s) -> {
      let after = s.1 |> string.split("")
      let invalid_bases =
        after
        |> list.unique
        |> list.fold("", fn(acc, curr) {
          case curr |> sequence.validate_base {
            Ok(_) -> acc
            Error(base) -> acc <> base
          }
        })

      case invalid_bases {
        "" -> {
          let res = after |> into_codons(["ATG"])
          case res {
            Ok(codons) ->
              Transcription(transcript: codons, trimmed: s.0 |> string.length())
            Error(err) -> TranscriptionError(err)
          }
        }
        bases -> TranscriptionError(InvalidBaseError(bases))
      }
    }
  }
}

pub fn translate(seq: DnaSequence) {
  let raw = sequence.unwrap(seq)
  let reader =
    string.to_graphemes(raw)
    |> list.window(3)
    |> list.map(fn(el) { el |> string.join("") })
    |> iterator.from_list()
  let res =
    reader
    |> iterator.index
    |> iterator.find(fn(el) {
      let #(str, _i) = el
      str == "ATG"
    })

  case res {
    Ok(#(_, i)) -> {
      // let i = i + 1
      let codons =
        reader
        |> iterator.drop(i)
        |> iterator.to_list
        |> list.index_fold([], fn(acc, el, i) {
          case i % 3 {
            0 -> acc |> list.append([el])
            _ -> acc
          }
        })
        |> io.debug
      Ok(codons |> list.map(residue.from_raw_codon))
    }
    Error(_) -> Error(NoStart)
  }
  // io.debug(#(reader, res))
}

pub fn main() {
  translate(sequence.new(
    "ATG TGA ACA AGG GAA GTT TGA GCC AAT GCC AGT ACC GCC AGT ATT GCC TAG",
  ))
  |> result.unwrap([])
  |> translation.to_string()
  |> io.debug
  //                      123456789012
  //                                 ^ 12
}

fn into_codons(
  sequence: List(String),
  acc: List(String),
) -> Result(List(String), DnaParseError) {
  case sequence {
    [] -> Ok(acc)
    [first, second, third, ..rest] -> {
      let cd = first <> second <> third
      case codon.Codon(cd) |> residue.from_codon() {
        Residue(Stop, _, _, _) -> into_codons([], acc)
        _ -> into_codons(rest, acc |> list.append([cd]))
      }
    }
    [_, _] | [_] -> Error(InvalidLengthError(sequence |> list.length()))
  }
}

/// Transform a list of residues into a DNA Sequence.
pub fn reverse_translate(residues: List(Residue)) -> String {
  residues
  |> list.map(fn(r) { r.codon })
  |> string.join("")
  |> tools.normalize_sequence()
}
