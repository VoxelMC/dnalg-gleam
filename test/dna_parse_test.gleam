import dnalg/actions/dna
import dnalg/core/sequence
import gleeunit/should

pub fn dna_parse_test() {
  dna.translate("ATGTTCACG")
  |> should.equal(sequence.Transcription(["ATG", "TTC", "ACG"], 0))
  dna.translate("ATGTTTCTTTGAATGGGG")
  |> should.equal(sequence.Transcription(["ATG", "TTT", "CTT"], 0))
}

pub fn dna_parse_invalid_base_test() {
  dna.translate("ATGTTTCTACF")
  |> should.equal(sequence.TranscriptionError(sequence.InvalidBaseError("F")))
}

pub fn dna_parse_no_start_codon_test() {
  dna.translate("ATATTTCTACT")
  |> should.equal(sequence.TranscriptionError(sequence.NoStartCodon))
}
