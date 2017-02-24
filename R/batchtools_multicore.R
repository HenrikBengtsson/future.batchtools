#' batchtools multicore futures
#'
#' A batchtools multicore future is an asynchronous multiprocess
#' future that will be evaluated in a background R session.\cr
#' \cr
#' \emph{We highly recommend using \code{\link[future]{multisession}}
#' (sic!) futures of the \pkg{future} package instead of
#' multicore batchtools futures.}
#'
#' @inheritParams BatchtoolsFuture
#' @param workers The number of multicore processes to be
#' available for concurrent batchtools multicore futures.
#' @param \ldots Additional arguments passed
#' to \code{\link{BatchtoolsFuture}()}.
#'
#' @return An object of class \code{BatchtoolsFuture}.
#'
#' @details
#' batchtools multicore futures rely on the batchtools backend set
#' up by \code{\link[batchtools]{makeClusterFunctionsMulticore}()}.
#' The batchtools multicore backend only works on operating systems
#' supporting the \code{ps} command-line tool, e.g. Linux and OS X.
#' However, they are not supported on neither Windows nor Solaris
#' Unix (because \code{ps -o ucomm=} is not supported).  When not
#' supported, it falls back to \code{\link{batchtools_local}}.
#'
#' \emph{Warning: For multicore batchtools, the \pkg{batchtools}
#' package uses a built-in algorithm for load balancing based on
#' other processes running on the same machine.  This is done
#' in order to prevent the machine's CPU load to blow up.
#' Unfortunately, the batchtools criteria for handling this often
#' results in starvation, that is, long waiting times before
#' launching jobs.  The risk for this is particularly high if
#' there are other R processes running on the same machine
#' including those by other users.
#' See also \url{https://github.com/tudo-r/batchtools/issues/99}.
#' \bold{Conclusion:} We highly recommend using
#' \code{\link[future]{multisession}} futures of the
#' \pkg{future} package instead of multicore batchtools futures.}
#'
#' Also, despite the name, batchtools multicore futures are in
#' function closer related to \link[future:multisession]{multisession}
#' futures than \link[future:multicore]{multicore} futures,
#' both provided by the \pkg{future} package.  This is because
#' batchtools spawns off background R sessions rather than forking
#' the current R process as the name otherwise might imply (at least
#' that is how the term "multicore processing" is typically used
#' in the R world).
#'
#' @importFrom batchtools makeClusterFunctionsMulticore
#' @importFrom future availableCores
#' @export
#' @keywords internal
batchtools_multicore <- function(expr, envir=parent.frame(), substitute=TRUE, globals=TRUE, label="batchtools", workers=availableCores(constraints="multicore"), ...) {
  if (substitute) expr <- substitute(expr)

  if (is.null(workers)) workers <- availableCores(constraints="multicore")
  stopifnot(length(workers) == 1L, is.numeric(workers),
            is.finite(workers), workers >= 1L)

  ## Fall back to batchtools_local if multicore processing is not supported
  if (workers == 1L || isOS("windows") || isOS("solaris") || availableCores(constraints="multicore") == 1L) {
    ## covr: skip=1
    return(batchtools_local(expr, envir=envir, substitute=FALSE, globals=globals, label=label, ...))
  }

  oopts <- options(mc.cores=workers)
  on.exit(options(oopts))

  cf <- makeClusterFunctionsMulticore(ncpus = workers)

  future <- BatchtoolsFuture(expr=expr, envir=envir, substitute=FALSE,
                            globals=globals,
			    label=label,
                            cluster.functions=cf,
			    ...)

  if (!future$lazy) future <- run(future)

  future
}
class(batchtools_multicore) <- c("batchtools_multicore", "batchtools", "multiprocess", "future", "function")
