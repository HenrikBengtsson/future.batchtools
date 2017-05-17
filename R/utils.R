is_na <- function(x) {
  if (length(x) != 1L) return(FALSE)
  is.na(x)
}

is_false <- function(x) {
  if (length(x) != 1L) return(FALSE)
  x <- as.logical(x)
  x <- unclass(x)
  identical(FALSE, x)
}

attached_packages <- function() {
  pkgs <- search()
  pkgs <- grep("^package:", pkgs, value = TRUE)
  pkgs <- gsub("^package:", "", pkgs)
  pkgs
}

## Adopted R.utils 2.1.0 (2015-06-15)
#' @importFrom utils capture.output
capture_output <- function(expr, envir = parent.frame(), ...) {
  res <- eval({
    file <- rawConnection(raw(0L), open = "w")
    on.exit(close(file))
    capture.output(expr, file = file)
    rawToChar(rawConnectionValue(file))
  }, envir = envir, enclos = envir)
  unlist(strsplit(res, split = "\n", fixed = TRUE), use.names = FALSE)
}

printf <- function(...) cat(sprintf(...))

mcat <- function(...) message(..., appendLF = FALSE)

mprintf <- function(...) message(sprintf(...), appendLF = FALSE)

mprint <- function(...) {
  bfr <- capture_output(print(...))
  bfr <- paste(c(bfr, ""), collapse = "\n")
  message(bfr, appendLF = FALSE)
}

#' @importFrom utils str
mstr <- function(...) {
  bfr <- capture_output(str(...))
  bfr <- paste(c(bfr, ""), collapse = "\n")
  message(bfr, appendLF = FALSE)
}

## From R.utils 2.0.2 (2015-05-23)
hpaste <- function(..., sep="", collapse=", ", last_collapse=NULL,
                   max_head=if (missing(last_collapse)) 3 else Inf,
                   max_tail=if (is.finite(max_head)) 1 else Inf,
                   abbreviate="...") {
  max_head <- as.double(max_head)
  max_tail <- as.double(max_tail)
  if (is.null(last_collapse)) last_collapse <- collapse

  # Build vector 'x'
  x <- paste(..., sep = sep)
  n <- length(x)

  # Nothing todo?
  if (n == 0) return(x)
  if (is.null(collapse)) return(x)

  # Abbreviate?
  if (n > max_head + max_tail + 1) {
    head <- x[seq_len(max_head)]
    tail <- rev(rev(x)[seq_len(max_tail)])
    x <- c(head, abbreviate, tail)
    n <- length(x)
  }

  if (!is.null(collapse) && n > 1) {
    if (last_collapse == collapse) {
      x <- paste(x, collapse = collapse)
    } else {
      x_head <- paste(x[1:(n - 1)], collapse = collapse)
      x <- paste(x_head, x[n], sep = last_collapse)
    }
  }

  x
}

## Adopted from R.oo 1.19.0 (2015-06-15)
trim <- function(x, ...) {
  sub("[\t\n\f\r ]*$", "", sub("^[\t\n\f\r ]*", "", x))
}


import_future <- function(name, default = NULL) {
  ns <- getNamespace("future")
  if (exists(name, mode = "function", envir = ns, inherits = FALSE)) {
    get(name, mode = "function", envir = ns, inherits = FALSE)
  } else if (!is.null(default)) {
    default
  } else {
    stop(sprintf("No such 'future' function: %s()", name))
  }
}


## Evaluates an expression in global environment.
## Because geval() is exported, we want to keep its environment()
## as small as possible, which is why we use local().  Without,
## the environment would be that of the package itself and all of
## the package would be exported.
geval <- local(function(expr, substitute = FALSE, envir = .GlobalEnv, ...) {
  if (substitute) expr <- substitute(expr)
  eval(expr, envir = envir)
})


## Tests if the current OS is of a certain type
is_os <- function(name) {
  if (name == "windows") {
    return(.Platform$OS.type == "windows")
  } else {
    grepl(paste0("^", name), R.version$os)
  }
}


## From R.utils 2.5.0
tempvar <- function(prefix = "var", value = NA, envir = parent.frame()) {
  max_tries <- 1e6
  max_int <- .Machine$integer.max

  ii <- 0L
  while (ii < max_tries) {
    # Generate random variable name
    idx <- sample.int(max_int, size = 1L)
    name <- sprintf("%s%d", prefix, idx)

    # Available?
    if (!exists(name, envir = envir, inherits = FALSE)) {
      assign(name, value, envir = envir, inherits = FALSE)
      return(name)
    }

    ii <- ii + 1L
  }

  # Failed to find a unique temporary variable name
  stop(sprintf("Failed to generate a unique non-existing temporary variable with prefix '%s'", prefix)) #nolint
}
