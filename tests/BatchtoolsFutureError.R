source("incl/start.R")

message("*** BatchtoolsFutureError() ...")

plan(batchtools_local)

for (cleanup in c(FALSE, TRUE)) {
  message(sprintf("*** batchtools future error w/ future.delete = %s ...", cleanup))

  options(future.delete = cleanup)

  f <- future({
    x <- 1
    print(x)
    stop("Woops!")
  })
  print(f)

  resolve(f)

  ## Assert future is listed as resolved
  stopifnot(resolved(f))

  reg <- f$config$reg

  ## Force garbage collection of future which will possibly
  ## result in the removal of batchtools registry files
  reg.finalizer(f, function(f) {
    message("Garbage collection future ...")
    print(f)
    message("Garbage collection future ... DONE")
  }, onexit = TRUE)
  rm(list = "f")
  gc()
  message(" - Future removed and garbage collected.")
  message(sprintf(" - batchtools Registry path (%s) exists: %s", sQuote(reg$file.dir), file_test("-d", reg$file.dir)))

  ## Assert removal of files only happens if there was not
  ## a failure and option future.delete is not TRUE.
  if (!cleanup) {
    stopifnot(file_test("-d", reg$file.dir))
    log <- batchtools::getLog(reg = reg, id = 1L)
    print(log)

    ## Now manually delete batchtools Registry
    batchtools::removeRegistry(reg = reg)
  }

  stopifnot(!file_test("-d", reg$file.dir))
  fail <- try(checkIds(reg, ids = 1L), silent = TRUE)
  stopifnot(inherits(fail, "try-error"))

  message(sprintf("*** batchtools future error w/ future.delete = %s ... DONE", cleanup))
} ## for (cleanup ...)


if (fullTest) {
  message("*** BatchtoolsFuture - deleting running ...")

  plan(batchtools_multicore)

  f <- future({
    Sys.sleep(5)
    42L
  })

  if (!resolved(f)) {
    res <- delete(f, onRunning = "skip")
    stopifnot(isTRUE(res))
  }

  if (!resolved(f)) {
    res <- tryCatch({
      delete(f, onRunning = "warning")
    }, warning = function(w) w)
    stopifnot(inherits(res, "warning"))
  }

  if (!resolved(f)) {
    res <- tryCatch({
      delete(f, onRunning = "error")
    }, error = function(ex) ex)
    stopifnot(inherits(res, "error"))
  }

  message("*** BatchtoolsFuture - deleting running ... DONE")
} ## if (fullTest)


message("*** BatchtoolsFutureError() ... DONE")

source("incl/end.R")
