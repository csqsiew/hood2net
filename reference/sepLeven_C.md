# Helper function to compute edit distance between two strings using the `vecLeven_C` function, which is written in C to optimize performance. This is the substitution, deletion, or addition version.

Helper function to compute edit distance between two strings using the
`vecLeven_C` function, which is written in C to optimize performance.
This is the substitution, deletion, or addition version.

## Usage

``` r
sepLeven_C(s, t, sep = ".")
```

## Arguments

- s:

  A string.

- t:

  A character vector.

- sep:

  A character separator by which `s` and `t` are segmented by.

## Value

A numeric element indicating the edit distance of the target string to
all other strings.

## Examples

``` r

sepLeven_C("spin.ach", c("spin.ner", "spi.ner", "spin.ach.er"))
#> [1] 1 2 1
```
