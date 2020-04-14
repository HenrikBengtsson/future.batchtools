#' batchtools local and interactive futures
#'
#' A batchtools local future is an synchronous uniprocess future that
#' will be evaluated in a background R session.
#' A batchtools interactive future is an synchronous uniprocess future
#' that will be evaluated in the current R session (and variables will
#' be assigned to the calling environment rather than to a local one).
#' Both types of futures will block until the futures are resolved.
#'
#' @inheritParams BatchtoolsFuture
#' 
#' @param \ldots Additional arguments passed to [BatchtoolsFuture()].
#'
#' @return An object of class `BatchtoolsFuture`.
#'
#' @details
#' batchtools local futures rely on the batchtools backend set up by
#' \code{\link[batchtools:makeClusterFunctionsInteractive]{batchtools::makeClusterFunctionsInteractive(external = TRUE)}}
#' and batchtools interactive futures on the one set up by
#' [batchtools::makeClusterFunctionsInteractive()].
#' These are supported by all operating systems.
#'
#' An alternative to batchtools local futures is to use
#' [cluster][future::cluster] futures of the \pkg{future}
#' package with a single local background session, i.e.
#' `plan(cluster, workers = "localhost")`.
#'
#' An alternative to batchtools interactive futures is to use
#' [transparent][future::transparent] futures of the
#' \pkg{future} package.
#'
#' @example incl/batchtools_local.R
#'
#' @importFrom batchtools makeClusterFunctionsInteractive
#' @aliases batchtools_interactive
#' @export
batchtools_local <- function(expr, envir = parent.frame(), substitute = TRUE,
                             globals = TRUE, label = NULL,
                             workers = 1L, registry = list(), ...) {
  if (substitute) expr <- substitute(expr)

  cf <- makeClusterFunctionsInteractive(external = TRUE)

  future <- BatchtoolsFuture(expr = expr, envir = envir, substitute = FALSE,
                            globals = globals,
                            label = label,
                            workers = workers,
                            cluster.functions = cf,
                            registry = registry,
                            ...)

  if (!future$lazy) future <- run(future)

  future
}
class(batchtools_local) <- c("batchtools_local", "batchtools", "uniprocess",
                             "future", "function")
