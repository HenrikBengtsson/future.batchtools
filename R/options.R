#' Options used for batchtools futures
#'
#' Below are the \R options and environment variables that are used by the
#' \pkg{future.batchtools} package.
#' See [future::future.options] for additional ones that apply to futures
#' in general.\cr
#' \cr
#' _WARNING: Note that the names and the default values of these options may change in future versions of the package.  Please use with care until further notice._
#'
#' @section Settings for batchtools futures:
#' \describe{
#'   \item{\option{future.batchtools.workers}:}{(a positive numeric or `+Inf`)
#'     The default number of workers available on HPC schedulers with
#'     job queues.  If not set, the value of the 
#'     \env{R_FUTURE_BATCHTOOLS_WORKERS} environment variable is used.
#'     (Default: `100`)}
#'
#'   \item{\option{future.batchtools.output}:}{(logical)
#'     If TRUE, \pkg{batchtools} will produce extra output.
#'     If FALSE, such output will be disabled by setting \pkg{batchtools}
#'     options \option{batchtools.verbose} and \option{batchtools.progress}
#'     to FALSE.
#'     (Default: `getOption("future.debug", FALSE)`)}
#'
#'   \item{\option{future.batchtools.expiration.tail}:}{(a positive numeric)
#'     When a \pkg{batchtools} job expires, the last few lines will be
#'     relayed by batchtools futures to help troubleshooting.
#'     This option controls how many lines are displayed.
#'     (Default: `48L`)}
#'
#'   \item{\env{R_FUTURE_CACHE_PATH}}{(character string)
#'     An absolute or relative path specifying the root folder in which
#'     \pkg{batchtools} registry folders are stored.
#'     (Default: `.future`)}
#' }
#'
#' @aliases
#' future.cmdargs 
#' future.batchtools.expiration.tail
#' future.batchtools.output
#' future.batchtools.workers
#' R_FUTURE_BATCHTOOLS_WORKERS
#' R_FUTURE_FUTURE_CACHE_PATH
#'
#' @keywords internal
#' @name future.batchtools.options
NULL
