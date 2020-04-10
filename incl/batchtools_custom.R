options(error = function(...) print(traceback()))

cf <- batchtools::makeClusterFunctionsInteractive(external = TRUE)
print(cf)
str(cf)
plan(batchtools_custom, cluster.functions = cf)
print(plan())
print(nbrOfWorkers())

## Create explicit future
f <- future({
  cat("PID:", Sys.getpid(), "\n")
  42L
})
print(f)
v <- value(f)
print(v)
