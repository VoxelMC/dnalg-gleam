import actions/codon
import gleam/list
import gleam/string
import tools

pub fn validate_base(base: String) {
  case base {
    "A" | "T" | "C" | "G" -> Ok(base)
    _ -> Error(base)
  }
}

pub type DnaTranslation {
  Translation(translation: List(String), trimmed: Int)
  TranslationError(DnaParseError)
}

pub fn translate(sequence: String) -> DnaTranslation {
  let split = sequence |> tools.normalize_sequence() |> string.split_once("ATG")
  case split {
    Error(_) -> TranslationError(NoStartCodon)
    Ok(s) -> {
      let after = s.1 |> string.split("")
      let invalid_bases =
        after
        |> list.unique
        |> list.fold("", fn(acc, curr) {
          case curr |> validate_base {
            Ok(_) -> acc
            Error(base) -> acc <> base
          }
        })

      case invalid_bases {
        "" -> {
          let res = after |> into_codons(["ATG"])
          case res {
            Ok(codons) ->
              Translation(translation: codons, trimmed: s.0 |> string.length())
            Error(err) -> TranslationError(err)
          }
        }
        bases -> TranslationError(InvalidBaseError(bases))
      }
    }
  }
}

pub type DnaParseError {
  UnknownParseError
  InvalidBaseError(base: String)
  InvalidLengthError(length: Int)
  NoStartCodon
}

fn into_codons(
  sequence: List(String),
  acc: List(String),
) -> Result(List(String), DnaParseError) {
  case sequence {
    [] -> Ok(acc)
    [first, second, third, ..rest] -> {
      let cd = first <> second <> third
      case cd |> codon.get_amino_acid_from_codon() {
        codon.Residue(codon.Stop(_), _) -> into_codons([], acc)
        _ -> into_codons(rest, acc |> list.append([cd]))
      }
    }
    [_, _] | [_] -> Error(InvalidLengthError(sequence |> list.length()))
  }
}

pub fn reverse_translate(residues: List(codon.Residue)) -> String {
  residues
  |> list.map(fn(r) { r.residue.codon })
  |> string.join("")
  |> tools.normalize_sequence()
}
