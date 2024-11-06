import actions/restriction
import gleam/io
import gleeunit/should

pub fn silent_mutation_test() {
  let seq = "AGTAGGGAGATCCCATGAAGGCGAAAGGGAAATAGTTCTGA"
  let assert restriction.Mutated(res, _) =
    seq
    |> restriction.silently_mutate(recognition: "GAATTC")

  res |> should.equal("ATGAAAGCGAAAGGGAAA")
}
