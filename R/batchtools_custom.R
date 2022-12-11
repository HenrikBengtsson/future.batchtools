#' Batchtools futures for custom batchtools configuration
#'
#' @inheritParams BatchtoolsFuture
#'
#' @param conf.file (character) A batchtools configuration file as for
#' instance returned by [batchtools::findConfFile()].
#'
#' @param cluster.functions A
#' [ClusterFunctions][batchtools::ClusterFunctions] object.
#'
#' @param \ldots Additional arguments passed to [BatchtoolsFuture()].
#'
#' @return An object of class `BatchtoolsFuture`.
#'
#' @example incl/batchtools_custom.R
#'
#' @export
#' @importFrom batchtools findConfFile
#' @importFrom utils file_test
batchtools_custom <- function(expr, envir = parent.frame(), substitute = TRUE,
                              globals = TRUE,
                              label = NULL,
                              resources = list(),
                              workers = NULL,
                              conf.file = findConfFile(),
                              cluster.functions = NULL,
                              registry = list(),
                              ...) {
  if (substitute) expr <- substitute(expr)

  future <- BatchtoolsCustomFuture(
    expr = expr, envir = envir, substitute = FALSE,
    globals = globals,
    label = label,
    resources = resources,
    conf.file = conf.file,
    cluster.functions = cluster.functions,
    workers = workers,
    registry = registry,
    ...
  )

  if (!future$lazy) future <- run(future)

  future
}
class(batchtools_custom) <- c(
  "batchtools_custom", "batchtools_multiprocess", "batchtools",
  "multiprocess", "future", "function"
)
attr(batchtools_custom, "tweakable") <- c("finalize")
