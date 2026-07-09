#' Create a language network from a list of items. This version takes each single character as an individual segment when specifying neighbors.
#'
#' @param item_df A data frame containing the list of items and other node-level attributes that are appended to the network (optional). Must minimally contain one character class column labeled "item".
#' @param neighbor_type A string indicating neighbor type: "lv" (default) is 1-edit neighbors by substitution, deletion, or addition; "osa" is 1-edit neighbors by substitution, deletion, addition, or transposition; "hamming" is 1-edit neighbors by substitution only.
#' @param network_name A string, the name of the network. Becomes a network-level attribute.
#' @param edit_size An integer that indicates the maximum edit distance allowed between word pairs that are connected in the network. Default value is 1.
#'
#' @returns An `igraph` network object.
#' @export
#'
#' @examples
#' # Use the demo data for executing examples
#'
#'   g <- make_network(item_df = sample1) # substitution, addition, deletion
#'   summary(g)
#'
#'   g_sub <- make_network(item_df = sample1, neighbor_type = 'hamming') # substitution only
#'   summary(g_sub)
#'
#' @importFrom utils setTxtProgressBar txtProgressBar

make_network <- function(item_df, neighbor_type = 'lv', network_name = 'test', edit_size = 1) {

  # --- sanity checks (unchanged) ---
  if(!neighbor_type %in% c('lv', 'hamming', 'osa')) {
    stop('Message: neighbor_type not correctly specified, see documentation.')
  }
  if(!is.data.frame(item_df)) {
    stop('Message: item_df is not a data frame.')
  }
  if(!is.character(network_name)) {
    stop('Message: network_name is not a character type.')
  }
  if(!is.wholenumber(edit_size) | edit_size == 0 | edit_size < 0) {
    stop('Message: edit_size must be a whole number greater than or equal to 1')
  }
  if(!"item" %in% colnames(item_df)) {
    stop('Message: there is no column named "item" in item_df.')
  }
  if(!is.character(class(item_df$item))) {
    stop('Message: the "item" column in item_df is not a character class.')
  }

  n <- nrow(item_df)
  items <- item_df$item

  # set up pre-defined vectors to store edges efficiently
  edge_capacity <- min(n * 10L, 2000000L)
  edge_from <- integer(edge_capacity)
  edge_to   <- integer(edge_capacity)
  edge_count <- 0L

  pb <- txtProgressBar(min = 0, max = n, style = 3)

  # a key idea: no need to check neighbors for all items and for all other items
  # if in a list of 10 items
  # target 1 vs 9 (2-10) other items
  # target 2 vs 8 (3-10) other items (since 2 and 1 has been checked already)
  # ... target 9 vs 1 (10) is the last check
  # target 10 does not need to be checked at all

  for (i in 1:(n - 1)) {

    setTxtProgressBar(pb, i)

    candidates <- items[(i + 1):n]
    dists <- stringdist::stringdist(items[i], candidates, method = neighbor_type)
    hits <- which(dists <= edit_size & dists > 0) + i

    if (length(hits) > 0) {
      new_count <- edge_count + length(hits)

      if (new_count > edge_capacity) { # a quick check to see if the buffer needs to be increased
        edge_capacity <- max(new_count, edge_capacity * 2L)
        length(edge_from) <- edge_capacity
        length(edge_to)   <- edge_capacity
      }

      edge_from[(edge_count + 1):new_count] <- i
      edge_to[(edge_count + 1):new_count]   <- hits
      edge_count <- new_count
    }
  }

  close(pb)

  edge_from <- edge_from[1:edge_count]
  edge_to   <- edge_to[1:edge_count]

  # Assign item names as vertex 'name' attribute on creation
  g <- igraph::make_empty_graph(n = n, directed = FALSE)
  igraph::V(g)$name <- items

  g <- igraph::add_edges(g, c(rbind(edge_from, edge_to)))

  # Skip "item" column in the attribute loop since it is already captured as the vertex 'name' attribute above
  for (col in setdiff(colnames(item_df), "item")) {
    g <- igraph::set_vertex_attr(g, col, value = item_df[[col]])
  }

  g <- igraph::set_graph_attr(g, "name", network_name)

  g
}
