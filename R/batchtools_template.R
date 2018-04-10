#' Batchtools futures for LSF, OpenLava, SGE, Slurm, TORQUE etc.
#'
#' Batchtools futures for LSF, OpenLava, SGE, Slurm, TORQUE etc. are
#' asynchronous multiprocess futures that will be evaluated on a compute
#' cluster via a job scheduler.
#'
#' @inheritParams BatchtoolsFuture
#'
#' @param template (optional) A batchtools template file or a template string
#' (in \pkg{brew} format).  If not specified, it is left to the
#' \pkg{batchtools} package to locate such file using its search rules.
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
batchtools_lsf <- function(expr, envir = parent.frame(), substitute = TRUE,
                           globals = TRUE, label = NULL,
                           template = NULL, resources = list(),
                           workers = Inf, ...) {
  if (substitute) expr <- substitute(expr)

  batchtools_by_template(expr, envir = envir, substitute = FALSE,
                         globals = globals, label = label, template = template,
                         type = "lsf", resources = resources,
                         workers = workers, ...)
}
class(batchtools_lsf) <- c("batchtools_lsf", "batchtools_template",
                           "batchtools", "multiprocess", "future",
                           "function")

#' @export
#' @rdname batchtools_template
batchtools_openlava <- function(expr, envir = parent.frame(), substitute = TRUE,
                                globals = TRUE, label = NULL,
                                template = NULL, resources = list(),
                                workers = Inf, ...) {
  if (substitute) expr <- substitute(expr)

  batchtools_by_template(expr, envir = envir, substitute = FALSE,
                         globals = globals, label = label, template = template,
                         type = "openlava", resources = resources,
                         workers = workers, ...)
}
class(batchtools_openlava) <- c("batchtools_openlava", "batchtools_template",
                                "batchtools", "multiprocess", "future",
                                "function")

#' @export
#' @rdname batchtools_template
batchtools_sge <- function(expr, envir = parent.frame(), substitute = TRUE,
                           globals = TRUE, label = NULL,
                           template = NULL, resources = list(),
                           workers = Inf, ...) {
  if (substitute) expr <- substitute(expr)

  batchtools_by_template(expr, envir = envir, substitute = FALSE,
                         globals = globals, label = label, template = template,
                         type = "sge", resources = resources,
                         workers = workers, ...)
}
class(batchtools_sge) <- c("batchtools_sge", "batchtools_template",
                           "batchtools", "multiprocess", "future",
                           "function")

#' @export
#' @rdname batchtools_template
batchtools_slurm <- function(expr, envir = parent.frame(), substitute = TRUE,
                             globals = TRUE, label = NULL,
                             template = NULL, resources = list(),
                             workers = Inf, ...) {
  if (substitute) expr <- substitute(expr)

  batchtools_by_template(expr, envir = envir, substitute = FALSE,
                         globals = globals, label = label, template = template,
                         type = "slurm", resources = resources,
                         workers = workers, ...)
}
class(batchtools_slurm) <- c("batchtools_slurm", "batchtools_template",
                             "batchtools", "multiprocess", "future",
                             "function")

#' @export
#' @rdname batchtools_template
batchtools_torque <- function(expr, envir = parent.frame(), substitute = TRUE,
                              globals = TRUE, label = NULL,
                              template = NULL, resources = list(),
                              workers = Inf, ...) {
  if (substitute) expr <- substitute(expr)

  batchtools_by_template(expr, envir = envir, substitute = FALSE,
                         globals = globals, label = label, template = template,
                         type = "torque", resources = resources,
                         workers = workers, ...)
}
class(batchtools_torque) <- c("batchtools_torque", "batchtools_template",
                              "batchtools", "multiprocess", "future",
                              "function")


#' @importFrom batchtools makeClusterFunctionsLSF
#' @importFrom batchtools makeClusterFunctionsOpenLava
#' @importFrom batchtools makeClusterFunctionsSGE
#' @importFrom batchtools makeClusterFunctionsSlurm
#' @importFrom batchtools makeClusterFunctionsTORQUE
#' @importFrom utils file_test
batchtools_by_template <- function(expr, envir = parent.frame(),
                                   substitute = TRUE, globals = TRUE,
                                   template = NULL,
                                   type = c("lsf", "openlava", "sge",
                                            "slurm", "torque"),
                                   resources = list(), label = NULL,
                                   workers = Inf, ...) {
  if (substitute) expr <- substitute(expr)
  type <- match.arg(type)

  make_cfs <- switch(type,
    lsf      = makeClusterFunctionsLSF,
    openlava = makeClusterFunctionsOpenLava,
    sge      = makeClusterFunctionsSGE,
    slurm    = makeClusterFunctionsSlurm,
    torque   = makeClusterFunctionsTORQUE
  )

  ## Get the default template?
  if (is.null(template)) {
    template <- formals(make_cfs)$template
  }

  stop_if_not(is.character(template), length(template) == 1, nzchar(template))

  ## Tweaked search for template file
  findTemplateFile <- import_batchtools("findTemplateFile", default = NA)
  if (!identical(findTemplateFile, NA)) {
    template <- tryCatch({
      findTemplateFile(template)
    }, error = function(ex) {
      ## Try to find it in this package?
      if (grepl("Argument 'template'", conditionMessage(ex))) {
        pathname <- system.file("templates", sprintf("%s.tmpl", template),
                                package = "future.batchtools")
        if (file_test("-f", pathname)) return(pathname)
      }
      stop(ex)
    })
  }

  cluster.functions <- make_cfs(template)
  attr(cluster.functions, "template") <- template

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
