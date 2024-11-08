import argv
import glint

import cli.{cmd_silent_mutate}
import cli/flags

pub fn main() {
  glint.new()
  |> glint.with_name("dnalg")
  |> glint.pretty_help(glint.default_pretty_help())
  |> glint.add(at: ["silent-mutate"], do: cmd_silent_mutate())
  |> glint.group_flag([], flags.silent_splash())
  |> glint.run(argv.load().arguments)
}
