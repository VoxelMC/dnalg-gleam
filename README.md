# dnalg

DNAlg is a DNA sequence manipulation library. This is my implementation in Gleam.

> For a more portable version of this project, I will rewrite it in Go whenever I choose to learn Go.

## Plans

-   Restriction enzyme operations such as
    -   Simulated digestion
    -   Counting cut sites
    -   Silent mutation of cut sites

## Usage

To use `dnalg`, run it in the command line.
The easiest way to use it is by piping in a DNA sequence and pipe the output to a file.

You can also use the -i flag to specify an input file and the -o flag to specify an output file.

```sh
cat input.txt > dnalg [subcommand] > output.txt
```

The input can be a text file, or in FASTA format. I will look at adding support for `.dna` and `.gb` files in the future.

### Subcommands

#### `silent-mutate`

`silent-mutate` will silently mutate any restriction sites within the provided DNA sequence.

-   Sends the new DNA sequence to stdout.

```sh
dnalg silent-mutate [-r|--restriction string]
```

## Roadmap

You can find the roadmap for this project here: [ROADMAP.md](ROADMAP.md)

## Contributing

### Running the project

```sh
gleam run   # Run the project
gleam test  # Run the tests
```

### Adding functionality

-   Use the built-in `cli/` module to add subcommands to the CLI command (when it is complete);
-   Add new modules according to the flow outlines in the next section.

### Module management

Module structure is as follows:

-   `core/` is for primitives and shared functionality;
-   `actions/` are abstractions for core for use in commands;
-   `commands/` are primary functions which run via the CLI.

This is done to keep the code clean and avoid circular dependencies.
Try to have modules in `actions/` only import from `core/` and `commands/`
only import from `core/` or `actions/` where possible.

---

All rights reserved. © 2024, Trevor Fox
