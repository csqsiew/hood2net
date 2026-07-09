#' Create a language network from a list of items. This version segments items based on a specified separator when specifying neighbors.
#'
#' @param item_df A data frame containing the list of items and other node-level attributes that are appended to the network (optional). Must minimally contain one character class column labeled "item".
#' @param separator A single character. The default is '.'. This is used to segment items into sub-units to base the neighborhood computation on.
#' @param neighbor_type A string indicating neighbor type: "lv" (default) is 1-edit neighbors by substitution, deletion, or addition; "hamming" is 1-edit neighbors by substitution only.
#' @param network_name A string, the name of the network. Becomes a network-level attribute.
#' @param edit_size An integer that indicates the maximum edit distance allowed between word pairs that are connected in the network. Default value is 1.
#'
#' @returns An `igraph` network object.
#' @export
#'
#' @examples
#' #' # Use the demo data for executing examples
#'
#'   g_sep <- make_network_sep(item_df = sample2) # substitution, addition, deletion
#'   summary(g_sep)
#'
#'   # substitution only
#'   g_sep_sub <- make_network_sep(item_df = sample2, neighbor_type = 'hamming')
#'   summary(g_sep_sub)
#'
#' @importFrom utils setTxtProgressBar txtProgressBar
#' @importFrom Rcpp sourceCpp
#' @useDynLib hood2net, .registration = TRUE
make_network_sep <- function(item_df, separator = '.', neighbor_type = 'lv', network_name = 'test', edit_size = 1) {

  # sanity checks
  # neighbor_type
  if(!neighbor_type %in% c('lv', 'hamming')) {
    stop('Message: neighbor_type not correctly specified, see documentation.')
  }

  # separator
  if(!is.character(separator)|nchar(separator) != 1) {
    stop('Message: the separator should be a single character.')
  }

  # item_df
  if(!is.data.frame(item_df)) {
    stop('Message: item_df is not a data frame.')
  }

  # network_name
  if(!is.character(network_name)) {
    stop('Message: network_name is not a character type.')
  }

  # edit_size
  if(!is.wholenumber(edit_size) | edit_size == 0 | edit_size < 0) {
    stop('Message: edit_size must be a whole number greater than or equal to 1')
  }

  # data frame must contain at least one column named "item"
  if(!"item" %in% colnames(item_df)) {
    stop('Message: there is no column named "item" in item_df.')
  }

  # the class of the "item" column must be character
  if(!is.character(class(item_df$item))) {
    stop('Message: the "item" column in item_df is not a character class.')
  }

  n <- nrow(item_df)
  items <- item_df$item

  edge_capacity <- min(n * 10L, 2000000L)
  edge_from <- integer(edge_capacity)
  edge_to   <- integer(edge_capacity)
  edge_count <- 0L

  pb <- txtProgressBar(min = 0, max = n, style = 3)

  if(neighbor_type == 'lv') { # SAD

  for (i in 1:(n - 1)) {

    setTxtProgressBar(pb, i)

    candidates <- items[(i + 1):n]
    dists <- sepLeven_C(item_df$item[i], candidates, sep = separator) # different from make_network using sepLeven_C
    hits <- which(dists <= edit_size & dists > 0) + i

    if (length(hits) > 0) {
      new_count <- edge_count + length(hits)

      if (new_count > edge_capacity) {
        edge_capacity <- max(new_count, edge_capacity * 2L)
        length(edge_from) <- edge_capacity
        length(edge_to)   <- edge_capacity
      }

      edge_from[(edge_count + 1):new_count] <- i
      edge_to[(edge_count + 1):new_count]   <- hits
      edge_count <- new_count
    }
  }

  }

  if(neighbor_type == 'hamming') { # SUB ONLY

    for (i in 1:(n - 1)) {

      setTxtProgressBar(pb, i)

      candidates <- items[(i + 1):n]
      dists <- sepSub_C(item_df$item[i], candidates, sep = separator) # use sepSub_C instead
      hits <- which(dists <= edit_size & dists > 0) + i

      if (length(hits) > 0) {
        new_count <- edge_count + length(hits)

        if (new_count > edge_capacity) {
          edge_capacity <- max(new_count, edge_capacity * 2L)
          length(edge_from) <- edge_capacity
          length(edge_to)   <- edge_capacity
        }

        edge_from[(edge_count + 1):new_count] <- i
        edge_to[(edge_count + 1):new_count]   <- hits
        edge_count <- new_count
      }
    }

  }

  close(pb)

  edge_from <- edge_from[1:edge_count]
  edge_to   <- edge_to[1:edge_count]

  g <- igraph::make_empty_graph(n = n, directed = FALSE)
  igraph::V(g)$name <- items

  g <- igraph::add_edges(g, c(rbind(edge_from, edge_to)))

  for (col in setdiff(colnames(item_df), "item")) {
    g <- igraph::set_vertex_attr(g, col, value = item_df[[col]])
  }

  g <- igraph::set_graph_attr(g, "name", network_name)

  g

}
