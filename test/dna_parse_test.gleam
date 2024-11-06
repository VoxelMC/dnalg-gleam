import actions/dna
import gleeunit/should

pub fn dna_parse_test() {
  dna.translate("ATGTTCACG")
  |> should.equal(dna.Translation(["ATG", "TTC", "ACG"], 0))
  dna.translate("ATGTTTCTTTGAATGGGG")
  |> should.equal(dna.Translation(["ATG", "TTT", "CTT"], 0))
}

pub fn dna_parse_invalid_base_test() {
  dna.translate("ATGTTTCTACF")
  |> should.equal(dna.TranslationError(dna.InvalidBaseError("F")))
}

pub fn dna_parse_no_start_codon_test() {
  dna.translate("ATATTTCTACT")
  |> should.equal(dna.TranslationError(dna.NoStartCodon))
}
