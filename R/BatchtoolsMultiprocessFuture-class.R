#' @rdname BatchtoolsFuture
#' @export
BatchtoolsMultiprocessFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), ...) {
  if (substitute) expr <- substitute(expr)

  future <- BatchtoolsFuture(expr = expr, substitute = FALSE, envir = envir, ...)
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


#' @rdname BatchtoolsFuture
#' @export
BatchtoolsTemplateFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), ...) {
  if (substitute) expr <- substitute(expr)

  future <- BatchtoolsMultiprocessFuture(expr = expr, substitute = FALSE, envir = envir, ...)
  future <- structure(future, class = c("BatchtoolsTemplateFuture", class(future)))
  
  future
}


#' @rdname BatchtoolsFuture
#' @export
BatchtoolsLsfFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), ...) {
  if (substitute) expr <- substitute(expr)

  future <- BatchtoolsMultiprocessFuture(expr = expr, substitute = FALSE, envir = envir, ...)
  future <- structure(future, class = c("BatchtoolsLsfFuture", class(future)))
  
  future
}


#' @rdname BatchtoolsFuture
#' @export
BatchtoolsOpenLavaFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), ...) {
  if (substitute) expr <- substitute(expr)

  future <- BatchtoolsMultiprocessFuture(expr = expr, substitute = FALSE, envir = envir, ...)
  future <- structure(future, class = c("BatchtoolsOpenLavaFuture", class(future)))
  
  future
}


#' @rdname BatchtoolsFuture
#' @export
BatchtoolsSGEFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), ...) {
  if (substitute) expr <- substitute(expr)

  future <- BatchtoolsMultiprocessFuture(expr = expr, substitute = FALSE, envir = envir, ...)
  future <- structure(future, class = c("BatchtoolsSGEFuture", class(future)))
  
  future
}


#' @rdname BatchtoolsFuture
#' @export
BatchtoolsSlurmFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), ...) {
  if (substitute) expr <- substitute(expr)

  future <- BatchtoolsMultiprocessFuture(expr = expr, substitute = FALSE, envir = envir, ...)
  future <- structure(future, class = c("BatchtoolsSlurmFuture", class(future)))
  
  future
}


#' @rdname BatchtoolsFuture
#' @export
BatchtoolsTorqueFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), ...) {
  if (substitute) expr <- substitute(expr)

  future <- BatchtoolsMultiprocessFuture(expr = expr, substitute = FALSE, envir = envir, ...)
  future <- structure(future, class = c("BatchtoolsTorqueFuture", class(future)))
  
  future
}
