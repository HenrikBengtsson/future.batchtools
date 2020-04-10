source("incl/start,load-only.R")

message("*** plan() ...")

message("*** future::plan(future.batchtools::batchtools_local)")
oplan <- future::plan(future.batchtools::batchtools_local)
print(future::plan())
future::plan(oplan)
print(future::plan())


library("future.batchtools")

for (type in c("batchtools_interactive", "batchtools_local")) {
  mprintf("*** plan('%s') ...\n", type)

  plan(type)
  stopifnot(inherits(plan("next"), "batchtools"))

  a <- 0
  f <- future({
    b <- 3
    c <- 2
    a * b * c
  })
  a <- 7  ## Make sure globals are frozen
  v <- value(f)
  print(v)
  stopifnot(v == 0)

  ## Customize the 'work.dir' of the batchtools registries
  plan(type, registry = list(work.dir = NULL))
  f <- future(42, lazy = TRUE)
  utils::str(list(f$config$reg$work.dir, getwd = getwd()))
  stopifnot(f$config$reg$work.dir == getwd())

  path <- tempdir()
  plan(type, registry = list(work.dir = path))
  f <- future(42, lazy = TRUE)
  utils::str(list(
    normalizePath(f$config$reg$work.dir),
    path = normalizePath(path)
  ))
  stopifnot(normalizePath(f$config$reg$work.dir) == normalizePath(path))

  mprintf("*** plan('%s') ... DONE\n", type)
} # for (type ...)


message("*** Assert that default backend can be overridden ...")

mpid <- Sys.getpid()
print(mpid)

plan(batchtools_interactive)
pid %<-% { Sys.getpid() }
print(pid)
stopifnot(pid == mpid)

plan(batchtools_local)
pid %<-% { Sys.getpid() }
print(pid)
stopifnot(pid != mpid)


message("*** plan() ... DONE")

source("incl/end.R")
