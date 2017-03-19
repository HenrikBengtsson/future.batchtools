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
#' @importFrom future nbrOfWorkers
#' @export
#' @keywords internal
nbrOfWorkers.batchtools <- function(evaluator) {
  ## 1. Infer from 'workers' argument
  expr <- formals(evaluator)$workers
  workers <- eval(expr)
  if (!is.null(workers)) {
    stopifnot(length(workers) >= 1)
    if (is.numeric(workers)) return(prod(workers))
    if (is.character(workers)) return(length(workers))
    stop("Invalid data type of 'workers': ", mode(workers))
  }
  
  ## Local functions
  getbatchtoolsConf <- importbatchtools("getbatchtoolsConf")

  
  ## 2. Infer from 'backend' argument
  expr <- formals(evaluator)$backend
  backend <- eval(expr)

  ## Known uni-process backends
  if (backend %in% c("local", "interactive")) return(1L)

  
  ## 3. Infer from batchtools configuration
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
