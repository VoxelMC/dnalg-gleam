import dnalg/core/restriction
import gleam/string

pub fn restriction_enzyme(name: String) {
  case name |> string.lowercase() |> string.replace(" ", "") {
    "bsai" <> _ -> "GAAGACN^NNNNN" |> restriction.from_string()
    n -> Error(restriction.PresetNotExists(n))
  }
}
