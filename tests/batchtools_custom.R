source("incl/start.R")
library("batchtools")
library("listenv")

message("*** batchtools_custom() ...")

cf <- makeClusterFunctionsInteractive(external = TRUE)
str(cf)


message("*** batchtools_custom() ...")

message("*** batchtools_custom() without globals")

f <- batchtools_custom({
  42L
}, cluster.functions = cf)
stopifnot(inherits(f, "BatchtoolsFuture"))

## Check whether a batchtools_custom future is resolved
## or not will force evaluation
print(resolved(f))
stopifnot(resolved(f))

y <- value(f)
print(y)
stopifnot(y == 42L)


message("*** batchtools_custom() with globals")
## A global variable
a <- 0
f <- batchtools_custom({
  b <- 3
  c <- 2
  a * b * c
}, cluster.functions = cf)
print(f)

## Although 'f' is a batchtools_custom future and therefore
## resolved/evaluates the future expression only
## when the value is requested, any global variables
## identified in the expression (here 'a') are
## "frozen" at the time point when the future is
## created.  Because of this, 'a' preserved the
## zero value although we reassign it below
a <- 7  ## Make sure globals are frozen
##if ("covr" %in% loadedNamespaces()) v <- 0 else ## WORKAROUND
v <- value(f)
print(v)
stopifnot(v == 0)


message("*** batchtools_custom() with globals (tricky)")
x <- listenv()
for (ii in 1:5) x[[ii]] <- batchtools_custom({ ii }, globals = TRUE, cluster.functions = cf)
v <- sapply(x, FUN = value)
stopifnot(all(v == 1:5))  ## Make sure globals are frozen


message("*** batchtools_custom() and errors")
f <- batchtools_custom({
  stop("Whoops!")
  1
}, cluster.functions = cf)
print(f)
v <- value(f, signal = FALSE)
print(v)
stopifnot(inherits(v, "simpleError"))

res <- try({ v <- value(f) }, silent = TRUE)
print(res)
stopifnot(inherits(res, "try-error"))

## Error is repeated
res <- try(value(f), silent = TRUE)
print(res)
stopifnot(inherits(res, "try-error"))

message("*** batchtools_custom() ... DONE")

source("incl/end.R")
