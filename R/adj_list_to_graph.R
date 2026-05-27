#' Convert an adjacency list of neighborhoods into an igraph network object. Internal function used by `make_network()` and `make_network_sep()`.
#'
#' @param adj_list A list object. An adjacency list of neighborhoods.
#' @param network_name A string, the name of the network. Becomes a network-level attribute.
#' @param item_df A data frame containing node-level attributes that are appended to the network.
#'
#' @returns An igraph network object.
#' @keywords internal
#'
adj_list_to_graph <- function(adj_list, network_name, item_df) {

  g <- igraph::graph_from_adj_list(adj_list, mode = 'all') # convert the adjacency list into a network object

  igraph::V(g)$name <- paste0(1:nrow(item_df), "_", item_df$item) # meaningful node names (merge the transcription with a numeric id)

  for(i in 1:length(colnames(item_df))) { # to add other columns in the dataframe as node attributes, minimally, 'item' column which is the transcription itself
    g <- igraph::set_vertex_attr(g, name = colnames(item_df)[i], value = item_df[,i])
  }

  g$name <- network_name # network name to label the network

  saveRDS(g, file = paste0(network_name, '.rds')) # save network object externally

  return(g)

}
