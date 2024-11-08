import actions/dna
import actions/translation

import core/codon.{Codon}
import core/residue.{type Residue}
import core/tools

import gleam/io
import gleam/list
import gleam/string

pub type RestrictionResult {
  Digested(cuts: Int, fragments: List(String))
  InvalidSequence
}

/// This function will asses the DNA sequence and return:
/// - RestrictionResult::Digested(cuts, fragments)
/// - RestrictionResult::NotDigested
/// - RestrictionResult::InvalidSequence
pub fn try_digest() {
  io.println("Trying is the best way to start")
}

pub type ResidueRange {
  ResidueRange(start: Int, end: Int)
}

pub type MutationResult {
  Mutated(new_sequence: String, new_residues: List(Residue))
  CannotCompleteMutation
}

fn mutate(seq_translation: List(Residue), i: ResidueRange) {
  let #(b, m, a) = seq_translation |> translation.isolate_residue(i.start)
  let is_within_range = i.start <= i.end
  case m |> list.first, is_within_range {
    Ok(first), True -> {
      case first.alternates {
        [] -> mutate(seq_translation, ResidueRange(i.start + 1, i.end))
        codons -> {
          // Breathe... this is okay :)
          let assert Ok(new_codon) = codons |> list.shuffle() |> list.first()

          let new_translation =
            b
            |> list.append([residue.from_codon(Codon(new_codon))])
            |> list.append(a)

          let new_sequence = new_translation |> dna.reverse_translate()
          Mutated(new_sequence:, new_residues: new_translation)
        }
      }
    }
    Ok(_), False -> CannotCompleteMutation
    Error(_), True | Error(_), False ->
      panic as "Invalid DNA Sequence. Please review your input."
    // Should have been validated by now.
  }
}

pub fn silently_mutate(sequence sequence: String, recognition site: String) {
  // This function needs to find which codons are affected by the cut site.
  // This is just an index for start and end.
  // Then, divide the indexes by three to get the codon range.
  //
  // if site is 7 long
  //
  // 0   1   2   3   4
  // ABC DEF GHI JKL MN...
  //      ^^ ^^^ ^^
  // 0    4       10
  // Then, excise the first residue which can be silently mutated, and mutate
  // it!
  let sequence = sequence |> tools.normalize_sequence()

  let recog_start = case sequence |> string.split_once(on: site) {
    Ok(#(before, _)) -> {
      before |> string.length
    }
    Error(_) -> 0
  }

  let recog_len = site |> string.length
  let recog_end = recog_start + recog_len - 1

  // Probably don't change this.
  let base_to_res_index = fn(x) {
    let b = x % 3
    let c = x - b
    { c + 1 } / 3
  }

  let seq = sequence |> dna.translate()

  case seq {
    dna.Translation(codons, trimmed) -> {
      let translation =
        codons
        |> list.map(fn(c) { Codon(c) |> residue.from_codon() })

      let range =
        ResidueRange(
          base_to_res_index(recog_start - trimmed),
          base_to_res_index(recog_end - trimmed),
        )

      translation
      |> mutate(range)
    }
    dna.TranslationError(_) -> Mutated("", [])
  }
}
