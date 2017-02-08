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
#' @return A number in [1,Inf].
#'
#' @aliases nbrOfWorkers.batchtools_local nbrOfWorkers.batchtools_interactive nbrOfWorkers.batchtools_multicore nbrOfWorkers.batchtools_custom nbrOfWorkers.batchtools_lsf nbrOfWorkers.batchtools_openlava nbrOfWorkers.batchtools_sge nbrOfWorkers.batchtools_slurm nbrOfWorkers.batchtools_torque
#' @importFrom future nbrOfWorkers
#' @export
#' @keywords internal
nbrOfWorkers.batchtools <- function(evaluator) {
  ## Local functions
  getbatchtoolsConf <- importbatchtools("getbatchtoolsConf")

  ## 1. Inspect 'backend' argument
  expr <- formals(evaluator)$backend
  backend <- eval(expr)

  ## Known uni-process backends
  if (backend %in% c("local", "interactive")) return(1L)

  ## Try to infer from the batchtools configuration
  workers <- local({
    conf <- getbatchtoolsConf()  ### FIXME
    cf <- conf$cluster.functions
    env <- environment(cf$submitJob)

    name <- cf$name
    if (is.null(name)) name <- cf$Name
    if (is.null(name)) return(NULL)

    ## Uni-process backends
    if (name %in% c("Local", "Interactive")) return(1L)

    ## Cluster backends (infinite queue available)
    if (name %in% c("TORQUE", "Slurm", "SGE", "OpenLava", "LSF")) return(Inf)

    ## Multicore processing?
    if (name %in% c("Multicore")) return(env$ncpus)

    ## Ad-hoc SSH cluster
    if (name %in% c("SSH")) {
      n <- length(env$workers)
      if (n == 0L) return(NULL)
      return(n)
    }

    ## Known cluster function
    NULL
  })

  if (is.numeric(workers)) {
    stopifnot(length(workers) == 1, !is.na(workers), workers >= 1)
    return(workers)
  }

  ## If still not known, fall back to the default of the future package
  NextMethod("nbrOfWorkers")
}


#' @export
nbrOfWorkers.batchtools_custom <- function(evaluator) {
  ## Local functions
  getbatchtoolsConf <- importbatchtools("getbatchtoolsConf")

  ## Infer from 'workers' argument
  expr <- formals(evaluator)$workers
  workers <- eval(expr)
  if (!is.null(workers)) {
    stopifnot(length(workers) >= 1)
    if (is.character(workers)) return(length(workers))
    if (is.numeric(workers)) return(prod(workers))

    stop("Invalid data type of 'workers': ", mode(workers))
  }

  ## If still not known, fall back to the default of the future package
  NextMethod("nbrOfWorkers")
}


#' @export
nbrOfWorkers.batchtools_local <- function(evaluator) 1L

#' @export
nbrOfWorkers.batchtools_interactive <- function(evaluator) 1L

#' @export
nbrOfWorkers.batchtools_multicore <- function(evaluator) {
  expr <- formals(evaluator)$workers
  workers <- eval(expr)
  stopifnot(length(workers) == 1, !is.na(workers), workers >= 1, is.finite(workers))
  workers
}


#' @export
nbrOfWorkers.batchtools_lsf <- function(evaluator) Inf

#' @export
nbrOfWorkers.batchtools_openlava <- function(evaluator) Inf

#' @export
nbrOfWorkers.batchtools_sge <- function(evaluator) Inf

#' @export
nbrOfWorkers.batchtools_slurm <- function(evaluator) Inf

#' @export
nbrOfWorkers.batchtools_torque <- function(evaluator) Inf
