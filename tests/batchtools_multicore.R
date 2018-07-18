source("incl/start.R")
library("listenv")


message("*** batchtools_multicore() ...")

for (cores in 1:min(2L, availableCores("multicore"))) {
  ## FIXME:
  if (!fullTest && cores > 1) next

  mprintf("Testing with %d cores ...", cores)
  options(mc.cores = cores - 1L)

  if (!supportsMulticore()) {
    mprintf("batchtools multicore futures are not supporting on '%s'. Falling back to use synchroneous batchtools local futures", .Platform$OS.type) #nolint
  }

  for (globals in c(FALSE, TRUE)) {
    mprintf("*** batchtools_multicore(..., globals = %s) without globals",
            globals)

    f <- batchtools_multicore({
      42L
    }, globals = globals)
    stopifnot(
      inherits(f, "BatchtoolsFuture") ||
      ((cores == 1 || !supportsMulticore()) && inherits(f, "EagerFuture"))
    )

    print(resolved(f))
    y <- value(f)
    print(y)
    stopifnot(y == 42L)

    mprintf("*** batchtools_multicore(..., globals = %s) with globals",
          globals)
    ## A global variable
    a <- 0
    f <- batchtools_multicore({
      b <- 3
      c <- 2
      a * b * c
    }, globals = globals)
    print(f)


    ## A multicore future is evaluated in a separated
    ## forked process.  Changing the value of a global
    ## variable should not affect the result of the
    ## future.
    a <- 7  ## Make sure globals are frozen
    if (globals || f$config$reg$cluster.functions$name == "Multicore") {
      v <- value(f)
      print(v)
      stopifnot(v == 0)
    } else {
      res <- tryCatch({ value(f) }, error = identity)
      print(res)
      stopifnot(inherits(res, "simpleError"))
    }


    mprintf("*** batchtools_multicore(..., globals = %s) with globals and blocking", globals) #nolint
    x <- listenv()
    for (ii in 1:2) {
      mprintf(" - Creating batchtools_multicore future #%d ...", ii)
      x[[ii]] <- batchtools_multicore({ ii }, globals = globals)
    }
    mprintf(" - Resolving %d batchtools_multicore futures", length(x))
    if (globals || f$config$reg$cluster.functions$name == "Multicore") {
      v <- values(x)
      stopifnot(all(v == 1:2))
    } else {
      v <- lapply(x, FUN = function(f) tryCatch(value(f), error = identity))
      stopifnot(all(sapply(v, FUN = inherits, "simpleError")))
    }

    mprintf("*** batchtools_multicore(..., globals = %s) and errors", globals)
    f <- batchtools_multicore({
      stop("Whoops!")
      1
    }, globals = globals)
    print(f)
    v <- value(f, signal = FALSE)
    print(v)
    stopifnot(inherits(v, "simpleError"))

    res <- try(value(f), silent = TRUE)
    print(res)
    stopifnot(inherits(res, "try-error"))

    ## Error is repeated
    res <- try(value(f), silent = TRUE)
    print(res)
    stopifnot(inherits(res, "try-error"))

  } # for (globals ...)


  message("*** batchtools_multicore(..., workers = 1L) ...")

  a <- 2
  b <- 3
  y_truth <- a * b

  f <- batchtools_multicore({ a * b }, workers = 1L)
  rm(list = c("a", "b"))

  v <- value(f)
  print(v)
  stopifnot(v == y_truth)

  message("*** batchtools_multicore(..., workers = 1L) ... DONE")

  mprintf("Testing with %d cores ... DONE", cores)
} ## for (cores ...)

message("*** batchtools_multicore() ... DONE")

source("incl/end.R")
