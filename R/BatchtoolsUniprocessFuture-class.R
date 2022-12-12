#' @rdname BatchtoolsFuture
#' @export
BatchtoolsUniprocessFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), ...) {
  if (substitute) expr <- substitute(expr)
  assert_no_positional_args_but_first()

  future <- BatchtoolsFuture(expr = expr, substitute = FALSE, envir = envir, ..., workers = 1L)
  future <- structure(future, class = c("BatchtoolsUniprocessFuture", class(future)))
  
  future
}


#' @rdname BatchtoolsFuture
#' @export
BatchtoolsLocalFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), ...) {
  if (substitute) expr <- substitute(expr)
  assert_no_positional_args_but_first()

  future <- BatchtoolsUniprocessFuture(expr = expr, substitute = FALSE, envir = envir, ...)
  future <- structure(future, class = c("BatchtoolsLocalFuture", class(future)))
  
  future
}


#' @rdname BatchtoolsFuture
#' @export
BatchtoolsInteractiveFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), ...) {
  if (substitute) expr <- substitute(expr)
  assert_no_positional_args_but_first()

  future <- BatchtoolsUniprocessFuture(expr = expr, substitute = FALSE, envir = envir, ...)
  future <- structure(future, class = c("BatchtoolsInteractiveFuture", class(future)))
  
  future
}
