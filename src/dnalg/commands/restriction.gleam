import dnalg/actions/dna
import dnalg/actions/translation

import dnalg/core/codon.{Codon}
import dnalg/core/index
import dnalg/core/residue.{type Residue}
import dnalg/core/sequence.{Transcription, TranscriptionError}
import dnalg/core/tools

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

// TODO: Can we put translation type here instead of List(Residue)?
fn mutate(seq_translation: List(Residue), i: index.TranslationRange) {
  let #(b, m, a) = seq_translation |> translation.isolate_residue(i.start)
  let is_within_range = i.start <= i.end
  case m |> list.first, is_within_range {
    Ok(first), True -> {
      case first.alternates {
        [] ->
          mutate(seq_translation, index.TranslationRange(i.start + 1, i.end))
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
  let sites_left = count_sites(sequence:, recognition: site)
  let sequence = sequence |> dna.transcribe()
  mutate_tail(sequence:, recognition: site, sites_left:)
}

fn mutate_tail(
  sequence sequence: sequence.DnaTranscription,
  recognition site: String,
  sites_left sites_left: Int,
) {
  let recog_start = case
    sequence |> sequence.raw_transcript() |> string.split_once(on: site)
  {
    Ok(#(before, _)) -> {
      before |> string.length
    }
    Error(_) -> 0
  }

  // TODO: Check the number of restriction sites and act that number of times
  // upon the sequence

  let recog_len = site |> string.length
  let recog_end = recog_start + recog_len - 1

  let mutated = case sequence {
    Transcription(codons, _) -> {
      let translation =
        codons
        |> list.map(fn(c) { Codon(c) |> residue.from_codon() })

      let range = index.SequenceRange(recog_start, recog_end)
      let range = range |> index.into_trans_range()

      #(
        translation
          |> mutate(range),
        sites_left,
      )
    }
    TranscriptionError(_) -> #(Mutated("", []), 0)
  }

  case mutated {
    #(mut, 1) -> mut
    #(Mutated(mut, _), left) ->
      mutate_tail(mut |> dna.transcribe(), site, left - 1)
    #(CannotCompleteMutation, _) -> CannotCompleteMutation
  }
}

pub fn count_sites(sequence sequence: String, recognition site: String) -> Int {
  { sequence |> string.split(site) |> list.length() } - 1
}
