import actions/codon
import gleeunit/should

pub fn alternates_test() {
  codon.alternates_for("GTT", [])
  |> should.equal(["GTA", "GTC", "GTG"])

  codon.alternates_for("GTT", ["A"])
  |> should.equal(["GTC", "GTG"])

  codon.alternates_for("GTT", ["A", "C"])
  |> should.equal(["GTG"])
}

// TODO: For the future, make this test pass. Unnecessary for now, though!
// let test4 = codon.alternates_for("GTT", ["TC"])
// debug(#("test4", test4))

pub fn parse_aa_test() {
  let test1 = codon.get_amino_acid_from_codon("GTT")
  test1 |> should.equal(codon.ResidueClass(codon.Val, ["GTA", "GTC", "GTG"]))

  let test2 = codon.get_amino_acid_from_codon("ATC")
  test2 |> should.equal(codon.ResidueClass(codon.Ile, ["ATA", "ATT"]))

  let test3 = codon.get_amino_acid_from_codon("TTC")
  test3 |> should.equal(codon.ResidueClass(codon.Phe, ["TTT"]))

  let test4 = codon.get_amino_acid_from_codon("CCC")
  test4 |> should.equal(codon.ResidueClass(codon.Pro, ["CCA", "CCG", "CCT"]))
}
