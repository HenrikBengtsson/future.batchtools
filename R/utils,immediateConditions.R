## immediateCondition related imports
tmpl_expr_send_immediateConditions_via_file <- NULL
readImmediateConditions <- function(...) NULL
signalImmediateConditions <- function(...) NULL

#' @importFrom utils packageVersion
import_immediateConditions <- function() {
  if (packageVersion("future") < "1.30.0-9005") return()
  tmpl_expr_send_immediateConditions_via_file <<- import_future("tmpl_expr_send_immediateConditions_via_file", mode = "list")
  readImmediateConditions <<- import_future("readImmediateConditions")
  signalImmediateConditions <<- import_future("signalImmediateConditions")
}

