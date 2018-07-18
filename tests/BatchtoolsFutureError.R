source("incl/start.R")

message("*** BatchtoolsFutureError() ...")

plan(batchtools_local)

for (cleanup in c(FALSE, TRUE)) {
  mprintf("*** batchtools future error w/ future.delete = %s ...", cleanup)

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
  mprintf(" - batchtools Registry path (%s) exists: %s\n",
          sQuote(reg$file.dir), file_test("-d", reg$file.dir))
  
  ## Assert removal of files only happens if there was not
  ## a failure and option future.delete is not TRUE.
  if (!cleanup) {
    ## FIXME: Does the new future::FutureResult trigger garbage collection?
    stopifnot(file_test("-d", reg$file.dir))
    log <- batchtools::getLog(reg = reg, id = 1L)
    print(log)

    ## Now manually delete batchtools Registry
    batchtools::removeRegistry(reg = reg)
  }

  stopifnot(!file_test("-d", reg$file.dir))
  fail <- try(checkIds(reg, ids = 1L), silent = TRUE)
  stopifnot(inherits(fail, "try-error"))

  mprintf("*** batchtools future error w/ future.delete = %s ... DONE", cleanup)
} ## for (cleanup ...)


message("*** BatchtoolsFuture - expired ...")
plan(batchtools_local)
msg <- "Abruptly terminating the future!"
f <- future({
  message(msg)
  quit(save = "no")
})
res <- tryCatch({
  v <- value(f)
}, error = identity)
stopifnot(inherits(res, "error"),
          inherits(res, "FutureError"))
err_msg <- unlist(strsplit(conditionMessage(res), split = "\n", fixed = TRUE))
stopifnot(any(grepl(msg, err_msg, fixed = TRUE)))

message("*** BatchtoolsFuture - expired ... done")


if (fullTest) {
  message("*** BatchtoolsFuture - deleting running ...")

  plan(batchtools_multicore)

  f <- future({
    Sys.sleep(2)
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
