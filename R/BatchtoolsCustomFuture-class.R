#' @rdname BatchtoolsFuture
#' @export
BatchtoolsCustomFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), ...) {
  if (substitute) expr <- substitute(expr)
  assert_no_positional_args_but_first()
  
  future <- BatchtoolsFuture(expr = expr, substitute = FALSE, envir = envir, ...)
  future <- structure(future, class = c("BatchtoolsCustomFuture", class(future)))

  future
}



#' @rdname BatchtoolsFuture
#' @export
BatchtoolsBashFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), ...) {
  if (substitute) expr <- substitute(expr)
  assert_no_positional_args_but_first()

  future <- BatchtoolsCustomFuture(expr = expr, substitute = FALSE, envir = envir, ..., workers = 1L)
  future <- structure(future, class = c("BatchtoolsBashFuture", "BatchtoolsUniprocessFuture", class(future)))
  
  future
}
