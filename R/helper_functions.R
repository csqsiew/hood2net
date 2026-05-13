#' To check if edit_size is a whole number or not. Internal function used by `make_network()` and `make_network_sep()`.
#'
#' @returns TRUE oR FALSE.
#' @keywords internal
#'
is.wholenumber <-
  function(x, tol = .Machine$double.eps^0.5)  abs(x - round(x)) < tol
