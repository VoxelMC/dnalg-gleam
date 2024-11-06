import core/tools
import gleam/list
import gleam/string

pub type Codon {
  Codon(str: String)
}

pub fn alternates(codon codon: Codon, exclude exclude: List(String)) {
  let codon = codon.str |> tools.normalize_sequence()
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
