import argv
import cli/flags.{caps_flag}
import gleam/io
import gleam/string
import glint

fn hello() -> glint.Command(Nil) {
  // set the help text for the hello command
  use <- glint.command_help("Prints Hello, <NAME>!")
  // register the caps flag with the command
  // the `caps` variable there is a type-safe getter for the flag value
  use caps <- glint.flag(caps_flag())
  // start the body of the command
  // this is what will be executed when the command is called
  use _, args, flags <- glint.command()
  // we can assert here because the caps flag has a default
  // and will therefore always have a value assigned to it
  let assert Ok(caps) = caps(flags)
  // this is where the business logic of our command starts
  let name = case args {
    [] -> "Joe"
    [name, ..] -> name
  }
  let msg = "Hello, " <> name <> "!"
  case caps {
    True -> string.uppercase(msg)
    False -> msg
  }
  |> io.println
}

pub fn main() {
  // restriction.try_digest()
  io.println("Hello from dnalg!")
  glint.new()
  // with an app name of "hello", this is used when printing help text
  |> glint.with_name("hello")
  // with pretty help enabled, using the built-in colours
  |> glint.pretty_help(glint.default_pretty_help())
  // with a root command that executes the `hello` function
  |> glint.add(at: [], do: hello())
  // execute given arguments from stdin
  |> glint.run(argv.load().arguments)
}
