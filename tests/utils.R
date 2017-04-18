source("incl/start.R")

message("*** Utility functions ...")

message("- is_na() ...")
stopifnot(is_na(NA), !is_na(TRUE), !is_na(FALSE), !is_na(1),
          !is_na(NULL), !is_na(1:2), !is_na(rep(NA, times = 3)),
          !is_na(rep(TRUE, 3)), !is_na(letters))

message("- isFALSE() ...")
stopifnot(isFALSE(FALSE), !isFALSE(TRUE), !isFALSE(NA), !isFALSE(1),
          !isFALSE(NULL), !isFALSE(1:2), !isFALSE(rep(FALSE, times = 3)),
          !isFALSE(rep(TRUE, times = 3)), !isFALSE(letters))

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

printf("x = %s.\n", hpaste(x, max_head = 2))
## x = 1, 2, ..., 6.

printf("x = %s.\n", hpaste(x), max_head = 3) # Default
## x = 1, 2, 3, ..., 6.

# It will never output 1, 2, 3, 4, ..., 6
printf("x = %s.\n", hpaste(x, max_head = 4))
## x = 1, 2, 3, 4, 5 and 6.

# Showing the tail
printf("x = %s.\n", hpaste(x, max_head = 1, max_tail = 2))
## x = 1, ..., 5, 6.

# Turning off abbreviation
printf("y = %s.\n", hpaste(y, max_head = Inf))
## y = 10, 9, 8, 7, 6, 5, 4, 3, 2, 1

## ...or simply
printf("y = %s.\n", paste(y, collapse = ", "))
## y = 10, 9, 8, 7, 6, 5, 4, 3, 2, 1

# Adding a special separator before the last element
# Change last separator
printf("x = %s.\n", hpaste(x, last_collapse = " and "))
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
for (os in c("darwin", "freebsd", "irix", "linux", "openbsd",
             "solaris", "windows")) {
  mprintf("isOS('%s') = %s", os, isOS(os))
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# importFuture()
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
message("*** importFuture() ...")

future <- importFuture("future")
stopifnot(identical(future, future::future))

future <- importFuture("<unknown function>", default = future::future)
stopifnot(identical(future, future::future))

res <- try(importFuture("<unknown function>"), silent = TRUE)
stopifnot(inherits(res, "try-error"))

message("*** importFuture() ... DONE")

message("*** Utility functions ... DONE")

source("incl/end.R")
