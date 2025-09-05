import gleam/io
import gleam/list
import gleam/string

const str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

pub fn main() {
  rotate(str, 8) |> io.debug
}

fn rotate(str: String, degrees: Int) {
  let graphemes = str |> string.to_graphemes()
  let head = graphemes |> list.take(degrees)
  let tail = graphemes |> list.drop(degrees)
  [tail, head] |> list.flatten() |> string.join("")
}
