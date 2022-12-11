#' @rdname BatchtoolsFuture
#' @importFrom batchtools makeClusterFunctionsSSH
#' @importFrom parallelly availableWorkers
#' @export
BatchtoolsSSHFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), workers = availableWorkers(), ...) {
  if (substitute) expr <- substitute(expr)

  if (is.null(workers)) workers <- availableWorkers()
  ssh_workers <- BatchtoolsSSHRegistry("start", workers = workers)
  cf <- makeClusterFunctionsSSH(ssh_workers)

  nworkers <- sum(vapply(ssh_workers, FUN = function(worker) worker$ncpus, FUN.VALUE = NA_integer_))

  future <- BatchtoolsCustomFuture(expr = expr, substitute = FALSE, envir = envir, workers = nworkers, ssh_workers = ssh_workers, cluster.functions = cf, ...)
  future <- structure(future, class = c("BatchtoolsSSHFuture", class(future)))


  
  future$workers <- workers

  future
}

