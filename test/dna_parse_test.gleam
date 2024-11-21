import dnalg/actions/dna
import dnalg/core/sequence
import gleeunit/should

pub fn dna_parse_test() {
  dna.transcribe("ATGTTCACG")
  |> should.equal(sequence.Transcription(["ATG", "TTC", "ACG"], 0))
  dna.transcribe("ATGTTTCTTTGAATGGGG")
  |> should.equal(sequence.Transcription(["ATG", "TTT", "CTT"], 0))
}

pub fn dna_parse_invalid_base_test() {
  dna.transcribe("ATGTTTCTACF")
  |> should.equal(sequence.TranscriptionError(sequence.InvalidBaseError("F")))
}

pub fn dna_parse_no_start_codon_test() {
  dna.transcribe("ATATTTCTACT")
  |> should.equal(sequence.TranscriptionError(sequence.NoStartCodon))
}
