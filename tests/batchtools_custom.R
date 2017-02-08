source("incl/start.R")
library("listenv")

message("*** batchtools_custom() ...")


## Technically this could give an error if there is a
## malfunctioning ~/.batchtools.R on the test system.
message("*** batchtools_custom() w/out pathname (default) ...")
plan(batchtools_custom)

f <- future({
  42L
})
stopifnot(inherits(f, "BatchtoolsFuture"))
y <- value(f)
print(y)
stopifnot(y == 42L)

## A global variable
a <- 0
f <- future({
  b <- 3
  c <- 2
  a * b * c
})
print(f)

a <- 7  ## Make sure globals are frozen
v <- value(f)
print(v)
stopifnot(v == 0)

message("*** batchtools_custom() w/out pathname (default) ... DONE")


message("*** batchtools_custom() w/ pathname ...")

## batchtools configuration R scripts to be tested
path <- system.file("conf", package="future.batchtools")
filenames <- c("local.R", "interactive.R")
pathnames <- file.path(path, filenames)

for (pathname in pathnames) {
  message(sprintf("- plan(batchtools_custom, pathname='%s') ...", pathname))
  plan(batchtools_custom, pathname=pathname)

  f <- future({
    42L
  })
  stopifnot(inherits(f, "BatchtoolsFuture"))
  y <- value(f)
  print(y)
  stopifnot(y == 42L)

  ## A global variable
  a <- 0
  f <- future({
    b <- 3
    c <- 2
    a * b * c
  })
  print(f)

  a <- 7  ## Make sure globals are frozen
  v <- value(f)
  print(v)
  stopifnot(v == 0)

  message(sprintf("- plan(batchtools_custom, pathname='%s') ... DONE", pathname))
} ## for (pathname ...)

message("*** batchtools_custom() w/ pathname ... DONE")


message("*** batchtools_custom() - exceptions ...")

res <- try(f <- batchtools_custom(42L, conf=TRUE), silent=TRUE)
print(res)
stopifnot(inherits(res, "try-error"))

message("*** batchtools_custom() - exceptions ... DONE")


message("*** batchtools_custom() ... DONE")

source("incl/end.R")
