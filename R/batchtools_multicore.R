#' batchtools multicore futures
#'
#' A batchtools multicore future is an asynchronous multiprocess
#' future that will be evaluated in a background R session.\cr
#' \cr
#' \emph{We highly recommend using \code{\link[future]{multisession}}
#' (sic!) futures of the \pkg{future} package instead of
#' multicore batchtools futures.}
#'
#' @inheritParams BatchtoolsFuture
#' @param workers The number of multicore processes to be
#' available for concurrent batchtools multicore futures.
#' @param \ldots Additional arguments passed
#' to \code{\link{BatchtoolsFuture}()}.
#'
#' @return An object of class \code{BatchtoolsFuture}.
#'
#' @details
#' batchtools multicore futures rely on the batchtools backend set
#' up by \code{\link[batchtools]{makeClusterFunctionsMulticore}()}.
#' The batchtools multicore backend only works on operating systems
#' supporting the \code{ps} command-line tool, e.g. Linux and OS X.
#'
#' @importFrom batchtools makeClusterFunctionsMulticore
#' @importFrom future availableCores
#' @export
#' @keywords internal
batchtools_multicore <- function(expr, envir = parent.frame(),
                            substitute = TRUE, globals = TRUE,
                            label = NULL,
                            workers = availableCores(constraints = "multicore"),
                            ...) {
  if (substitute) expr <- substitute(expr)

  if (is.null(workers)) workers <- availableCores(constraints = "multicore")
  stop_if_not(length(workers) == 1L, is.numeric(workers),
            is.finite(workers), workers >= 1L)

  ## Fall back to batchtools_local if multicore processing is not supported
  if (workers == 1L || is_os("windows") || is_os("solaris") ||
      availableCores(constraints = "multicore") == 1L) {
    ## covr: skip=1
    return(batchtools_local(expr, envir = envir, substitute = FALSE,
                            globals = globals, label = label, ...))
  }

  oopts <- options(mc.cores = workers)
  on.exit(options(oopts))

  cf <- makeClusterFunctionsMulticore(ncpus = workers)

  future <- BatchtoolsFuture(expr = expr, envir = envir, substitute = FALSE,
                            globals = globals,
                            label = label,
                            cluster.functions = cf,
                            ...)

  if (!future$lazy) future <- run(future)

  future
}
class(batchtools_multicore) <- c("batchtools_multicore", "batchtools",
                                 "multiprocess", "future", "function")
