#' @rdname BatchtoolsFuture
#' @export
BatchtoolsMultiprocessFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), ...) {
  if (substitute) expr <- substitute(expr)

  future <- BatchtoolsFuture(expr = expr, substitute = FALSE, envir = envir, ..., workers = 1L)
  future <- structure(future, class = c("BatchtoolsMultiprocessFuture", class(future)))
  
  future
}


#' @rdname BatchtoolsFuture
#' @export
BatchtoolsMulticoreFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), ...) {
  if (substitute) expr <- substitute(expr)

  future <- BatchtoolsMultiprocessFuture(expr = expr, substitute = FALSE, envir = envir, ...)
  future <- structure(future, class = c("BatchtoolsMulticoreFuture", class(future)))
  
  future
}
