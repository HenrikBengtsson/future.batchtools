#' @inheritParams BatchtoolsUniprocessFuture
#'
#' @importFrom batchtools makeClusterFunctionsInteractive
#' @export
batchtools_interactive <- function(..., envir = parent.frame()) {
  cf <- makeClusterFunctionsInteractive(external = FALSE)
  future <- BatchtoolsInteractiveFuture(..., envir = envir, cluster.functions = cf)
  if (!future$lazy) future <- run(future)
  invisible(future)
}
class(batchtools_interactive) <- c(
  "batchtools_interactive", "batchtools_uniprocess", "batchtools",
  "uniprocess", "future", "function"
)
attr(batchtools_interactive, "tweakable") <- c("finalize")
attr(batchtools_interactive, "untweakable") <- c("workers")
