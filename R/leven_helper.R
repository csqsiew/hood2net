# these are the top level functions that use vecX

#' Helper function to compute edit distance between two strings using the `vecLeven_C` function, which is written in C to optimize performance. This is the substitution, deletion, or addition version.
#'
#' @param s A string.
#' @param t A character vector.
#' @param sep A character separator by which `s` and `t` are segmented by.
#'
#' @returns A numeric element indicating the edit distance of the target string to all other strings.
#'
#' @examples
#'
#' sepLeven_C("spin.ach", c("spin.ner", "spi.ner", "spin.ach.er"))
#' @importFrom Rcpp sourceCpp
#' @useDynLib hood2net, .registration = TRUE
sepLeven_C <- function(s, t, sep=".") {
  mapply(vecLeven_C, ### use the C vers.
         strsplit(s, sep, fixed=TRUE),
         strsplit(t, sep, fixed=TRUE))
}

#' Helper function to compute edit distance between two strings using the `vecSub_C` function, which is written in C to optimize performance. This is the substitution only version.
#'
#' @param s A string.
#' @param t A character vector.
#' @param sep A character separator by which `s` and `t` are segmented by.
#'
#' @returns A numeric element indicating the edit distance of the target string to all other strings.
#'
#' @examples
#'
#' sepSub_C("spin.ach", c("spin.ner", "spi.ner", "spin.ach.er"))
#' @importFrom Rcpp sourceCpp
#' @useDynLib hood2net, .registration = TRUE
sepSub_C <- function(s, t, sep=".") {
  mapply(vecSub_C, ### use the C vers.
         strsplit(s, sep, fixed=TRUE),
         strsplit(t, sep, fixed=TRUE))
}
