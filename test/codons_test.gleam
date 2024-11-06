import core/codon.{Codon}
import core/residue as r
import gleeunit/should

pub fn alternates_test() {
  codon.alternates(Codon("GTT"), [])
  |> should.equal(["GTA", "GTC", "GTG"])

  codon.alternates(Codon("GTT"), ["A"])
  |> should.equal(["GTC", "GTG"])

  codon.alternates(Codon("GTT"), ["A", "C"])
  |> should.equal(["GTG"])
}

// TODO: For the future, make this test pass. Unnecessary for now, though!
// let test4 = codon.alternates_for("GTT", ["TC"])
// debug(#("test4", test4))

pub fn parse_aa_test() {
  let test1 = r.from_codon(Codon("GTT"))
  test1
  |> should.equal(r.Residue(r.Val, "GTT", "V", ["GTA", "GTC", "GTG"]))

  let test2 = r.from_codon(Codon("ATC"))
  test2 |> should.equal(r.Residue(r.Ile, "ATC", "I", ["ATA", "ATT"]))

  let test3 = r.from_codon(Codon("TTC"))
  test3 |> should.equal(r.Residue(r.Phe, "TTC", "F", ["TTT"]))

  let test4 = r.from_codon(Codon("CCC"))
  test4
  |> should.equal(r.Residue(r.Pro, "CCC", "P", ["CCA", "CCG", "CCT"]))
}
