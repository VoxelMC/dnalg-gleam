import dnalg/ffi/stdin

@internal
pub fn get(args) {
  case args {
    [] ->
      case stdin.read() {
        "" -> {
          Error(Nil)
        }
        input -> Ok(input)
      }
    [seq, ..] -> Ok(seq)
  }
}
