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
#' @param \ldots Additional arguments passed to [BatchtoolsFuture()].
#'
#' @return An object of class `BatchtoolsFuture`.
#'
#' @details
#' These type of batchtools futures rely on batchtools backends set
#' up using the following \pkg{batchtools} functions:
#'
#'  * [batchtools::makeClusterFunctionsLSF()] for
#'    [Load Sharing Facility (LSF)](https://en.wikipedia.org/wiki/Platform_LSF)
#'  * [batchtools::makeClusterFunctionsOpenLava()] for
#'    [OpenLava](https://en.wikipedia.org/wiki/OpenLava)
#'  * [batchtools::makeClusterFunctionsSGE()] for
#'    [Sun/Oracle Grid Engine (SGE)](https://en.wikipedia.org/wiki/Oracle_Grid_Engine)
#'  * [batchtools::makeClusterFunctionsSlurm()] for
#'    [Slurm](https://en.wikipedia.org/wiki/Slurm_Workload_Manager)
#'  * [batchtools::makeClusterFunctionsTORQUE()] for
#'    [TORQUE](https://en.wikipedia.org/wiki/TORQUE) / PBS
#'
#' @export
#' @rdname batchtools_template
#' @name batchtools_template
batchtools_lsf <- function(expr, envir = parent.frame(), substitute = TRUE,
                           globals = TRUE, label = NULL,
                           template = NULL, resources = list(),
                           workers = NULL,
                           registry = list(), ...) {
  if (substitute) expr <- substitute(expr)

  batchtools_by_template(expr, envir = envir, substitute = FALSE,
                         globals = globals, label = label, template = template,
                         type = "lsf", resources = resources,
                         workers = workers, registry = registry, ...)
}
class(batchtools_lsf) <- c(
  "batchtools_lsf", "batchtools_template",
  "batchtools_multiprocess", "batchtools",
  "multiprocess", "future", "function"
)
attr(batchtools_lsf, "tweakable") <- c(
  "finalize",
  ## Arguments to batchtools::makeClusterFunctionsLSF()
  "scheduler.latency", "fs.latency"
)

#' @export
#' @rdname batchtools_template
batchtools_openlava <- function(expr, envir = parent.frame(), substitute = TRUE,
                                globals = TRUE, label = NULL,
                                template = NULL, resources = list(),
                                workers = NULL,
                                registry = list(), ...) {
  if (substitute) expr <- substitute(expr)

  batchtools_by_template(expr, envir = envir, substitute = FALSE,
                         globals = globals, label = label, template = template,
                         type = "openlava", resources = resources,
                         workers = workers, registry = registry, ...)
}
class(batchtools_openlava) <- c(
  "batchtools_openlava", "batchtools_template",
  "batchtools_multiprocess", "batchtools",
  "multiprocess", "future", "function"
)
attr(batchtools_openlava, "tweakable") <- c(
  "finalize",
  ## Arguments to batchtools::makeClusterFunctionsOpenLava()
  "scheduler.latency", "fs.latency"
)

#' @export
#' @rdname batchtools_template
batchtools_sge <- function(expr, envir = parent.frame(), substitute = TRUE,
                           globals = TRUE, label = NULL,
                           template = NULL, resources = list(),
                           workers = NULL,
                           registry = list(), ...) {
  if (substitute) expr <- substitute(expr)

  batchtools_by_template(expr, envir = envir, substitute = FALSE,
                         globals = globals, label = label, template = template,
                         type = "sge", resources = resources,
                         workers = workers, registry = registry, ...)
}
class(batchtools_sge) <- c(
  "batchtools_sge", "batchtools_template",
  "batchtools_multiprocess", "batchtools",
  "multiprocess", "future", "function"
)
attr(batchtools_sge, "tweakable") <- c(
  "finalize",
  ## Arguments to batchtools::makeClusterFunctionsSGE()
  "nodename", "scheduler.latency", "fs.latency"
)

