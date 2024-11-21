import gleam/list
import gleam/string

import dnalg/core/codon
import dnalg/core/residue.{type Residue, Residue, Stop}
import dnalg/core/sequence.{
  type DnaParseError, type DnaTranscription, InvalidBaseError,
  InvalidLengthError, NoStartCodon, Transcription, TranscriptionError,
}
import dnalg/core/tools

// NOTE: Future signature: 
// pub fn transcribe(sequence: DnaSequence) -> DnaTranscription
pub fn transcribe(sequence: String) -> DnaTranscription {
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

pub fn reverse_translate(residues: List(Residue)) -> String {
  residues
  |> list.map(fn(r) { r.codon })
  |> string.join("")
  |> tools.normalize_sequence()
}
