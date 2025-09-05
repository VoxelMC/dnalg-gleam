# General Reference

-   [Restriction Site Formatting](#restriction-site-formatting)

## Restriction Site Formatting

Restriction sites are parsed using the following rules:

-   `AGCT` characters are read into the consensus sequence and validated;
-   `N` characters are ignored;
-   `^` characters signify the cute site;
-   All other characters are ignored.

So, parsing a restriction string such as these: `ACGT^CG` and `ACGTCGN^NN` will yield:

```
ACGT^CG         recognition: ACGTCG
                length: 6
                cut_index: 4 (cuts 4 bases after the first base of the recognition site)

ACGTCGN^NN      recognition: ACGTCG
                length: 6
                cut_index: 7
```

Quite simple!