#' @export
#' @rdname batchtools_template
batchtools_slurm <- function(expr, envir = parent.frame(), substitute = TRUE,
                             globals = TRUE, label = NULL,
                             template = NULL, resources = list(),
                             workers = NULL,
                             registry = list(), ...) {
  if (substitute) expr <- substitute(expr)

  batchtools_by_template(expr, envir = envir, substitute = FALSE,
                         globals = globals, label = label, template = template,
                         type = "slurm", resources = resources,
                         workers = workers, registry = registry, ...)
}
class(batchtools_slurm) <- c(
  "batchtools_slurm", "batchtools_template",
  "batchtools_multiprocess", "batchtools",
  "multiprocess", "future", "function"
)
attr(batchtools_slurm, "tweakable") <- c(
  "finalize",
  ## Arguments to batchtools::makeClusterFunctionsSlurm()
  "array.jobs", "nodename", "scheduler.latency", "fs.latency"
)


#' @export
#' @rdname batchtools_template
batchtools_torque <- function(expr, envir = parent.frame(), substitute = TRUE,
                              globals = TRUE, label = NULL,
                              template = NULL, resources = list(),
                              workers = NULL,
                              registry = list(), ...) {
  if (substitute) expr <- substitute(expr)

  batchtools_by_template(expr, envir = envir, substitute = FALSE,
                         globals = globals, label = label, template = template,
                         type = "torque", resources = resources,
                         workers = workers, registry = registry, ...)
}
class(batchtools_torque) <- c(
  "batchtools_torque", "batchtools_template",
  "batchtools_multiprocess", "batchtools",
  "multiprocess", "future", "function"
)
attr(batchtools_torque, "tweakable") <- c(
  "finalize",
  ## Arguments to batchtools::makeClusterFunctionsTORQUE()
  "scheduler.latency", "fs.latency"
)


#' @importFrom batchtools makeClusterFunctionsLSF
#' @importFrom batchtools makeClusterFunctionsOpenLava
#' @importFrom batchtools makeClusterFunctionsSGE
#' @importFrom batchtools makeClusterFunctionsSlurm
#' @importFrom batchtools makeClusterFunctionsTORQUE
batchtools_by_template <- function(expr, envir = parent.frame(),
                                   substitute = TRUE, globals = TRUE,
                                   template = NULL,
                                   type = c("lsf", "openlava", "sge",
                                            "slurm", "torque"),
                                   resources = list(), label = NULL,
                                   workers = NULL,
                                   registry = list(), ...) {
  if (substitute) expr <- substitute(expr)
  type <- match.arg(type)

  dotdotdot <- list(...)

  make_cfs <- switch(type,
    lsf      = makeClusterFunctionsLSF,
    openlava = makeClusterFunctionsOpenLava,
    sge      = makeClusterFunctionsSGE,
    slurm    = makeClusterFunctionsSlurm,
    torque   = makeClusterFunctionsTORQUE
  )

  constructor <- switch(type,
    lsf      = BatchtoolsLsfFuture,
    openlava = BatchtoolsOpenLavaFuture,
    sge      = BatchtoolsSGEFuture,
    slurm    = BatchtoolsSlurmFuture,
    torque   = BatchtoolsTorqueFuture
  )

  make_cfs_formals <- formals(make_cfs)
  
  ## Get the default template?
  if (is.null(template)) {
    template <- make_cfs_formals$template
  }

  stop_if_not(is.character(template), length(template) == 1L,
              !is.na(template), nzchar(template))

  template <- find_template_file(template)

  keep <- which(names(dotdotdot) %in% names(make_cfs_formals))
  args <- c(list(template = template), dotdotdot[keep])
  cluster.functions <- do.call(make_cfs, args = args)
  attr(cluster.functions, "template") <- template

  ## Drop used '...' arguments
  if (length(keep) > 0) dotdotdot <- dotdotdot[-keep]

  args <- list(
    expr = expr, substitute = FALSE, envir = envir,
    globals = globals,
    label = label,
    cluster.functions = cluster.functions,
    registry = registry,
    resources = resources,
    workers = workers
  )
  if (length(dotdotdot) > 0) args <- c(args, dotdotdot)
  future <- do.call(constructor, args = args, quote = TRUE)

  if (!future$lazy) future <- run(future)

  invisible(future)
} ## batchtools_by_template()
