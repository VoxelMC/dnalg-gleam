import gleam/iterator
import gleam/string
import stdin

@external(javascript, "../stdin_ffi.mjs", "read_stdin")
pub fn read() -> String {
  stdin.stdin()
  |> iterator.to_list
  |> string.join("")
}
