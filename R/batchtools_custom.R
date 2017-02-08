#' batchtools conf futures
#'
#' A conf batchtools future sources one or more batchtools configuration
#' files (R source scripts) to define the batchtools configuration
#' environment, e.g. \file{.batchtools.R}.
#'
#' @inheritParams BatchtoolsFuture
#' @param conf A batchtools configuration environment.
#' @param pathname (alternative) Pathname to one or more batchtools
#' configuration files to be loaded in order.  If NULL, then the
#' \pkg{batchtools} package will search for such configuration files.
#' @param workers (optional) Additional specification for the backend
#' workers.  If NULL, the default is used.
#' @param resources A named list passed to the batchtools template (available as variable \code{resources}).
#' @param \ldots Additional arguments passed to \code{\link{BatchtoolsFuture}()}.
#'
#' @return An object of class \code{BatchtoolsFuture}.
#'
#' @details
#' If \code{conf} is NULL (default), then the batchtools configuration will
#' be created from a set of batchtools configuration files (R script files)
#' as given by argument \code{pathname}.  If none are specified (default),
#' then \pkg{batchtools} is designed to use (in order) all of following
#' configuration files (if they exist):
#' \itemize{
#'  \item \code{system("etc", "batchtools_global_config.R", package="batchtools")}
#'  \item \code{~/.batchtools.R} (in user's home directory)
#'  \item \code{.batchtools.R} (in the current directory)
#' }
#'
#' @importFrom utils file_test
#' @export
batchtools_custom <- function(expr, envir=parent.frame(), substitute=TRUE, globals=TRUE, label="batchtools", conf=NULL, pathname=NULL, workers=NULL, resources=list(), ...) {
  findConfigs <- importbatchtools("findConfigs")
  sourceConfFiles <- importbatchtools("sourceConfFiles")

  if (substitute) expr <- substitute(expr)

  if (is.null(conf)) {
    if (is.null(pathname)) {
      ## This is how batchtools searches, cf. batchtools:::readConfs()
      path <- find.package("batchtools")
      pathname  <- findConfigs(path)
    }

    stopifnot(length(pathname) >= 1L, is.character(pathname))
    for (pn in pathname) {
      if (!file_test("-f", pn)) stop("File not found: ", sQuote(pn))
    }
    conf <- sourceConfFiles(pathname)
  } else {
    stopifnot(is.environment(conf))
  }

  future <- BatchtoolsFuture(expr=expr, envir=envir, substitute=FALSE,
                            globals=globals,
			    label=label,
                            conf=conf, workers=workers,
                            resources=resources,
			    ...)
  future$pathname <- pathname
  
  ## BACKWARD COMPATIBILTY: future (<= 1.2.0)
  if (is.null(future$lazy)) future$lazy <- FALSE
  
  if (!future$lazy) future <- run(future)

  future
}
class(batchtools_custom) <- c("batchtools_custom", "batchtools", "multiprocess", "future", "function")
