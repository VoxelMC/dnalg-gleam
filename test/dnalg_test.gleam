import actions/codon
import actions/restriction
import gleam/io
import gleeunit
import gleeunit/should

// import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn thing_test() {
  restriction.silently_mutate("ATGAAAACTTAC", "ATGAAA")
  codon.get_amino_acid_from_codon("AAA") |> io.debug()
}
