# dnalg

DNAlg is a DNA sequence manipulation library written in Gleam.

## Plans

- Restriction enzyme operations such as
    - Simulated digestion
    - Counting cut sites
    - Silent mutation of cut sites


## Usage

To use `dnalg`, run it in the command line. 
The easiest way to use it is by piping in a DNA sequence and pipe the output to a file.

You can also use the -i flag to specify an input file and the -o flag to specify an output file.

```sh
cat input.txt > dnalg > output.txt
```

The input can be a text file, or in FASTA format. I will look at adding support for `.dna` and `.gb` files in the future.

## Roadmap
You can find the roadmap for this project here: [ROADMAP.md](ROADMAP.md)

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
