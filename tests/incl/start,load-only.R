## Record original state
ovars <- ls()
oopts <- options(
  warn = 1L,
  mc.cores = 2L,
  future.debug = FALSE,
  future.wait.interval = 0.1  ## Speed up await() and delete()
)
oopts$future.delete <- getOption("future.delete")
oplan <- future::plan()

## In case it set outside, reset:
options(future.batchtools.workers = NULL)
Sys.unsetenv("R_FUTURE_BATCHTOOLS_WORKERS")

## Use local batchtools futures by default
future::plan(future.batchtools::batchtools_local)

fullTest <- (Sys.getenv("_R_CHECK_FULL_") != "")

isWin32 <- (.Platform$OS.type == "windows" && .Platform$r_arch == "i386")

all_strategies <- local({
  .cache <- NULL
  function(envir = parent.frame()) {
    if (!is.null(.cache)) return(.cache)
    
    strategies <- Sys.getenv("R_FUTURE_TESTS_STRATEGIES")
    strategies <- unlist(strsplit(strategies, split = ","))
    strategies <- gsub(" ", "", strategies)
    strategies <- strategies[nzchar(strategies)]
    
    ## When testing for instance 'batchtools_sge', look for a customize
    ## template file, e.g. R_BATCHTOOLS_SEARCH_PATH/batchtools.sge.tmpl
    if (length(strategies) > 0L) {
      path <- Sys.getenv("R_BATCHTOOLS_SEARCH_PATH")
      if (!nzchar(path)) {
        path <- system.file(package = "future.batchtools",
                            "templates-for-R_CMD_check", mustWork = TRUE)
        Sys.setenv(R_BATCHTOOLS_SEARCH_PATH = path)
      } else if (!file_test("-d", path)) {
        warning("R_BATCHTOOLS_SEARCH_PATH specifies a non-existing folder: ",
                sQuote(path))
      }
      ## If there is a custom R_BATCHTOOLS_SEARCH_PATH/setup.R' file, run it
      pathname <- file.path(path, "setup.R")
      if (file_test("-f", pathname)) source(pathname, local = envir)
    }
    
    strategies <- c(future:::supportedStrategies(), strategies)
    strategies <- unique(strategies)
    .cache <<- strategies
    
    strategies
  }
})

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
mcat <- function(...) message(..., appendLF = FALSE)
mprintf <- function(...) message(sprintf(...), appendLF = FALSE)
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
