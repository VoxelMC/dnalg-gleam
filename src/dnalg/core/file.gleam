import dnalg/core/sequence

pub opaque type File {
  Fasta(title: String, sequence: sequence.DnaSequence)
  GenBank(accession: String, sequence: sequence.DnaSequence, source: String)
}

/// Returns the title for `.fasta` and the accession for `.gb`.
pub fn get_accession(file: File) -> String {
  case file {
    Fasta(title, _) -> title
    GenBank(accession, _, _) -> accession
  }
}

/// Get the source field from a file. Returns the title for `.fasta` and the
/// `SOURCE` for `.gb`.
pub fn get_source(file: File) {
  case file {
    Fasta(title, _) -> title
    GenBank(_, _, source) -> source
  }
}

/// Get the raw sequence from a file.
pub fn get_raw(file: File) -> String {
  file.sequence |> sequence.raw
}

/// Always constructs a `Fasta` type.
pub fn fasta(title title, sequence sequence: sequence.DnaSequence) -> File {
  Fasta(title:, sequence:)
}

/// Always constructs a `GenBank` type.
pub fn genbank(
  accession accession: String,
  sequence sequence: sequence.DnaSequence,
  source source: String,
) -> File {
  GenBank(accession:, sequence:, source:)
}

/// Constructs an empty `.gb` file.
pub const gb_empty = GenBank("", sequence.empty, "")

/// Constructs an empty `.fasta` file.
pub const fasta_empty = Fasta("", sequence.empty)
