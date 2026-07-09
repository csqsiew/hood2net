# Create a language network from a list of items. This version takes each single character as an individual segment when specifying neighbors.

Create a language network from a list of items. This version takes each
single character as an individual segment when specifying neighbors.

## Usage

``` r
make_network(
  item_df,
  neighbor_type = "lv",
  network_name = "test",
  edit_size = 1
)
```

## Arguments

- item_df:

  A data frame containing the list of items and other node-level
  attributes that are appended to the network (optional). Must minimally
  contain one character class column labeled "item".

- neighbor_type:

  A string indicating neighbor type: "lv" (default) is 1-edit neighbors
  by substitution, deletion, or addition; "osa" is 1-edit neighbors by
  substitution, deletion, addition, or transposition; "hamming" is
  1-edit neighbors by substitution only.

- network_name:

  A string, the name of the network. Becomes a network-level attribute.

- edit_size:

  An integer that indicates the maximum edit distance allowed between
  word pairs that are connected in the network. Default value is 1.

## Value

An `igraph` network object.

## Examples

``` r
# Use the demo data for executing examples

  g <- make_network(item_df = sample1) # substitution, addition, deletion
#>   |                                                                              |                                                                      |   0%  |                                                                              |========                                                              |  11%  |                                                                              |================                                                      |  22%  |                                                                              |=======================                                               |  33%  |                                                                              |===============================                                       |  44%  |                                                                              |=======================================                               |  56%  |                                                                              |===============================================                       |  67%  |                                                                              |======================================================                |  78%  |                                                                              |==============================================================        |  89%
  summary(g)
#> IGRAPH 3ed2da3 UN-- 9 9 -- test
#> + attr: name (g/c), name (v/c), length (v/n)

  g_sub <- make_network(item_df = sample1, neighbor_type = 'hamming') # substitution only
#>   |                                                                              |                                                                      |   0%  |                                                                              |========                                                              |  11%  |                                                                              |================                                                      |  22%  |                                                                              |=======================                                               |  33%  |                                                                              |===============================                                       |  44%  |                                                                              |=======================================                               |  56%  |                                                                              |===============================================                       |  67%  |                                                                              |======================================================                |  78%  |                                                                              |==============================================================        |  89%
  summary(g_sub)
#> IGRAPH 1066d16 UN-- 9 5 -- test
#> + attr: name (g/c), name (v/c), length (v/n)
```
