#' batchtools local and interactive futures
#'
#' A batchtools local future is an synchronous uniprocess future that
#' will be evaluated in a background R session.
#' A batchtools interactive future is an synchronous uniprocess future
#' that will be evaluated in the current R session (and variables will
#' be assigned to the calling environment rather than to a local one).
#' Both types of futures will block until the futures are resolved.
#'
#' @inheritParams BatchtoolsUniprocessFuture
#' 
#' @param \ldots Additional arguments passed to [BatchtoolsUniprocessFuture()].
#'
#' @return An object of class `BatchtoolsUniprocessFuture`.
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
#' `plan(sequential, split = TRUE)` futures of the \pkg{future} package.
#'
#' @example incl/batchtools_local.R
#'
#' @importFrom batchtools makeClusterFunctionsInteractive
#' @aliases batchtools_interactive batchtools_bash
#' @export
batchtools_local <- function(..., envir = parent.frame()) {
  cf <- makeClusterFunctionsInteractive(external = TRUE)
  future <- BatchtoolsLocalFuture(..., envir = envir, cluster.functions = cf)
  if (!future$lazy) future <- run(future)
  invisible(future)
}
class(batchtools_local) <- c(
  "batchtools_local", "batchtools_uniprocess", "batchtools",
  "uniprocess", "future", "function"
)
attr(batchtools_local, "tweakable") <- c("finalize")
attr(batchtools_local, "untweakable") <- c("workers")
