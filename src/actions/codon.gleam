import gleam/list
import gleam/string
import tools

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

pub type Residue {
  Residue(residue: AminoAcid, alternate_codons: List(String))
}

pub fn alternates_for(codon codon: String, exclude exclude: List(String)) {
  let codon = codon |> tools.normalize_sequence()
  let exclude = exclude |> list.map(fn(s) { s |> tools.normalize_sequence() })

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
  let codon = codon |> tools.normalize_sequence()
  let assert [first, second, third] = codon |> string.split("")

  case first {
    "A" ->
      case second {
        "T" ->
          case third {
            "A" | "T" | "C" -> Residue(Ile(codon), alternates_for(codon, ["G"]))
            "G" -> Residue(Met(codon), [])
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "C" -> Residue(Thr(codon), alternates_for(codon, []))
        "A" ->
          case third {
            "A" | "G" -> Residue(Lys(codon), alternates_for(codon, ["T", "C"]))
            "T" | "C" -> Residue(Asn(codon), alternates_for(codon, ["A", "G"]))
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "G" ->
          case third {
            "A" | "G" -> Residue(Arg(codon), alternates_for(codon, ["T", "C"]))
            "T" | "C" -> Residue(Ser(codon), alternates_for(codon, ["A", "G"]))
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        _ -> panic as { second <> " is not a valid nucleotide." }
      }
    "T" ->
      case second {
        "T" ->
          case third {
            "A" | "G" -> Residue(Leu(codon), alternates_for(codon, ["C", "T"]))
            "T" | "C" -> Residue(Phe(codon), alternates_for(codon, ["A", "G"]))
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "A" ->
          case third {
            "A" | "G" -> Residue(Stop(codon), alternates_for(codon, ["T", "C"]))
            "T" | "C" -> Residue(Tyr(codon), alternates_for(codon, ["A", "G"]))
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "G" ->
          case third {
            "A" -> Residue(Stop(codon), alternates_for(codon, ["T", "C", "G"]))
            "T" | "C" -> Residue(Cys(codon), alternates_for(codon, ["A", "G"]))
            "G" -> Residue(Trp(codon), [])
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "C" -> Residue(Ser(codon), alternates_for(codon, []))
        _ -> panic as { second <> " is not a valid nucleotide." }
      }
    "G" ->
      case second {
        "A" ->
          case third {
            "A" | "G" -> Residue(Glu(codon), alternates_for(codon, ["T", "C"]))
            "T" | "C" -> Residue(Asp(codon), alternates_for(codon, ["A", "G"]))
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "C" -> Residue(Ala(codon), alternates_for(codon, []))
        "G" -> Residue(Gly(codon), alternates_for(codon, []))
        "T" -> Residue(Val(codon), alternates_for(codon, []))
        _ -> panic as { second <> " is not a valid nucleotide." }
      }
    "C" ->
      case second {
        "T" -> Residue(Leu(codon), alternates_for(codon, []))
        "C" -> Residue(Pro(codon), alternates_for(codon, []))
        "A" ->
          case third {
            "A" | "G" -> Residue(Gln(codon), alternates_for(codon, ["T", "C"]))
            "T" | "C" -> Residue(His(codon), alternates_for(codon, ["A", "G"]))
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "G" -> Residue(Arg(codon), alternates_for(codon, []))
        _ -> panic as { second <> " is not a valid nucleotide." }
      }
    _ -> panic as { first <> " is not a valid nucleotide." }
  }
}
