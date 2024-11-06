import actions/restriction
import gleam/string
import gleeunit/should

pub fn silent_mutation_test() {
  let seq =
    "AGTAGGGAGATCCC ATG AAT TCG AAA GGG AAA TAG TTCTGA"
    |> string.replace(each: " ", with: "")
  let assert restriction.Mutated(res, _) =
    seq
    |> restriction.silently_mutate(recognition: "GAATTC")

  res
  |> should.equal(
    "ATG AAC TCG AAA GGG AAA" |> string.replace(each: " ", with: ""),
  )
}
