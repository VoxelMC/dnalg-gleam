pub type SequenceIndex {
  SequenceIndex(Int)
}

pub type SequenceRange {
  SequenceRange(start: Int, end: Int)
}

pub type TranslationIndex {
  TranslationIndex(Int)
}

pub type TranslationRange {
  TranslationRange(start: Int, end: Int)
}

fn calc_trans_from_seq(x) {
  let b = x % 3
  let c = x - b
  { c + 1 } / 3
}

/// Translate a sequence index into a translation index.
pub fn into_trans(index: SequenceIndex) {
  let SequenceIndex(x) = index
  TranslationIndex(calc_trans_from_seq(x))
}

/// Translate a sequence range into a translation range.
pub fn into_trans_range(range: SequenceRange) {
  let SequenceRange(s, e) = range
  TranslationRange(calc_trans_from_seq(s), calc_trans_from_seq(e))
}

/// This is lossy. It will not return the exact range, but the range of indexes
/// at the *first base of the codon*.
pub fn into_seq(index: TranslationIndex) {
  let TranslationIndex(x) = index
  SequenceIndex(x * 3)
}

/// This is lossy. It will not return the exact range, but the range of indexes
/// at the *first base of each codon*.
pub fn into_seq_range(range: TranslationRange) {
  let TranslationRange(s, e) = range
  SequenceRange(s * 3, e * 3)
}
