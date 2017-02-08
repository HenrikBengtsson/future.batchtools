source("incl/start.R")
library("listenv")

message("*** batchtools_template() ...")

## NOTE: Here we use invalid 'workers=FALSE' in order to
## prevent the batchtools future from actually starting,
## because we cannot assume that system has these schedulers.
## NOTE: Some of them will give an earlier error because
## no default template file was found.
res <- try(batchtools_lsf({ 42L }, workers=FALSE))
stopifnot(inherits(res, "try-error"))

res <- try(batchtools_openlava({ 42L }, workers=FALSE))
stopifnot(inherits(res, "try-error"))

res <- try(batchtools_sge({ 42L }, workers=FALSE))
stopifnot(inherits(res, "try-error"))

res <- try(batchtools_slurm({ 42L }, workers=FALSE))
stopifnot(inherits(res, "try-error"))

res <- try(batchtools_torque({ 42L }, workers=FALSE))
stopifnot(inherits(res, "try-error"))



## NOTE: Here we use invalid 'args' in order to
## prevent the batchtools future from actually starting,
## because we cannot assume that system has these schedulers.
## These tests goes a little bit beyond the above ones
## and actually creates batchtools registries.
## NOTE: Some of them will give an earlier error because
## no default template file was found.

resources <- list(walltime=3600)
args <- list(
  non_supported="Gives error because batchtools only supports 'resources'"
)
  
res <- try(batchtools_lsf({ 42L }, resources=resources, args=args))
stopifnot(inherits(res, "try-error"))

res <- try(batchtools_openlava({ 42L }, resources=resources, args=args))
stopifnot(inherits(res, "try-error"))

res <- try(batchtools_sge({ 42L }, resources=resources, args=args))
stopifnot(inherits(res, "try-error"))

res <- try(batchtools_slurm({ 42L }, resources=resources, args=args))
stopifnot(inherits(res, "try-error"))

res <- try(batchtools_torque({ 42L }, resources=resources, args=args))
stopifnot(inherits(res, "try-error"))

message("*** batchtools_template() ... DONE")

source("incl/end.R")
