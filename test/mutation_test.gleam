import dnalg/commands/restriction
import dnalg/core/codon
import dnalg/core/tools
import gleam/bit_array
import gleam/list
import gleam/result
import gleam/string

import gleeunit/should

pub fn silent_mutation_test() {
  let seq =
    "AGTAGGGAGATCCC ATG AAT TCG AAA GGG AAA TAG TTCTGA"
    |> tools.normalize_sequence()
  let assert restriction.Mutated(res, _) =
    seq
    |> restriction.silently_mutate(recognition: "GAATTC")

  res
  |> should.equal("ATG AAC TCG AAA GGG AAA" |> tools.normalize_sequence())
}

pub fn silent_mutate_multiple_test() {
  // ATGAATTCG
  //   ^^^^^^
  // ATG has no alts -> mutate AAT:AAC -> ATGAACTCG
  // GGGAATTCG
  //   ^^^^^^
  // GGG has alts [GGA, GGC, GGT] -> choose one; mutate GGG:GGH
  let seq =
    {
      "AGTAGGGAGATCCC ATG AAT TCG AAA GGG AAA GGG AAT TCG AAA GGG AAA TAG TTCTGA"
    }
    |> tools.normalize_sequence()
  let assert restriction.Mutated(res, _) =
    seq
    |> restriction.silently_mutate(recognition: "GAATTC")

  // NOTE: Stupid but works. Behold my genius.
  case res |> bit_array.from_string() {
    <<_:bytes-size(18), rest:bytes>> -> {
      let first_three =
        rest
        |> bit_array.to_string()
        |> result.unwrap("")
        |> string.split("")
        |> list.take(3)
        |> string.join("")

      let is_alternate =
        codon.alternates(codon.Codon("GGG"), [])
        |> list.any(fn(c) { c == first_three })

      is_alternate |> should.be_true()
    }
    _ -> Nil
  }
}

pub fn count_test() {
  let seq =
    {
      "AGTAGGGAGATCCC ATG AAT TCG AAA GGG AAA"
      <> "GGG AAT TCG AAA GGG AAA TAG TTCTGA"
    }
    |> tools.normalize_sequence()
  let res = seq |> restriction.count_sites("GAATTC")
  res |> should.equal(2)

  let seq =
    "AATGC AAGA AATGC AAGA GGAGAGGAGAGGATTTCCC AAGA AACAGAT"
    |> tools.normalize_sequence()
  let res = seq |> restriction.count_sites("AAGA")

  res |> should.equal(3)
}
