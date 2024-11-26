import dnalg/actions/presets
import dnalg/core/codon
import dnalg/core/restriction
import gleam/int
import gleam/io
import gleam/string
import gleam_community/ansi
import glint

import dnalg/cli/flags
import dnalg/cli/input
import dnalg/commands/restriction_mutate
import dnalg/core/sequence as s
import dnalg/core/tools

pub fn get_splash() -> String {
  ansi.pink("󰚄 dnalg ") <> ansi.pink("") <> " the DNA manipulation tool"
}

@internal
pub fn splash(silent: Bool) {
  case silent {
    False -> {
      get_splash() |> io.println
    }
    True -> Nil
  }
}

@internal
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
      // let is_valid = sequence |> s.validate_sequence
      // case is_valid {
      //   "" -> {
      case restriction_mutate.silently_mutate(sequence, site) {
        restriction_mutate.Mutated(new_seq, _) -> {
          new_seq
        }
        restriction_mutate.CannotCompleteMutation(msg) -> {
          {
            "An error occurred while trying to mutate the sequence."
            <> "\n "
            <> " Reason: "
            <> msg
          }
          |> tools.as_error
        }
      }
    }
  }
  |> io.println
}

@internal
pub fn cmd_codon_alts() {
  use <- glint.command_help("Get a list of alternate codons for a given codon.")
  use _, args, flags <- glint.command()

  let assert Ok(silent_splash) = glint.get_flag(flags, flags.silent_splash())
  splash(silent_splash)

  let in = input.get(args)
  case in {
    Ok(seq) -> {
      let alts = codon.alternates(codon.Codon(seq), [])
      alts |> string.join(", ")
    }
    Error(_) -> {
      "No input provided." |> tools.as_error
    }
  }
  |> io.println
}

@internal
pub fn cmd_count_sites() {
  use <- glint.command_help("Count number of restriction sites in a sequence.")
  use res_site <- glint.flag(flags.restriction())
  use _, args, flags <- glint.command()

  let assert Ok(site) = res_site(flags)
  let assert Ok(silent_splash) = glint.get_flag(flags, flags.silent_splash())
  splash(silent_splash)

  let sequence = input.get(args)
  case site, sequence {
    _, Error(_) -> "No DNA sequence provided" |> tools.as_error
    "", _ -> "No restriction site sequence provided." |> tools.as_error
    recognition, Ok(sequence) -> {
      let is_valid = sequence |> s.validate_sequence
      case is_valid {
        "" -> {
          let count = restriction_mutate.count_sites(sequence:, recognition:)
          count |> int.to_string()
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

@internal
pub fn cmd_parse_r_site() {
  use <- glint.command_help(
    "Parse a restriction enzyme string and show its details.",
  )
  use _, args, flags <- glint.command()

  let assert Ok(silent_splash) = glint.get_flag(flags, flags.silent_splash())
  splash(silent_splash)
  let site = input.get(args)
  case site {
    Ok(seq) -> {
      case restriction.from_string(seq) {
        Ok(site) -> {
          site |> restriction.debug()
        }
        Error(err) -> {
          case err {
            restriction.InvalidBase(invs) ->
              { "Invalid bases found in sequence: " <> invs } |> tools.as_error
            _ -> {
              io.debug(err)
              "Help!" |> tools.as_error
            }
          }
        }
      }
    }
    Error(_) -> {
      "No input provided." |> tools.as_error
    }
  }
  |> io.println
}

pub fn cmd_parse_r_preset() {
  use <- glint.command_help(
    "Check if a restriction enzyme preset is available based on its name.",
  )
  use _, args, flags <- glint.command()

  let assert Ok(silent_splash) = glint.get_flag(flags, flags.silent_splash())
  splash(silent_splash)

  let preset = input.get(args)
  case preset {
    Ok(name) -> {
      case presets.restriction_enzymes(name) {
        Ok(enzyme) -> enzyme |> restriction.debug()
        Error(restriction.PresetNotExists(n)) ->
          { "\"" <> ansi.yellow(n) <> "\" is not a preset." }
          |> tools.as_error()
        Error(_) -> {
          "An unknown error occurred." |> tools.as_error()
        }
      }
    }
    Error(_) -> {
      "No preset name provided." |> tools.as_error
    }
  }
  |> io.println
}
