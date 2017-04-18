#' Batchtools futures for LSF, OpenLava, SGE, Slurm, TORQUE etc.
#'
#' Batchtools futures for LSF, OpenLava, SGE, Slurm, TORQUE etc. are
#' asynchronous multiprocess futures that will be evaluated on a compute
#' cluster via a job scheduler.
#'
#' @inheritParams BatchtoolsFuture
#' 
#' @param pathname A batchtools template file (\pkg{brew} formatted).
#' 
#' @param resources A named list passed to the batchtools template (available
#' as variable \code{resources}).
#' 
#' @param \ldots Additional arguments passed to
#' \code{\link{BatchtoolsFuture}()}.
#'
#' @return An object of class \code{BatchtoolsFuture}.
#'
#' @details
#' These type of batchtools futures rely on batchtools backends set
#' up using the following \pkg{batchtools} functions:
#' \itemize{
#'  \item \code{\link[batchtools]{makeClusterFunctionsLSF}()} for
#'    \href{https://en.wikipedia.org/wiki/Platform_LSF}{Load Sharing
#'          Facility (LSF)}
#'  \item \code{makeClusterFunctionsOpenLava()} for
#'    \href{https://en.wikipedia.org/wiki/OpenLava}{OpenLava}
#'  \item \code{\link[batchtools]{makeClusterFunctionsSGE}()} for
#'    \href{https://en.wikipedia.org/wiki/Oracle_Grid_Engine}{Sun/Oracle
#'          Grid Engine (SGE)}
#'  \item \code{\link[batchtools]{makeClusterFunctionsSlurm}()} for
#'    \href{https://en.wikipedia.org/wiki/Slurm_Workload_Manager}{Slurm}
#'  \item \code{\link[batchtools]{makeClusterFunctionsTORQUE}()} for
#'    \href{https://en.wikipedia.org/wiki/TORQUE}{TORQUE} / PBS
#' }
#'
#' @export
#' @rdname batchtools_template
#' @name batchtools_template
batchtools_lsf <- function(expr, envir=parent.frame(), substitute=TRUE,
                           globals=TRUE, label="batchtools", pathname=NULL,
                           resources=list(), workers=Inf, ...) {
  if (substitute) expr <- substitute(expr)

  batchtools_by_template(expr, envir = envir, substitute = FALSE,
                         globals = globals, label = label, pathname = pathname,
                         type = "lsf", resources = resources,
                         workers = workers, ...)
}
class(batchtools_lsf) <- c("batchtools_lsf", "batchtools_template",
                           "batchtools", "multiprocess", "future",
                           "function")

#' @export
#' @rdname batchtools_template
batchtools_openlava <- function(expr, envir=parent.frame(), substitute=TRUE,
                                globals=TRUE, label="batchtools", pathname=NULL,
                                resources=list(), workers=Inf, ...) {
  if (substitute) expr <- substitute(expr)

  batchtools_by_template(expr, envir = envir, substitute = FALSE,
                         globals = globals, label = label, pathname = pathname,
                         type = "openlava", resources = resources,
                         workers = workers, ...)
}
class(batchtools_openlava) <- c("batchtools_openlava", "batchtools_template",
                                "batchtools", "multiprocess", "future",
                                "function")

#' @export
#' @rdname batchtools_template
batchtools_sge <- function(expr, envir=parent.frame(), substitute=TRUE,
                           globals=TRUE, label="batchtools", pathname=NULL,
                           resources=list(), workers=Inf, ...) {
  if (substitute) expr <- substitute(expr)

  batchtools_by_template(expr, envir = envir, substitute = FALSE,
                         globals = globals, label = label, pathname = pathname,
                         type = "sge", resources = resources,
                         workers = workers, ...)
}
class(batchtools_sge) <- c("batchtools_sge", "batchtools_template",
                           "batchtools", "multiprocess", "future",
                           "function")

#' @export
#' @rdname batchtools_template
batchtools_slurm <- function(expr, envir=parent.frame(), substitute=TRUE,
                             globals=TRUE, label="batchtools", pathname=NULL,
                             resources=list(), workers=Inf, ...) {
  if (substitute) expr <- substitute(expr)

  batchtools_by_template(expr, envir = envir, substitute = FALSE,
                         globals = globals, label = label, pathname = pathname,
                         type = "slurm", resources = resources,
                         workers = workers, ...)
}
class(batchtools_slurm) <- c("batchtools_slurm", "batchtools_template",
                             "batchtools", "multiprocess", "future",
                             "function")

#' @export
#' @rdname batchtools_template
batchtools_torque <- function(expr, envir=parent.frame(), substitute=TRUE, globals=TRUE, label="batchtools", pathname=NULL, resources=list(), workers=Inf, ...) {
  if (substitute) expr <- substitute(expr)

  batchtools_by_template(expr, envir = envir, substitute = FALSE,
                         globals = globals, label = label, pathname = pathname,
                         type = "torque", resources = resources,
                         workers = workers, ...)
}
class(batchtools_torque) <- c("batchtools_torque", "batchtools_template",
                              "batchtools", "multiprocess", "future",
                              "function")


#' @importFrom batchtools makeClusterFunctionsLSF
#' @importFrom batchtools makeClusterFunctionsSGE
#' @importFrom batchtools makeClusterFunctionsSlurm
#' @importFrom batchtools makeClusterFunctionsTORQUE
#' @importFrom utils file_test
batchtools_by_template <- function(expr, envir=parent.frame(), substitute=TRUE, globals=TRUE, pathname=NULL, type=c("lsf", "openlava", "sge", "slurm", "torque"), resources=list(), label="batchtools", workers=Inf, ...) {
  if (substitute) expr <- substitute(expr)
  type <- match.arg(type)

  makeCFs <- switch(type,
    lsf      = makeClusterFunctionsLSF,
    openlava = makeClusterFunctionsOpenLava,
    sge      = makeClusterFunctionsSGE,
    slurm    = makeClusterFunctionsSlurm,
    torque   = makeClusterFunctionsTORQUE
  )

  ## Search for a default template file?
  if (is.null(pathname)) {
    pathnames <- NULL

    ## FIXME: this is how future.BatchJobs locates template files, but
    ## batchtools uses slightly different rules.  /HB 2017-03-19
    paths <- c(".", "~")
    filename <- sprintf(".batchtools.%s.tmpl", type)
    pathnames <- c(pathnames, file.path(paths, filename))

    ## Because R CMD check complains about periods in package files
    path <- system.file("conf", package = "future.batchtools")
    filename <- sprintf("batchtools.%s.tmpl", type)
    pathname <- file.path(path, filename)
    
    pathnames <- c(pathnames, pathname)
    pathnames <- pathnames[file_test("-f", pathnames)]
    if (length(pathnames) == 0L) {
      stop(sprintf("Failed to locate a %s template file", sQuote(filename)))
    }
    pathname <- pathnames[1]
  }

  cluster.functions <- makeCFs(pathname)
  attr(cluster.functions, "pathname") <- pathname

  future <- BatchtoolsFuture(expr = expr, envir = envir, substitute = FALSE,
                            globals = globals,
			    label = label,
                            cluster.functions = cluster.functions,
			    resources = resources,
                            workers = workers,
			    ...)

  if (!future$lazy) future <- run(future)

  future
} ## batchtools_by_template()
