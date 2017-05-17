## Record original state
ovars <- ls()
oopts <- options(warn = 1L, mc.cores = 2L, future.debug = TRUE)
oopts$future.delete <- getOption("future.delete")
oplan <- future::plan()

## Use local batchtools futures by default
future::plan(future.batchtools:::batchtools_local)

fullTest <- (Sys.getenv("_R_CHECK_FULL_") != "")

all_strategies <- function() {
  strategies <- Sys.getenv("R_FUTURE_TESTS_STRATEGIES")
  strategies <- unlist(strsplit(strategies, split = ","))
  strategies <- gsub(" ", "", strategies)
  strategies <- strategies[nzchar(strategies)]
  strategies <- c(future:::supportedStrategies(), strategies)
  unique(strategies)
}

test_strategy <- function(strategy) {
  strategy %in% all_strategies()
}

attached_packages <- future.batchtools:::attached_packages
await <- future.batchtools:::await
delete <- future.batchtools:::delete
import_future <- future.batchtools:::import_future
is_false <- future.batchtools:::is_false
is_na <- future.batchtools:::is_na
is_os <- future.batchtools:::is_os
hpaste <- future.batchtools:::hpaste
mcat <- future.batchtools:::mcat
mprintf <- future.batchtools:::mprintf
mprint <- future.batchtools:::mprint
mstr <- future.batchtools:::mstr
printf <- future.batchtools:::printf
temp_registry <- future.batchtools:::temp_registry
trim <- future.batchtools:::trim
attach_locally <- function(x, envir = parent.frame()) {
  for (name in names(x)) {
    assign(name, value = x[[name]], envir = envir)
  }
}
