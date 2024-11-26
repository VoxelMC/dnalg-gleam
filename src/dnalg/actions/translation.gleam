import dnalg/core/residue.{type Residue}
import gleam/list

/// Splits a list of residues at an index, and returns a triple with the target
/// in the middle.
///
/// E.g. 
/// ```
/// #(before, at_index, after)
/// ```
pub fn isolate_residue(seq_translation: List(Residue), index: Int) {
  let #(before, rest) = seq_translation |> list.split(index)
  let #(middle, after) = rest |> list.split(1)
  #(before, middle, after)
}
