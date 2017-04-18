#' Batchtools futures for custom batchtools configuration
#'
#' @inheritParams BatchtoolsFuture
#'
#' @param cluster.functions A
#' \link[batchtools:ClusterFunctions]{ClusterFunctions} object.
#'
#' @param resources A named list passed to the batchtools template (available
#' as variable \code{resources}).
#'
#' @param \ldots Additional arguments passed to
#' \code{\link{BatchtoolsFuture}()}.
#'
#' @return An object of class \code{BatchtoolsFuture}.
#'
#' @export
#' @importFrom utils file_test
batchtools_custom <- function(expr, envir = parent.frame(), substitute = TRUE,
                              globals = TRUE, label = "batchtools",
                              cluster.functions,
                              resources = list(), workers = NULL, ...) {
  if (substitute) expr <- substitute(expr)
  stopifnot(inherits(cluster.functions, "ClusterFunctions"))

  future <- BatchtoolsFuture(expr = expr, envir = envir, substitute = FALSE,
                            globals = globals,
			    label = label,
                            cluster.functions = cluster.functions,
			    resources = resources,
                            workers = workers,
			    ...)

  if (!future$lazy) future <- run(future)

  future
}
class(batchtools_custom) <- c("batchtools_custom", "batchtools",
                              "multiprocess", "future", "function")
