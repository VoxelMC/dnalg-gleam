import dnalg/core/codon
import gleam/int
import gleam/io
import gleam/string
import gleam_community/ansi
import glint

import dnalg/cli/flags
import dnalg/cli/input
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
      // let is_valid = sequence |> s.validate_sequence
      // case is_valid {
      //   "" -> {
      case restriction.silently_mutate(sequence, site) {
        restriction.Mutated(new_seq, _) -> {
          new_seq
        }
        restriction.CannotCompleteMutation(msg) -> {
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

pub fn cmd_codon_alts() {
  use <- glint.command_help("Count number of restriction sites in a sequence.")
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
          let count = restriction.count_sites(sequence:, recognition:)
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
