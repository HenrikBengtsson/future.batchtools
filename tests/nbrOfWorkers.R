source("incl/start.R")
library("listenv")

message("*** nbrOfWorkers() ...")

message("*** nbrOfWorkers() - local, interactive ...")

n <- nbrOfWorkers(batchtools_local)
message("Number of workers: ", n)
stopifnot(n == 1L)

n <- nbrOfWorkers(batchtools_interactive)
message("Number of workers: ", n)
stopifnot(n == 1L)

plan(batchtools_local)
n <- nbrOfWorkers()
message("Number of workers: ", n)
stopifnot(n == 1L)

plan(batchtools_interactive)
n <- nbrOfWorkers()
message("Number of workers: ", n)
stopifnot(n == 1L)

message("*** nbrOfWorkers() - local, interactive ... DONE")


ncores <- availableCores("multicore")
if (ncores >= 2L) {
message("*** nbrOfWorkers() - multicore ...")

n <- nbrOfWorkers(batchtools_multicore)
message("Number of workers: ", n)
stopifnot(n == ncores)

plan(batchtools_multicore)
n <- nbrOfWorkers()
message("Number of workers: ", n)
stopifnot(n == ncores)

workers <- min(2L, ncores)
plan(batchtools_multicore, workers=workers)
n <- nbrOfWorkers()
message("Number of workers: ", n)
stopifnot(n == workers)

message("*** nbrOfWorkers() - multicore ... DONE")
} ## if (ncores >= 2L)


message("*** nbrOfWorkers() - templates ...")

n <- nbrOfWorkers(batchtools_lsf)
message("Number of workers: ", n)
stopifnot(is.infinite(n))

n <- nbrOfWorkers(batchtools_openlava)
message("Number of workers: ", n)
stopifnot(is.infinite(n))

n <- nbrOfWorkers(batchtools_sge)
message("Number of workers: ", n)
stopifnot(is.infinite(n))

n <- nbrOfWorkers(batchtools_slurm)
message("Number of workers: ", n)
stopifnot(is.infinite(n))

n <- nbrOfWorkers(batchtools_torque)
message("Number of workers: ", n)
stopifnot(is.infinite(n))

message("*** nbrOfWorkers() - templates ... DONE")


message("*** nbrOfWorkers() - conf ...")

n <- nbrOfWorkers(batchtools_custom)
message("Number of workers: ", n)
stopifnot(n == 1)

n <- nbrOfWorkers(tweak(batchtools_custom, workers=2L))
message("Number of workers: ", n)
stopifnot(n == 2)

res <- try(n <- nbrOfWorkers(tweak(batchtools_custom, workers=FALSE)), silent=TRUE)
print(res)
stopifnot(inherits(res, "try-error"))

message("*** nbrOfWorkers() - conf ... DONE")

message("*** nbrOfWorkers() ... DONE")

source("incl/end.R")
