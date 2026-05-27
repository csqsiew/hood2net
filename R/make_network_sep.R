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

  buf <- list() # buffer to store results

  pb <- txtProgressBar(min = 0, max = nrow(item_df), style = 3) # progress bar only works for normal lapply

  if(neighbor_type == 'lv') { # SAD
    buf <- lapply(1:nrow(item_df), function(i) { # for each word in the item_df$item

      setTxtProgressBar(pb, i) # this must be placed BEFORE the main computation

      which(sepLeven_C(item_df$item[i], item_df$item, sep = separator) < edit_size+1 & sepLeven_C(item_df$item[i], item_df$item, sep = separator) > 0)

  })
  }

  if(neighbor_type == 'hamming') { # SUB ONLY
    buf <- lapply(1:nrow(item_df), function(i) { # for each word in the item_df$item

      setTxtProgressBar(pb, i) # this must be placed BEFORE the main computation

      which(sepSub_C(item_df$item[i], item_df$item, sep = separator) < edit_size+1 & sepSub_C(item_df$item[i], item_df$item, sep = separator) > 0)

  })
  }

  adj_list_to_graph(adj_list = buf, network_name = network_name, item_df = item_df)

}
