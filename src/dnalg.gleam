import argv
import gleam/io
import gleam/list
import gleam_community/ansi
import glint

import dnalg/cli
import dnalg/cli/flags
import dnalg/core/tools

fn default() {
  use _, _, flags <- glint.command()
  let assert Ok(silent_splash) = glint.get_flag(flags, flags.silent_splash())
  cli.splash(silent_splash)
  {
    "Please provide a command to run.\n"
    <> "  You can add the "
    <> ansi.green("--help")
    <> " flag for more info."
  }
  |> tools.as_error
  |> io.println_error()
}

pub fn main() {
  run([])
}

/// Entrypoint which can be used when running DNAlg programmatically. 
/// When called with an empty array (`[]`), will fall-back to
/// `argv.load().arguments`.
pub fn run(args: List(String)) {
  let help_msg =
    cli.get_splash()
    <> "\n"
    <> "You can provide a sequence via "
    <> ansi.pink("stdin")
    <> " or into "
    <> ansi.pink("ARGS")
    <> ".\n"
    <> ansi.hex("    E.g.  ", 0x6bb5ea)
    <> ansi.green("$ echo \"ATCG\" | dnalg ... ")
    <> ansi.hex("\n          ", 0x6bb5ea)
    <> ansi.green("$ cat seq.txt | dnalg ...")
    <> ansi.hex("\n          ", 0x6bb5ea)
    <> ansi.green("$ dnalg ATCG ...")

  glint.new()
  |> glint.with_name("dnalg")
  |> glint.pretty_help(glint.default_pretty_help())
  |> glint.global_help(help_msg)
  |> glint.add(at: [], do: default())
  |> glint.add(at: ["clean"], do: cli.cmd_silent_mutate())
  |> glint.add(at: ["sites"], do: cli.cmd_count_sites())
  |> glint.add(at: ["calts"], do: cli.cmd_codon_alts())
  |> glint.group_flag([], flags.silent_splash())
  |> glint.group_flag([], flags.output())
  |> glint.run(case args |> list.length {
    0 -> argv.load().arguments
    _ -> args
  })
}
