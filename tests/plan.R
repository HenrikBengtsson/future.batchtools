source("incl/start,load-only.R")

message("*** plan() ...")

message("*** Set strategy via future::plan(future.batchtools::batchtools_local)")
oplan <- future::plan(future.batchtools::batchtools_local)
print(future::plan())
future::plan(oplan)
print(future::plan())


library("future.batchtools")
plan(batchtools_local)

for (type in c("batchtools_interactive", "batchtools_local")) {
  message(sprintf("*** plan('%s') ...", type))

  plan(type)
  stopifnot(inherits(plan(), "batchtools"))

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

  message(sprintf("*** plan('%s') ... DONE", type))
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
