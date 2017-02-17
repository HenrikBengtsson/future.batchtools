source("incl/start.R")

message("*** BatchtoolsFutureError() ...")

plan(batchtools_local)

for (cleanup in c(FALSE, TRUE)) {
  message(sprintf("*** batchtools future error w/ future.delete=%s ...", cleanup))

  options(future.delete=cleanup)

  f <- future({
    x <- 1
    print(x)
    stop("Woops!")
  })
  print(f)

  resolve(f)

  ## FIXME: When using value(), there is something causing the
  ## future object 'f' to not be garbage collected within the
  ## same iteration of the for loop. This seems to only occur
  ## when there is an error in the future, cf. BatchtoolsFuture,gc.R.
  ## /HB 2016-05-01
  ## Maybe it's because base::geterrmessage() holds on to the
  ## last error preventing it from being garbage collected? /HB 2016-05-04
##  res <- try(value(f, cleanup=FALSE), silent=TRUE)
##  stopifnot(inherits(res, "try-error"))
##  rm(list="res") ## IMPORTANT: Because 'res' holds the future 'f' internally

  ## Assert future is listed as resolved
  stopifnot(resolved(f))

  reg <- f$config$reg

  ## Force garbage collection of future which will possibly
  ## result in the removal of batchtools registry files
  reg.finalizer(f, function(f) {
    message("Garbage collection future ...")
    print(f)
    message("Garbage collection future ... DONE")
  }, onexit=TRUE)
  rm(list="f")
  gc()
  message(" - Future removed and garbage collected.")
  message(sprintf(" - batchtools Registry path (%s) exists: %s", sQuote(reg$file.dir), file_test("-d", reg$file.dir)))

  ## Assert removal of files only happens if there was not
  ## a failure and option future.delete is not TRUE.
  if (!cleanup) {
    stopifnot(file_test("-d", reg$file.dir))
    log <- batchtools::getLog(reg=reg, id=1L)
    print(log)

    ## Now manually delete batchtools Registry
    batchtools::removeRegistry(reg = reg)
  }

  stopifnot(!file_test("-d", reg$file.dir))
  fail <- try(checkIds(reg, ids=1L), silent=TRUE)
  stopifnot(inherits(fail, "try-error"))

  message(sprintf("*** batchtools future error w/ future.delete=%s ... DONE", cleanup))
} ## for (cleanup ...)


if (fullTest) {
  message("*** BatchtoolsFuture - deleting running ...")

  plan(batchtools_multicore)
  
  f <- future({
    Sys.sleep(5)
    42L
  })
  
  if (!resolved(f)) {
    res <- delete(f, onRunning="skip")
    stopifnot(isTRUE(res))
  }
  
  if (!resolved(f)) {
    res <- tryCatch({
      delete(f, onRunning="warning")
    }, warning = function(w) w)
    stopifnot(inherits(res, "warning"))
  }
  
  if (!resolved(f)) {
    res <- tryCatch({
      delete(f, onRunning="error")
    }, error = function(ex) ex)
    stopifnot(inherits(res, "error"))
  }
  
  message("*** BatchtoolsFuture - deleting running ... DONE")
} ## if (fullTest)


message("*** BatchtoolsFutureError() ... DONE")

source("incl/end.R")
