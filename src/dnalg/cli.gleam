import dnalg/cli/input
import gleam/io
import gleam_community/ansi

import glint

import dnalg/cli/flags
import dnalg/commands/restriction
import dnalg/core/sequence as s
import dnalg/core/tools

pub fn get_splash() -> String {
  ansi.pink("󰚄 dnalg ") <> ansi.pink("") <> " the DNA manipulation tool"
}

pub fn splash(silent: Bool) {
  case silent {
    False -> {
      get_splash() |> io.println
    }
    True -> Nil
  }
}

pub fn cmd_silent_mutate() -> glint.Command(Nil) {
  use <- glint.command_help("Mutate DNA to dodge a restriction site.")
  use res_site <- glint.flag(flags.restriction())
  use _, args, flags <- glint.command()

  let assert Ok(site) = res_site(flags)
  let assert Ok(silent_splash) = glint.get_flag(flags, flags.silent_splash())
  splash(silent_splash)

  let sequence = input.get(args)

  case site, sequence {
    _, Error(_) -> "No DNA sequence provided" |> tools.as_error
    "", _ -> "No restriction site sequence provided." |> tools.as_error
    site, Ok(sequence) -> {
      // TODO: This will have to support validating `.FASTA` or `.GB` later.
      let is_valid = sequence |> s.validate_sequence
      case is_valid {
        "" -> {
          case restriction.silently_mutate(sequence, site) {
            restriction.Mutated(new_seq, _) -> {
              new_seq
            }
            _ -> {
              {
                "An error occurred while trying to mutate the sequence."
                <> "\n "
                <> " A restriction site may not be present"
              }
              |> tools.as_error
            }
          }
        }
        _ -> {
          "You have provided an invalid DNA sequence. Please review your input."
          |> tools.as_error
        }
      }
    }
  }
  |> io.println
}
