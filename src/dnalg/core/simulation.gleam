import dnalg/core/sequence

pub type Simulation {
  GGASimulation(
    origin: sequence.DnaSequence,
    fragments: List(String),
    sticky_ends: List(#(String, String)),
  )
}

// Reverse Complements:
//
// 1: aaatagcgaaaacccgcgaggtcgccgccc
// 2: cggaaacgccttaaaccggaaaattttcat
//
//                                   | This is to say that sticky_ends[0] =
//                                   | sticky_ends[1].0
//                                   L___
// GGGGgggcggcgacctcgcgggttttcgctatttAAAA
//                                   TTTTcggaaacgccttaaaccggaaaattttcatCCCC
//
// So, if we assess each overlap as a bool in the array, we can assume that [0]
// and [n] are True. This is because they don't have to overlap with anything.
// - The element should be present though, as an automatic True value, so we
// don't have to handle the edge cases in the end. We can also add this array
// into the Simulation type, so we don't calculate it in processing.

pub const gga_sim_example = GGASimulation(
  origin: sequence.sample,
  fragments: [
    "gggcggcgacctcgcgggttttcgctattt", "atgaaaattttccggtttaaggcgtttccg",
    "gggcggcgacctcgcgggttttcgctattt", "atgaaaattttccggtttaaggcgtttccg",
  ],
  sticky_ends: [
    #("gggg", "tctt"),
    #("aaaa", "cccc"),
    #("acac", "cacc"),
    #("gtgg", "ccca"),
  ],
)
// NOTE: Order of operations
// - Check if there are two sites that face each other
//  - Leftmost site points right, rightmost site point left. OR, the opposite.
// - Need to check if the cut goes over the index break (end through to the
//   beginning of the plasmid)
//  - If yes, rotate 90 degrees? Binary until they are all on the same side?
//    Need to figure this out.
// - Simulate the cuts at the indices, and remove the sticky ends.
// - Construct GGASimulation and return it
