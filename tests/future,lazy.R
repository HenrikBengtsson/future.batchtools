source("incl/start.R")

message("*** Futures - lazy ...")

strategies <- c("batchtools_local")

## CRAN processing times:
## On Windows 32-bit, don't run these tests
if (!fullTest && isWin32) strategies <- character(0L)

for (strategy in strategies) {
  mprintf("- plan('%s') ...\n", strategy)
  plan(strategy)

  a <- 42
  f <- future(2 * a, lazy = TRUE)
  a <- 21
  stopifnot(!resolved(f))
  f <- resolve(f)
  stopifnot(resolved(f))
  v <- value(f)
  stopifnot(v == 84)

  a <- 42
  v %<-% { 2 * a } %lazy% TRUE
  a <- 21
  f <- futureOf(v)  
  stopifnot(!resolved(f))
  f <- resolve(f)
  stopifnot(resolved(f))
  stopifnot(v == 84)

  mprintf("- plan('%s') ... DONE\n", strategy)
} ## for (strategy ...)

message("*** Futures - lazy ... DONE")

source("incl/end.R")
