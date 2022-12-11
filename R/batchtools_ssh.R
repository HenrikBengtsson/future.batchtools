#' batchtools SSH futures
#'
#' A batchtools SSH future is an asynchronous multiprocess
#' future that will be evaluated in a background R session.\cr
#' \cr
#' _We highly recommend using [future::multisession]
#' (sic!) futures of the \pkg{future} package instead of
#' SSH batchtools futures._
#'
#' @inheritParams BatchtoolsFuture
#'
#' @param workers The number of SSH processes to be
#' available for concurrent batchtools SSH futures.
#' @param \ldots Additional arguments passed
#' to [BatchtoolsFuture()].
#'
#' @return An object of class `BatchtoolsMulticoreFuture`.
#'
#' @details
#' batchtools SSH futures rely on the batchtools backend set
#' up by [batchtools::makeClusterFunctionsSSH()].
#' The batchtools SSH backend only works on operating systems
#' supporting the `ssh` and `ps` command-line tool, e.g. Linux and macOS.
#'
#' @importFrom parallelly availableWorkers
#'
#' @export
#' @keywords internal
batchtools_ssh <- function(expr, envir = parent.frame(),
                            substitute = TRUE, globals = TRUE,
                            label = NULL,
                            workers = availableWorkers(),
                            registry = list(), ...) {
  if (substitute) expr <- substitute(expr)

  future <- BatchtoolsSSHFuture(
    expr = expr, envir = envir, substitute = FALSE,
    globals = globals,
    label = label,
    workers = workers,
    registry = registry, 
    ...
  )

  if (!future$lazy) future <- run(future)

  future
}
class(batchtools_ssh) <- c(
  "batchtools_ssh", "batchtools_custom",
  "batchtools_multiprocess", "batchtools",
  "multiprocess", "future", "function"
)
attr(batchtools_multicore, "tweakable") <- c("finalize")
