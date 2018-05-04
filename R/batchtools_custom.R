#' Batchtools futures for custom batchtools configuration
#'
#' @inheritParams BatchtoolsFuture
#'
#' @param cluster.functions A
#' [ClusterFunctions][batchtools::ClusterFunctions] object.
#'
#' @param resources A named list passed to the batchtools template
#' (available as variable `resources`).
#'
#' @param \ldots Additional arguments passed to [BatchtoolsFuture()].
#'
#' @return An object of class `BatchtoolsFuture`.
#'
#' @export
#' @importFrom utils file_test
batchtools_custom <- function(expr, envir = parent.frame(), substitute = TRUE,
                              globals = TRUE, label = NULL,
                              cluster.functions,
                              resources = list(), workers = NULL, ...) {
  if (substitute) expr <- substitute(expr)
  stop_if_not(inherits(cluster.functions, "ClusterFunctions"))

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
