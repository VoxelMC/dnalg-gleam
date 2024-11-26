# Changelog

## 0.2.0

-   Renamed `silent-mutate` to `clean`
-   Added the `count` command.[^1] This command counts the number of restriction sites within a provided sequence.
    *note: this does not consider CDS like `clean` does. It assesses the whole sequence.*
-   Added the `calts` command.[^1] This command prints alternate codons for a provided codon.

[^1]: Usage can be found in the package `README.md` or in the `--help` menu of the CLI.
