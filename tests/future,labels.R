source("incl/start.R")

message("*** Futures - labels ...")

strategies <- c("batchtools_local")

## CRAN processing times:
## On Windows 32-bit, don't run these tests
if (!fullTest && isWin32) strategies <- character(0L)

for (strategy in strategies) {
  mprintf("- plan('%s') ...\n", strategy)
  plan(strategy)

  for (label in list(NULL, sprintf("strategy_%s", strategy))) {
    fcn <- get(strategy, mode = "function")
    stopifnot(inherits(fcn, strategy))
    f <- fcn(42, label = label)
    stopifnot(identical(f$label, label))
    v <- value(f)
    stopifnot(v == 42)
    print(f)

    f <- future(42, label = label)
    stopifnot(identical(f$label, label))
    v <- value(f)
    stopifnot(v == 42)

    v %<-% { 42 } %label% label
    f <- futureOf(v)
    stopifnot(identical(f$label, label))
    stopifnot(v == 42)

  } ## for (label ...)

  mprintf("- plan('%s') ... DONE\n", strategy)
} ## for (strategy ...)

message("*** Futures - labels ... DONE")

source("incl/end.R")
