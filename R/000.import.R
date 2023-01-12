import_from <- function(name, mode = "function", default = NULL, package) {
  ns <- getNamespace(package)
  if (exists(name, mode = mode, envir = ns, inherits = FALSE)) {
    get(name, mode = mode, envir = ns, inherits = FALSE)
  } else if (!is.null(default)) {
    default
  } else {
    stop(sprintf("No such '%s' %s: %s()", package, mode, name))
  }
}

import_future <- function(...) {
  import_from(..., package = "future")
}

import_parallelly <- function(...) {
  import_from(..., package = "parallelly")
}
