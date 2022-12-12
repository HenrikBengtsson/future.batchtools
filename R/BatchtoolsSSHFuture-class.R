#' @rdname BatchtoolsFuture
#' @importFrom batchtools makeClusterFunctionsSSH
#' @importFrom parallelly availableCores
#' @export
BatchtoolsSSHFuture <- function(expr = NULL, substitute = TRUE, envir = parent.frame(), workers = availableCores(), ...) {
  if (substitute) expr <- substitute(expr)
  assert_no_positional_args_but_first()

  if (is.null(workers)) workers <- availableCores()
  stopifnot(is.numeric(workers), length(workers) == 1L, !is.na(workers), is.finite(workers), workers >= 1L)

  dotdotdot <- list(...)

  ## WORKAROUND: 'max.load' cannot be +Inf, because that'll lead to:
  ##
  ## Error in sample.int(x, size, replace, prob) : 
  ##   too few positive probabilities
  ##
  ## in the submitJob() function created by makeClusterFunctionsSSH().
  ## /HB 2022-12-12
  ssh_worker <- list(Worker$new(
    "localhost",
    ncpus = 1L,
    max.load = .Machine$double.xmax  ## +Inf fails
  ))

  keep <- which(names(dotdotdot) %in% names(formals(makeClusterFunctionsSSH)))
  args <- c(list(workers = ssh_worker), dotdotdot[keep])
  cluster.functions <- do.call(makeClusterFunctionsSSH, args = args)

  ## Drop used '...' arguments
  if (length(keep) > 0) dotdotdot <- dotdotdot[-keep]

  args <- list(
    expr = quote(expr),  ## Avoid 'expr' being resolved by do.call()
    substitute = FALSE, envir = envir,
    workers = workers,
    cluster.functions = cluster.functions
  )
  if (length(dotdotdot) > 0) args <- c(args, dotdotdot)

  future <- do.call(BatchtoolsCustomFuture, args = args)

  future <- structure(future, class = c("BatchtoolsSSHFuture", class(future)))
  
  future$workers <- workers

  future
}
