# DNAlg Roadmap

This file can be used to track my progress.
When I complete something, I will timestamp it so you can see if I am still working hard on this project.

## Checklists

### Digestion Analysis - Restriction Enzymes - Construct Assembly

-   [ ] API for restriction site analysis
    -   [ ] Be able to parse restriction sites from a specific format (link to docs later)
    -   [ ] Count # of restriction sites in sequence
    -   [ ] Perform digestion simulation
    -   [ ] Analyse sticky ends
    -   [ ] Perform Golden Gate Assembly simulation
        -   [ ] Graphical simulation
        -   [ ] Actual processing to output
    -   [ ] Have a standard library of common restriction enzymes for synthetic biology standards (MoClo, BioBrick, etc.)
        -   [ ] User-customizable list of restriction enzymes
-   [x] Create the sequence silent mutator to get rid of enzyme cut sites.
    -   [x] Make it get rid of every site, not just the first

### Logs

-   [ ] Use a sqlite db to record past jobs (`dnalg jobs`)
    -   [ ] `clear` subcommand with the ability to choose number to remove from the head (`dnalg jobs --clear [INT]`)

### Parsing Files

-   [x] Parse FASTA and GenBank files
-   [ ] Parse .dna files (SnapGene)
