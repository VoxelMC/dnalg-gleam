import dnalg/commands/restriction
import dnalg/core/tools

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
