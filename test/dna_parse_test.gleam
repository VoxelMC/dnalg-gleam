import actions/dna
import gleeunit/should

pub fn dna_parse_test() {
  dna.translate("ATGTTCACG")
  |> should.equal(Ok(["ATG", "TTC", "ACG"]))
  dna.translate("ATGTTTCTTTGAATGGGG")
  |> should.equal(Ok(["ATG", "TTT", "CTT"]))
}

pub fn dna_parse_invalid_base_test() {
  dna.translate("ATGTTTCTACF")
  |> should.equal(Error(dna.InvalidBaseError("F")))
}

pub fn dna_parse_no_start_codon_test() {
  dna.translate("ATATTTCTACT")
  |> should.equal(Error(dna.TranslateError("No start codon found")))
}
