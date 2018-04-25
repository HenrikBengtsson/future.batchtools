#' FutureError class for errors related to BatchtoolsFuture:s
#'
#' @param \ldots Arguments passed to [FutureError][future::FutureError].
#'
#' @export
#' @importFrom future FutureError
#'
#' @keywords internal
BatchtoolsFutureError <- function(...) {
  error <- FutureError(...)
  class(error) <- c("BatchtoolsFutureError", class(error))
  error
}
