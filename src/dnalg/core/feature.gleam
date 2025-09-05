pub type Feature {
  Feature(start: Int, end: Int, label: String, kind: FeatureKind)
  ComplementFeature(start: Int, end: Int, label: String, kind: FeatureKind)
}

pub type FeatureKind {
  Source
  CDS(translation: String)
  Gene
}
