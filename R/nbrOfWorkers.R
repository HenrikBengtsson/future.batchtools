#' Gets the number of batchtools workers
#'
#' Tries to infer the total number of batchtools workers.  This is
#' done using various ad hoc procedures based on code inspection
#' of batchtools itself.
#'
#' @param evaluator A future evaluator function.
#' If NULL (default), the current evaluator as returned
#' by \code{\link{plan}()} is used.
#'
#' @return A number in [1, Inf].
#'
#' @importFrom future nbrOfWorkers
#' @export
#' @keywords internal
nbrOfWorkers.batchtools <- function(evaluator) {
  ## 1. Infer from 'workers' argument
  expr <- formals(evaluator)$workers
  workers <- eval(expr, enclos = baseenv())
  if (!is.null(workers)) {
    stop_if_not(length(workers) >= 1)
    if (is.numeric(workers)) return(prod(workers))
    if (is.character(workers)) return(length(workers))
    stop("Invalid data type of 'workers': ", mode(workers))
  }

  ## 2. Infer from 'cluster.functions' argument
  expr <- formals(evaluator)$cluster.functions
  cf <- eval(expr, enclos = baseenv())
  if (!is.null(cf)) {
    stop_if_not(inherits(cf, "ClusterFunctions"))

    name <- cf$name
    if (is.null(name)) name <- cf$Name
    if (is.null(name)) return(Inf)

    ## Uni-process backends
    if (name %in% c("Local", "Interactive")) return(1L)

    ## Cluster backends (infinite queue available)
    if (name %in% c("TORQUE", "Slurm", "SGE", "OpenLava", "LSF")) return(Inf)
  }

  ## If still not known, assume Inf
  Inf
}
