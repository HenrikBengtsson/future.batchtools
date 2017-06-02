source("incl/start.R")

message("*** %resources% ...")

plan(batchtools_local)

## This will test `%resources%` but it'll be ignored
## (with a warning) by batchtools_local()
y %<-% { 42 } %resources% list(mem = "42gb")

message("*** %resources% ... DONE")

source("incl/end.R")
