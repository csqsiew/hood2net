# Convert an adjacency list of neighborhoods into an igraph network object. Internal function used by `make_network()` and `make_network_sep()`.

Convert an adjacency list of neighborhoods into an igraph network
object. Internal function used by
[`make_network()`](https://csqsiew.github.io/hood2net/reference/make_network.md)
and
[`make_network_sep()`](https://csqsiew.github.io/hood2net/reference/make_network_sep.md).

## Usage

``` r
adj_list_to_graph(adj_list, network_name, item_df)
```

## Arguments

- adj_list:

  A list object. An adjacency list of neighborhoods.

- network_name:

  A string, the name of the network. Becomes a network-level attribute.

- item_df:

  A data frame containing node-level attributes that are appended to the
  network.

## Value

An igraph network object.

## Examples

``` r
if (FALSE) { # \dontrun{
  # buf is the list object containing the item neighborhoods, the output of
  # various string computation functions.
  # the other arguments are inherited from make_network()

  adj_list_to_graph(adj_list = buf, network_name = network_name, item_df = item_df)
} # }
```
