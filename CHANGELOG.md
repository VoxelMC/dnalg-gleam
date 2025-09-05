# Changelog

## 0.2.0

### CLI

-   Renamed `silent-mutate` to `clean`
-   Added the `count` command.[^1] This command counts the number of restriction sites within a provided sequence.
    _note: this does not consider CDS like `clean` does. It assesses the whole sequence._
-   Added the `calts` command.[^1] This command prints alternate codons for a provided codon.
-   Added new second-level subcommands for commands which do not return sequences:
    -   `list` - Any actions which return information about the object being queried. E.g. alternates for a codon.
    -   `parse` - Any actions to check the result of parsing an expression or formatted string. E.g. restriction strings/presets.
    -   `count` - Any actions which return a number, or some form of count.

### API Additions

-   Added the `core/restriction` module for parsing and producing restriction sites.
-   Added the `actions/presets` module for parsing presets.

### Signature changes

-   `sequence.raw` >>> `sequence.unwrap`
-   Module `commands/restriction` >>> `commands/restriction_mutate`

[^1]: Usage can be found in the package `README.md` or in the `--help` menu of the CLI.
