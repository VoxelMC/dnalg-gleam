import core/codon.{type Codon, Codon}
import core/tools
import gleam/string

pub type AminoAcid {
  Stop
  Ala
  Arg
  Asn
  Asp
  Cys
  Gln
  Glu
  Gly
  His
  Ile
  Leu
  Lys
  Met
  Phe
  Pro
  Ser
  Thr
  Trp
  Tyr
  Val
}

pub type Residue {
  Residue(
    residue: AminoAcid,
    codon: String,
    // TODO: Maybe make this into a Codon type later. Too much work for now.
    letter: String,
    alternates: List(String),
  )
}

pub fn from_codon(codon: Codon) {
  let c = codon.str |> tools.normalize_sequence()
  let assert [first, second, third] = c |> string.split("")

  case first {
    "A" ->
      case second {
        "T" ->
          case third {
            "A" | "T" | "C" ->
              Residue(
                Ile,
                codon: c,
                letter: "I",
                alternates: codon.alternates(Codon(c), ["G"]),
              )
            "G" -> Residue(Met, codon: c, letter: "M", alternates: [])
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "C" ->
          Residue(
            Thr,
            codon: c,
            letter: "T",
            alternates: codon.alternates(Codon(c), []),
          )
        "A" ->
          case third {
            "A" | "G" ->
              Residue(
                Lys,
                codon: c,
                letter: "K",
                alternates: codon.alternates(Codon(c), ["T", "C"]),
              )
            "T" | "C" ->
              Residue(
                Asn,
                codon: c,
                letter: "N",
                alternates: codon.alternates(Codon(c), ["A", "G"]),
              )
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "G" ->
          case third {
            "A" | "G" ->
              Residue(
                Arg,
                codon: c,
                letter: "R",
                alternates: codon.alternates(Codon(c), ["T", "C"]),
              )
            "T" | "C" ->
              Residue(
                Ser,
                codon: c,
                letter: "S",
                alternates: codon.alternates(Codon(c), ["A", "G"]),
              )
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        _ -> panic as { second <> " is not a valid nucleotide." }
      }
    "T" ->
      case second {
        "T" ->
          case third {
            "A" | "G" ->
              Residue(
                Leu,
                codon: c,
                letter: "L",
                alternates: codon.alternates(Codon(c), ["C", "T"]),
              )
            "T" | "C" ->
              Residue(
                Phe,
                codon: c,
                letter: "F",
                alternates: codon.alternates(Codon(c), ["A", "G"]),
              )
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "A" ->
          case third {
            "A" | "G" ->
              Residue(
                Stop,
                codon: c,
                letter: "*",
                alternates: codon.alternates(Codon(c), ["T", "C"]),
              )
            "T" | "C" ->
              Residue(
                Tyr,
                codon: c,
                letter: "Y",
                alternates: codon.alternates(Codon(c), ["A", "G"]),
              )
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "G" ->
          case third {
            "A" ->
              Residue(
                Stop,
                codon: c,
                letter: "*",
                alternates: codon.alternates(Codon(c), ["T", "C", "G"]),
              )
            "T" | "C" ->
              Residue(
                Cys,
                codon: c,
                letter: "C",
                alternates: codon.alternates(Codon(c), ["A", "G"]),
              )
            "G" -> Residue(Trp, codon: c, letter: "W", alternates: [])
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "C" ->
          Residue(
            Ser,
            codon: c,
            letter: "S",
            alternates: codon.alternates(Codon(c), []),
          )
        _ -> panic as { second <> " is not a valid nucleotide." }
      }
    "G" ->
      case second {
        "A" ->
          case third {
            "A" | "G" ->
              Residue(
                Glu,
                codon: c,
                letter: "E",
                alternates: codon.alternates(Codon(c), ["T", "C"]),
              )
            "T" | "C" ->
              Residue(
                Asp,
                codon: c,
                letter: "D",
                alternates: codon.alternates(Codon(c), ["A", "G"]),
              )
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "C" ->
          Residue(
            Ala,
            codon: c,
            letter: "A",
            alternates: codon.alternates(Codon(c), []),
          )
        "G" ->
          Residue(
            Gly,
            codon: c,
            letter: "G",
            alternates: codon.alternates(Codon(c), []),
          )
        "T" ->
          Residue(
            Val,
            codon: c,
            letter: "V",
            alternates: codon.alternates(Codon(c), []),
          )
        _ -> panic as { second <> " is not a valid nucleotide." }
      }
    "C" ->
      case second {
        "T" ->
          Residue(
            Leu,
            codon: c,
            letter: "L",
            alternates: codon.alternates(Codon(c), []),
          )
        "C" ->
          Residue(
            Pro,
            codon: c,
            letter: "P",
            alternates: codon.alternates(Codon(c), []),
          )
        "A" ->
          case third {
            "A" | "G" ->
              Residue(
                Gln,
                codon: c,
                letter: "Q",
                alternates: codon.alternates(Codon(c), ["T", "C"]),
              )
            "T" | "C" ->
              Residue(
                His,
                codon: c,
                letter: "H",
                alternates: codon.alternates(Codon(c), ["A", "G"]),
              )
            _ -> panic as { third <> " is not a valid nucleotide." }
          }
        "G" ->
          Residue(
            Arg,
            codon: c,
            letter: "R",
            alternates: codon.alternates(Codon(c), []),
          )
        _ -> panic as { second <> " is not a valid nucleotide." }
      }
    _ -> panic as { first <> " is not a valid nucleotide." }
  }
}
