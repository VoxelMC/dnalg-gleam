import gleam/list
import gleam/string

// rename this module in the future

// Here, we will have a function which can check which amino acid a 3 letter
// sequence corresponds to.

// Another function will randomly choose a codon from a retrieved list of
// codons for the AA.

pub type AminoAcid {
  Stop(codon: String)
  Ala(codon: String)
  Arg(codon: String)
  Asn(codon: String)
  Asp(codon: String)
  Cys(codon: String)
  Gln(codon: String)
  Glu(codon: String)
  Gly(codon: String)
  His(codon: String)
  Ile(codon: String)
  Leu(codon: String)
  Lys(codon: String)
  Met(codon: String)
  Phe(codon: String)
  Pro(codon: String)
  Ser(codon: String)
  Thr(codon: String)
  Trp(codon: String)
  Tyr(codon: String)
  Val(codon: String)
}

pub type ResidueClass {
  ResidueClass(residue: AminoAcid, alternate_codons: List(String))
}

pub fn alternates_for(codon codon: String, exclude exclude: List(String)) {
  let assert [first, middle, last] = codon |> string.split("")
  let bases =
    ["T", "C", "A", "G"]
    |> list.filter(fn(base) {
      let test_excluded = exclude |> list.contains(base)
      let test_suffix = last == base
      !test_excluded && !test_suffix
    })

  bases
  |> list.map(fn(base) { first <> middle <> base })
  |> list.sort(by: string.compare)
}

pub fn get_amino_acid_from_codon(codon: String) {
  let assert [first, second, third] = codon |> string.split("")

  case first {
    "A" ->
      case second {
        "T" ->
          case third {
            "A" | "T" | "C" ->
              ResidueClass(Ile(codon), alternates_for(codon, ["G"]))
            "G" -> ResidueClass(Met(codon), [])
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "C" -> ResidueClass(Thr(codon), alternates_for(codon, []))
        "A" ->
          case third {
            "A" | "G" ->
              ResidueClass(Lys(codon), alternates_for(codon, ["T", "C"]))
            "T" | "C" ->
              ResidueClass(Asn(codon), alternates_for(codon, ["A", "G"]))
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "G" ->
          case third {
            "A" | "G" ->
              ResidueClass(Arg(codon), alternates_for(codon, ["T", "C"]))
            "T" | "C" ->
              ResidueClass(Ser(codon), alternates_for(codon, ["A", "G"]))
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        _ -> panic as { second <> " is not a valid nucleotide." }
      }
    "T" ->
      case second {
        "T" ->
          case third {
            "A" | "G" ->
              ResidueClass(Leu(codon), alternates_for(codon, ["C", "T"]))
            "T" | "C" ->
              ResidueClass(Phe(codon), alternates_for(codon, ["A", "G"]))
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "A" ->
          case third {
            "A" | "G" ->
              ResidueClass(Stop(codon), alternates_for(codon, ["T", "C"]))
            "T" | "C" ->
              ResidueClass(Tyr(codon), alternates_for(codon, ["A", "G"]))
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "G" ->
          case third {
            "A" ->
              ResidueClass(Stop(codon), alternates_for(codon, ["T", "C", "G"]))
            "T" | "C" ->
              ResidueClass(Cys(codon), alternates_for(codon, ["A", "G"]))
            "G" -> ResidueClass(Trp(codon), [])
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "C" -> ResidueClass(Ser(codon), alternates_for(codon, []))
        _ -> panic as { second <> " is not a valid nucleotide." }
      }
    "G" ->
      case second {
        "A" ->
          case third {
            "A" | "G" ->
              ResidueClass(Glu(codon), alternates_for(codon, ["T", "C"]))
            "T" | "C" ->
              ResidueClass(Asp(codon), alternates_for(codon, ["A", "G"]))
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "C" -> ResidueClass(Ala(codon), alternates_for(codon, []))
        "G" -> ResidueClass(Gly(codon), alternates_for(codon, []))
        "T" -> ResidueClass(Val(codon), alternates_for(codon, []))
        _ -> panic as { second <> " is not a valid nucleotide." }
      }
    "C" ->
      case second {
        "T" -> ResidueClass(Leu(codon), alternates_for(codon, []))
        "C" -> ResidueClass(Pro(codon), alternates_for(codon, []))
        "A" ->
          case third {
            "A" | "G" ->
              ResidueClass(Gln(codon), alternates_for(codon, ["T", "C"]))
            "T" | "C" ->
              ResidueClass(His(codon), alternates_for(codon, ["A", "G"]))
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "G" -> ResidueClass(Arg(codon), alternates_for(codon, []))
        _ -> panic as { second <> " is not a valid nucleotide." }
      }
    _ -> panic as { first <> " is not a valid nucleotide." }
  }
}
