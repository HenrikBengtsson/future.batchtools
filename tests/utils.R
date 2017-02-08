source("incl/start.R")

message("*** Utility functions ...")

message("- isNA() ...")
stopifnot(isNA(NA), !isNA(TRUE), !isNA(FALSE), !isNA(1),
          !isNA(NULL), !isNA(1:2), !isNA(rep(NA,3)),
          !isNA(rep(TRUE,3)), !isNA(letters))

message("- isFALSE() ...")
stopifnot(isFALSE(FALSE), !isFALSE(TRUE), !isFALSE(NA), !isFALSE(1),
          !isFALSE(NULL), !isFALSE(1:2), !isFALSE(rep(FALSE,3)),
          !isFALSE(rep(TRUE,3)), !isFALSE(letters))

message("- attachedPackages() ...")
print(attachedPackages())


message("- hpaste() & printf() ...")
# Some vectors
x <- 1:6
y <- 10:1
z <- LETTERS[x]

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Abbreviation of output vector
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf("x = %s.\n", hpaste(x))
## x = 1, 2, 3, ..., 6.

printf("x = %s.\n", hpaste(x, maxHead=2))
## x = 1, 2, ..., 6.

printf("x = %s.\n", hpaste(x), maxHead=3) # Default
## x = 1, 2, 3, ..., 6.

# It will never output 1, 2, 3, 4, ..., 6
printf("x = %s.\n", hpaste(x, maxHead=4))
## x = 1, 2, 3, 4, 5 and 6.

# Showing the tail
printf("x = %s.\n", hpaste(x, maxHead=1, maxTail=2))
## x = 1, ..., 5, 6.

# Turning off abbreviation
printf("y = %s.\n", hpaste(y, maxHead=Inf))
## y = 10, 9, 8, 7, 6, 5, 4, 3, 2, 1

## ...or simply
printf("y = %s.\n", paste(y, collapse=", "))
## y = 10, 9, 8, 7, 6, 5, 4, 3, 2, 1

# Adding a special separator before the last element
# Change last separator
printf("x = %s.\n", hpaste(x, lastCollapse=" and "))
## x = 1, 2, 3, 4, 5 and 6.

message("- mcat(), mprintf(), mprint() and mstr() ...")
mcat("Hello world!\n")
mprintf("Hello %s!\n", "world")
mprint("Hello world!")
mstr("Hello world!")

message("- trim() ...")
mprint(trim(" hello "))
stopifnot(trim(" hello ") == "hello")


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# isOS()
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
message("- isOS() ...")
for (os in c("darwin", "freebsd", "irix", "linux", "openbsd", "solaris", "windows")) {
  message(sprintf("isOS('%s') = %s", os, isOS(os)))
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# importFuture() and importbatchtools()
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
message("*** importFuture() ...")

future <- importFuture("future")
stopifnot(identical(future, future::future))

future <- importFuture("<unknown function>", default=future::future)
stopifnot(identical(future, future::future))

res <- try(importFuture("<unknown function>"), silent=TRUE)
stopifnot(inherits(res, "try-error"))

message("*** importFuture() ... DONE")


message("*** importbatchtools() ...")

batchMap <- importbatchtools("batchMap")
stopifnot(identical(batchMap, batchtools::batchMap))

batchMap <- importbatchtools("<unknown function>", default=batchtools::batchMap)
stopifnot(identical(batchMap, batchtools::batchMap))

res <- try(importbatchtools("<unknown function>"), silent=TRUE)
stopifnot(inherits(res, "try-error"))

message("*** importbatchtools() ... DONE")


message("*** Utility functions ... DONE")

source("incl/end.R")
