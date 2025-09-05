import dnalg/core/sequence
import dnalg/core/simulation.{type Simulation, GGASimulation}
import dnalg/core/tools

import term_size

import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam_community/ansi

pub fn main() {
  display_simulation(simulation.gga_sim_example)
}

@internal
pub opaque type Module {
  Mod(top: String, bot: String, index: Int, seq: String)
  Overlap(top: String, bot: String, matches: Bool)
}

// TODO: Add some way to tell which strand the overhang is on
// E.g.
// NNNNaaaa   VS   NNNN
// NNNN            NNNNaaaa
// for now, I am just assuming that the bottom strand is overhanging

pub fn display_simulation(sim: Simulation) {
  case sim {
    GGASimulation(fragments:, origin: _, sticky_ends:) -> {
      let junctions =
        list.window_by_2(sticky_ends)
        |> list.index_fold([], fn(acc, item, i) {
          let #(prev, cur) = item
          let clear = "      "
          let matches = {
            { prev.1 |> tools.normalize_sequence() } == { cur.0 |> comp() }
          }

          //  NOTE: Here is the logic to choose if the overlap is on the top or
          //  bottom (in the colour function)
          let top =
            cur.0
            |> tools.normalize_sequence()
            |> colour(i + 1, matches |> bool.negate)
          let bot =
            prev.1
            |> tools.normalize_sequence()
            |> colour(i, matches |> bool.negate)

          let out = case matches {
            True -> Overlap(top:, bot:, matches:)
            False -> Overlap(top: clear <> top, bot: bot <> clear, matches:)
          }

          [out, ..acc]
        })
        |> list.reverse()

      let first_ends = list.first(sticky_ends) |> result.unwrap(#("", ""))
      let last_ends = list.last(sticky_ends) |> result.unwrap(#("", ""))
      let modules =
        fragments
        |> list.index_fold([], fn(acc, item, i) {
          // TODO: Abstract some of this for use later. Okay to keep here for
          // now.
          let apply_colour = colour(i, False)
          let name = "Module " <> i |> int.to_string()
          let pad = string.repeat(" ", times: 3)
          let name_pad = string.repeat(" ", times: name |> string.length)
          [
            Mod(
              top: apply_colour(pad <> name <> pad),
              bot: apply_colour(
                pad
                <> { item |> string.length |> int.to_string() }
                <> "bp"
                <> pad,
              ),
              index: i,
              seq: item,
            ),
            ..acc
          ]
        })
        |> list.reverse()

      let junctions =
        [
          Overlap(
            top: first_ends.0 |> tools.normalize_sequence() |> colour(0, False),
            bot: string.repeat(" ", first_ends.0 |> string.length()),
            matches: True,
          ),
          ..junctions
        ]
        |> list.append([
          Overlap(
            bot: last_ends.1
              |> tools.normalize_sequence()
              |> colour(junctions |> list.length(), False),
            top: string.repeat(" ", first_ends.0 |> string.length()),
            matches: True,
          ),
        ])

      let interleaved = list.interleave([junctions, modules])
      let term_width = term_size.columns() |> result.unwrap(0)

      let #(top, bot) = #(
        list.fold(interleaved, "", fn(acc, junction) { acc <> junction.top }),
        list.fold(interleaved, "", fn(acc, junction) { acc <> junction.bot }),
      )

      io.debug(term_size.columns() |> result.unwrap(0))
      io.debug(top |> ansi.strip |> string.to_graphemes() |> list.length)
      io.debug(bot |> ansi.strip |> string.to_graphemes() |> list.length)

      io.println(top)
      io.println(bot)

      Nil
    }
  }
}

fn comp(seq: String) {
  seq
  |> sequence.new
  |> sequence.complement()
  |> sequence.unwrap()
}

/// Choose a colour for sim text based on module index.
fn colour(i: Int, is_error: Bool) {
  let text_colour = case is_error {
    False -> ansi.black
    True -> ansi.hex(_, 0xFF0000)
  }

  case int.max(0, i % 5) {
    0 -> fn(s: String) { s |> ansi.bg_red() |> text_colour }
    1 -> fn(s: String) { s |> ansi.bg_blue() |> text_colour }
    2 -> fn(s: String) { s |> ansi.bg_green() |> text_colour }
    3 -> fn(s: String) { s |> ansi.bg_pink() |> text_colour }
    4 -> fn(s: String) { s |> ansi.bg_yellow() |> text_colour }
    _ -> panic as "absolutely inconceivable"
  }
}
//
// fn rev_comp(seq: String) {
//   seq
//   |> sequence.new
//   |> sequence.reverse_complement()
//   |> sequence.unwrap()
// }
