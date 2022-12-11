#' batchtools multicore futures
#'
#' A batchtools multicore future is an asynchronous multiprocess
#' future that will be evaluated in a background R session.\cr
#' \cr
#' _We highly recommend using [future::multisession]
#' (sic!) futures of the \pkg{future} package instead of
#' multicore batchtools futures._
#'
#' @inheritParams BatchtoolsFuture
#'
#' @param workers The number of multicore processes to be
#' available for concurrent batchtools multicore futures.
#' @param \ldots Additional arguments passed
#' to [BatchtoolsFuture()].
#'
#' @return An object of class `BatchtoolsMulticoreFuture`.
#'
#' @details
#' batchtools multicore futures rely on the batchtools backend set
#' up by [batchtools::makeClusterFunctionsMulticore()].
#' The batchtools multicore backend only works on operating systems
#' supporting the `ps` command-line tool, e.g. Linux and macOS.
#'
#' @importFrom batchtools makeClusterFunctionsMulticore
#' @importFrom parallelly availableCores
#' @export
#' @keywords internal
batchtools_multicore <- function(expr, envir = parent.frame(),
                            substitute = TRUE, globals = TRUE,
                            label = NULL,
                            workers = availableCores(constraints = "multicore"),
                            registry = list(), ...) {
  if (substitute) expr <- substitute(expr)

  if (is.null(workers)) workers <- availableCores(constraints = "multicore")
  stop_if_not(length(workers) == 1L, is.numeric(workers),
            is.finite(workers), workers >= 1L)

  ## Fall back to batchtools_local if multicore processing is not supported
  if (workers == 1L || is_os("windows") || is_os("solaris") ||
      availableCores(constraints = "multicore") == 1L) {
    ## covr: skip=1
    return(batchtools_local(expr, envir = envir, substitute = FALSE,
                            globals = globals, label = label,
                            registry = registry, ...))
  }

  oopts <- options(mc.cores = workers)
  on.exit(options(oopts))

  cf <- makeClusterFunctionsMulticore(ncpus = workers)

  future <- BatchtoolsMulticoreFuture(
    expr = expr, envir = envir, substitute = FALSE,
    globals = globals,
    label = label,
    cluster.functions = cf,
    registry = registry, 
    ...
  )

  if (!future$lazy) future <- run(future)

  invisible(future)
}
class(batchtools_multicore) <- c(
  "batchtools_multicore", "batchtools_multiprocess", "batchtools",
  "multiprocess", "future", "function"
)
attr(batchtools_multicore, "tweakable") <- c("finalize")
