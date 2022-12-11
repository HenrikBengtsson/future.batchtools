#' @rdname BatchtoolsFuture
#' @importFrom batchtools makeClusterFunctionsSSH
#' @importFrom parallelly availableCores
#' @export
BatchtoolsSSHFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), workers = availableCores(), ...) {
  if (substitute) expr <- substitute(expr)

  if (is.null(workers)) workers <- availableCores()
  stopifnot(is.numeric(workers), length(workers) == 1L, !is.na(workers), is.finite(workers), workers >= 1L)
  
  ssh_worker <- list(Worker$new("localhost", ncpus = 1L))
  cf <- makeClusterFunctionsSSH(ssh_worker)

  future <- BatchtoolsCustomFuture(expr = expr, substitute = FALSE, envir = envir, workers = workers, cluster.functions = cf, ...)
  future <- structure(future, class = c("BatchtoolsSSHFuture", class(future)))
  
  future$workers <- workers

  future
}
