import dnalg/core/sequence

pub opaque type File {
  Fasta(title: String, sequence: sequence.DnaSequence)
  GenBank(accession: String, sequence: sequence.DnaSequence, source: String)
}

/// Returns the title for .fasta and the accession for .gb
pub fn get_accession(file: File) {
  case file {
    Fasta(title, _) -> title
    GenBank(accession, _, _) -> accession
  }
}

pub fn get_source(file: File) {
  case file {
    Fasta(title, _) -> title
    GenBank(_, _, source) -> source
  }
}

pub fn get_raw(file: File) {
  file.sequence |> sequence.raw
}

// Always produces a Fasta type
pub fn fasta(title title, sequence sequence: sequence.DnaSequence) -> File {
  Fasta(title:, sequence:)
}

pub fn genbank(
  accession accession: String,
  sequence sequence: sequence.DnaSequence,
  source source: String,
) {
  GenBank(accession:, sequence:, source:)
}

pub const gb_empty = GenBank("", sequence.empty, "")

pub const fasta_empty = Fasta("", sequence.empty)