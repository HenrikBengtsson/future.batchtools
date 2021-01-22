#' @inheritParams BatchtoolsFuture
#'
#' @importFrom batchtools makeClusterFunctionsInteractive
#' @export
batchtools_interactive <- function(expr, envir = parent.frame(),
                                   substitute = TRUE, globals = TRUE,
                                   label = NULL, workers = 1L,
                                   registry = list(), ...) {
  if (substitute) expr <- substitute(expr)

  cf <- makeClusterFunctionsInteractive(external = FALSE)

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
class(batchtools_interactive) <- c("batchtools_interactive", "batchtools",
                                   "uniprocess", "future", "function")
attr(batchtools_interactive, "tweakable") <- c("finalize")
attr(batchtools_interactive, "untweakable") <- c("workers")
