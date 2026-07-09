# Create a language network from a list of items. This version segments items based on a specified separator when specifying neighbors.

Create a language network from a list of items. This version segments
items based on a specified separator when specifying neighbors.

## Usage

``` r
make_network_sep(
  item_df,
  separator = ".",
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

- separator:

  A single character. The default is '.'. This is used to segment items
  into sub-units to base the neighborhood computation on.

- neighbor_type:

  A string indicating neighbor type: "lv" (default) is 1-edit neighbors
  by substitution, deletion, or addition; "hamming" is 1-edit neighbors
  by substitution only.

- network_name:

  A string, the name of the network. Becomes a network-level attribute.

- edit_size:

  An integer that indicates the maximum edit distance allowed between
  word pairs that are connected in the network. Default value is 1.

## Value

An `igraph` network object.

## Examples

``` r
#' # Use the demo data for executing examples

  g_sep <- make_network_sep(item_df = sample2) # substitution, addition, deletion
#>   |                                                                              |                                                                      |   0%  |                                                                              |========                                                              |  11%  |                                                                              |================                                                      |  22%  |                                                                              |=======================                                               |  33%  |                                                                              |===============================                                       |  44%  |                                                                              |=======================================                               |  56%  |                                                                              |===============================================                       |  67%  |                                                                              |======================================================                |  78%  |                                                                              |==============================================================        |  89%
  summary(g_sep)
#> IGRAPH 8fb1711 UN-- 9 9 -- test
#> + attr: name (g/c), name (v/c), length (v/n)

  # substitution only
  g_sep_sub <- make_network_sep(item_df = sample2, neighbor_type = 'hamming')
#>   |                                                                              |                                                                      |   0%  |                                                                              |========                                                              |  11%  |                                                                              |================                                                      |  22%  |                                                                              |=======================                                               |  33%  |                                                                              |===============================                                       |  44%  |                                                                              |=======================================                               |  56%  |                                                                              |===============================================                       |  67%  |                                                                              |======================================================                |  78%  |                                                                              |==============================================================        |  89%
  summary(g_sep_sub)
#> IGRAPH 0a4fed3 UN-- 9 5 -- test
#> + attr: name (g/c), name (v/c), length (v/n)
```
