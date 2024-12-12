import dnalg/ffi/perf
import gleam/int
import gleam/io
import gleam/string
import simplifile

pub fn main() {
  str_replaces()
}

fn time(name: String, input: a, cb: fn(a) -> a) -> Nil {
  let start = perf.start()
  input |> cb
  let time = start |> perf.stop()
  io.println(":: " <> name <> ": " <> time |> int.to_string() <> " ms")
  Nil
}

fn str_replaces() {
  let assert Ok(f) = simplifile.read("./test/fixtures/sample_expected.txt")
  let x = f <> f <> f <> f <> f
  let y = x <> x <> x <> x <> x
  let file = y <> y <> y <> y <> y

  "split and join"
  |> time(file, fn(f) { string.split(f, "\n") |> string.join("") })

  "replace" |> time(file, string.replace(_, each: "\n", with: ""))

  "JS FFI" |> time(file, perf.split_test)
}
