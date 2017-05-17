#' @inheritParams BatchtoolsFuture
#'
#' @importFrom batchtools makeClusterFunctionsInteractive
#' @export
batchtools_interactive <- function(expr, envir = parent.frame(),
                                   substitute = TRUE, globals = TRUE,
                                   label = "batchtools", workers = 1L, ...) {
  if (substitute) expr <- substitute(expr)

  cf <- makeClusterFunctionsInteractive(external = FALSE)

  future <- BatchtoolsFuture(expr = expr, envir = envir, substitute = FALSE,
                            globals = globals,
                            label = label,
                            workers = workers,
                            cluster.functions = cf,
                            ...)

  if (!future$lazy) future <- run(future)

  future
}
class(batchtools_interactive) <- c("batchtools_interactive", "batchtools",
                                   "uniprocess", "future", "function")
