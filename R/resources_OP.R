#' Temporarily tweaks the resources for the current batchtools strategy
#'
#' @usage fassignment \%resources\% tweaks
#'
#' @param fassignment The future assignment, e.g.
#'        \code{x \%<=\% \{ expr \}}.
#' @param tweaks A named list (or vector) of resource
#' batchtools parameters that should be changed relative to
#' the current strategy.
#'
#' @export
#' @importFrom future plan tweak
#' @keywords internal
`%resources%` <- function(fassignment, tweaks) {
  fassignment <- substitute(fassignment)
  envir <- parent.frame(1)
  stopifnot(is.vector(tweaks))
  tweaks <- as.list(tweaks)
  stopifnot(!is.null(names(tweaks)))

  ## Temporarily use a different plan
  oplan <- plan("list")
  on.exit(plan(oplan, substitute=FALSE, .call=NULL))

  ## Tweak current strategy and apply
  args <- list(plan(), resources=tweaks, penvir=envir)
  strategy <- do.call(tweak, args=args)
  plan(strategy, substitute=FALSE, .call=NULL)

  eval(fassignment, envir=envir)
}
