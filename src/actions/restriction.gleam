import actions/codon
import actions/dna
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

  let recog_len = site |> string.length
  let recog_start = case sequence |> string.split_once(on: site) {
    Ok(#(before, _)) -> {
      before |> string.length
    }
    Error(_) -> 0
  }
  // let recog_end = recog_start + recog_len - 1

  let base_to_res_index = fn(x) {
    let b = x % 3
    let c = x - b
    { c + 1 } / 3
  }

  let seq = sequence |> dna.translate()

  case seq {
    Ok(codons) -> {
      let translation =
        codons
        |> list.map(fn(c) { c |> codon.get_amino_acid_from_codon() })

      let recog_start_res = base_to_res_index(recog_start)
      // let recog_end_res = base_to_res_index(recog_end)
      //
      // index of codon - 1 then split again at 1 for the trailing
      let #(before, rest) = translation |> list.split(recog_start_res)
      let #(middle, after) = rest |> list.split(1)

      // WARN: THESE STATEMENTS ASSERT OK. THIS IS NOT OK. I WILL ASSERT THAT
      // THIS IS NOT OK. PLEASE PLEASE PLEASE FIX THIS IN THE FUTURE!!!!!!!!!
      let assert Ok(middle_codon) = {
        middle |> list.first()
      }
      // TODO: Make this pic
      let assert Ok(new_codon) =
        middle_codon.alternate_codons |> list.shuffle() |> list.first()

      let new_translation =
        before
        |> list.append([codon.get_amino_acid_from_codon(new_codon)])
        |> list.append(after)

      let new_sequence = new_translation |> dna.reverse_translate()
      new_sequence
    }
    Error(_) -> panic
  }
}
