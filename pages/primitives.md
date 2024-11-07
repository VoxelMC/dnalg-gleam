# DNAlg Primitives

Within `core/` are the primitives that DNAlg uses for all actions.

## Current Primitives

### Codon

A codon is a type which stores a string representation of a codon.
These can be created and validated using the `core/codon` module.

### Amino Acid

This is simply a type which corresponds to each possible canonical, proteinogenic, amino acid.

These can be created using the `core/residue` module. However, this type is mostly internal, unless you are matching
a pattern upon them.

### Residue

A residue is a type which stores an Amino Acid, its codon, its letter representation, and its alternate codons.

These can be created using the `core/residue` module.

### Sequence

A sequence is a type which stores a string representation of a sequence.
These can be created and validated using the `core/sequence` module.

Note that individual bases (A, C, G, and T) are not their own primitive. This is because they are already represented
in DNAlg as strings (`"A"`, `"C"`, `"G"`, and `"T"`).

## What is `core/tools`?

This is a module which shares functionality between every module. It must not import any other module,
thus it can only use the Gleam standard library. To use this module, you must import it in your module and
perform conversions on your data to the types that `core/tools` expects.
