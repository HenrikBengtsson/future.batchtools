is_na <- function(x) {
  if (length(x) != 1L) return(FALSE)
  is.na(x)
}

isFALSE <- function(x) {
  if (length(x) != 1L) return(FALSE)
  x <- as.logical(x)
  x <- unclass(x)
  identical(FALSE, x)
}

attachedPackages <- function() {
  pkgs <- search()
  pkgs <- grep("^package:", pkgs, value = TRUE)
  pkgs <- gsub("^package:", "", pkgs)
  pkgs
}

printf <- function(...) cat(sprintf(...))

mcat <- function(...) message(..., appendLF = FALSE)

mprintf <- function(...) message(sprintf(...), appendLF = FALSE)

mprint <- function(...) {
  bfr <- captureOutput(print(...))
  bfr <- paste(c(bfr, ""), collapse = "\n")
  message(bfr, appendLF = FALSE)
}

#' @importFrom utils str
mstr <- function(...) {
  bfr <- captureOutput(str(...))
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

## Adopted R.utils 2.1.0 (2015-06-15)
#' @importFrom utils capture.output
captureOutput <- function(expr, envir = parent.frame(), ...) {
  res <- eval({
    file <- rawConnection(raw(0L), open = "w")
    on.exit(close(file))
    capture.output(expr, file = file)
    rawToChar(rawConnectionValue(file))
  }, envir = envir, enclos = envir)
  unlist(strsplit(res, split = "\n", fixed = TRUE), use.names = FALSE)
}

## Adopted from R.oo 1.19.0 (2015-06-15)
trim <- function(x, ...) {
  sub("[\t\n\f\r ]*$", "", sub("^[\t\n\f\r ]*", "", x))
}


importFuture <- function(name, default = NULL) {
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
isOS <- function(name) {
  if (name == "windows") {
    return(.Platform$OS.type == "windows")
  } else {
    grepl(paste0("^", name), R.version$os)
  }
} ## isOS()
