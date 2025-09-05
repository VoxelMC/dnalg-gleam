import dnalg/actions/genbank
import dnalg/core/file
import dnalg/core/sequence
import dnalg/core/tools
import gleam/list
import gleam/result
import gleam/string
import gleeunit
import gleeunit/should
import simplifile

import dnalg/actions/fasta

// import gleam/io.{debug}

pub fn main() {
  let _ = gb_fixtures_test()
  gleeunit.main()
}

pub fn parse_fasta_test() {
  let in = ">Test Gene\nAAGAGAGGGAGGGAGAGGAG"
  let multiline_in = in <> "\n" <> in

  let res = fasta.parse(in)
  let multi_res = fasta.parse(multiline_in)
  // let _ = pprint.debug(res)
  // let _ = pprint.debug(multi_res)
  res
  |> should.equal(
    Ok([file.fasta("Test Gene", sequence.new("AAGAGAGGGAGGGAGAGGAG"))]),
  )
  multi_res
  |> should.equal(
    Ok([
      file.fasta("Test Gene", sequence.new("AAGAGAGGGAGGGAGAGGAG")),
      file.fasta("Test Gene", sequence.new("AAGAGAGGGAGGGAGAGGAG")),
    ]),
  )
}

pub fn fasta_fixtures_test() {
  let assert Ok(file) = simplifile.read("./test/fixtures/sample.fasta")

  let assert Ok(head) = file |> fasta.parse_head()
  let assert Ok(parsed) = file |> fasta.parse()
  // let _ = head |> pprint.debug()
  // let _ = parsed |> pprint.debug()

  head |> list.length() |> should.equal(1)
  parsed |> list.length() |> should.equal(3)
}

pub fn gb_fixtures_test() {
  let expected =
    simplifile.read("./test/fixtures/sample_expected.txt")
    |> result.unwrap("")
    |> tools.normalize_sequence()

  let assert Ok(file) = simplifile.read("./test/fixtures/sample.gb")
  let parsed = genbank.parse_sequence(file) |> result.unwrap(sequence.empty)

  parsed
  |> sequence.unwrap()
  |> string.length
  |> should.equal(expected |> string.length)
}

pub fn gb_source_parse_test() {
  let assert Ok(file) = simplifile.read("./test/fixtures/sample.gb")
  let parsed_source = genbank.parse_source(file)

  parsed_source |> should.equal(Ok("Saccharomyces cerevisiae (baker's yeast)"))
}
