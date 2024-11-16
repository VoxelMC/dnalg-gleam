import dnalg/core/residue.{type Residue}
import gleam/list

pub fn isolate_residue(seq_translation: List(Residue), index: Int) {
  let #(before, rest) = seq_translation |> list.split(index)
  let #(middle, after) = rest |> list.split(1)
  #(before, middle, after)
}
