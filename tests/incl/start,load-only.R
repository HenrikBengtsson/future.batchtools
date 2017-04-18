## Record original state
ovars <- ls()
oopts <- options(warn = 1L, mc.cores = 2L, future.debug = TRUE)
oopts$future.delete <- getOption("future.delete")
oplan <- future::plan()

## Use local batchtools futures by default
future::plan(future.batchtools:::batchtools_local)

fullTest <- (Sys.getenv("_R_CHECK_FULL_") != "")

attachedPackages <- future.batchtools:::attachedPackages
await <- future.batchtools:::await
delete <- future.batchtools:::delete
importFuture <- future.batchtools:::importFuture
isFALSE <- future.batchtools:::isFALSE
isNA <- future.batchtools:::isNA
isOS <- future.batchtools:::isOS
hpaste <- future.batchtools:::hpaste
mcat <- future.batchtools:::mcat
mprintf <- future.batchtools:::mprintf
mprint <- future.batchtools:::mprint
mstr <- future.batchtools:::mstr
printf <- future.batchtools:::printf
tempRegistry <- future.batchtools:::tempRegistry
trim <- future.batchtools:::trim
attachLocally <- function(x, envir = parent.frame()) {
  for (name in names(x)) {
    assign(name, value = x[[name]], envir = envir)
  }
}
