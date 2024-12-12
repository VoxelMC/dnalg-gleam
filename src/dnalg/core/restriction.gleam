import gleam/bool
import gleam/int
import gleam/list
import gleam/order.{Eq}
import gleam/string

import dnalg/core/sequence
import dnalg/core/tools

// - Parse restriction site format
// - Produce a restriction site type
// - Construct it from a string
pub type RestrictionDirection {
  Left
  Right
}

pub opaque type RestrictionSite {
  RestrictionSite(
    recognition: String,
    cut_index: Int,
    asymmetric: Bool,
    length: Int,
    direction: RestrictionDirection
  )
}

pub type RestrictionParseError {
  MissingCutChar
  TooManyCutChar
  InvalidBase(invalid_bases: String)
  PresetNotExists(name: String)
}

/// Limitations: This module does not support restriction enzymes which have two recognition
/// sites. Moreover, nicking enzymes are also not supported.
pub fn from_string(input: String) {
  parse_restriction_string(input)
}

pub fn recognition(rs: RestrictionSite) {
  rs.recognition
}

pub fn is_asymmetric(rs: RestrictionSite) {
  rs.asymmetric
}

pub fn len(rs: RestrictionSite) {
  rs.length
}

pub fn can_cut(rs: RestrictionSite) {
  rs.cut_index != -1
}

pub fn debug(rs: RestrictionSite) {
  [
    "Recognition: " <> rs.recognition,
    "Cut Index: " <> rs.cut_index |> int.to_string,
    "Asymmetric: " <> rs.asymmetric |> bool.to_string,
  ]
  |> string.join("\n")
}

pub fn get_cut_index(rs: RestrictionSite, start_index: Int) {
  start_index + rs.cut_index
}

/// A restriction string requires the following.
/// The recognition site, written in canonical DNA bases A, C, G, and T.
/// The cut site, denoted by a ^
/// To be written in the 5' -> 3' direction.
fn parse_restriction_string(input: String) {
  // If we have NNN^NNN, cut_index will be 3, meaning we cut AFTER 3 after the
  // first base. MEANING, we need to decrement this index if based from 0.
  let input = input |> tools.normalize_sequence()
  let spl = input |> string.split("^")
  let is_valid =
    input
    |> string.to_graphemes()
    |> list.all(fn(ch) {
      case ch |> sequence.validate_base_p(), ch {
        False, "N" | False, "^" -> {
          True
        }
        True, _ -> True
        False, _ -> False
      }
    })

  case spl |> list.length(), is_valid {
    1, True -> {
      let cut_index = -1
      let recognition = {
        let assert [f, ..] = spl
        f |> clean
      }
      let asymmetric = False
      let length = recognition |> string.length

      Ok(RestrictionSite(recognition:, cut_index:, asymmetric:, length:))
    }
    2, True -> {
      let assert [pre, post] = spl
      let cut_index = pre |> string.length
      let #(clean_pre, clean_post) = #(pre |> clean, post |> clean)
      let recognition = clean_pre <> clean_post
      let asymmetric =
        string.compare(pre, clean_pre) != Eq
        || string.compare(post, clean_post) != Eq

      let length = recognition |> string.length

      Ok(RestrictionSite(recognition:, cut_index:, asymmetric:, length:))
    }
    _, False ->
      Error(InvalidBase(
        input
        |> sequence.validate_sequence()
        |> string.replace("N", "")
        |> string.replace("^", ""),
      ))
    _, _ -> Error(TooManyCutChar)
  }
}

fn clean(str: String) {
  str |> string.replace("N", "")
}
