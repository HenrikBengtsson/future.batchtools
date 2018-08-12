cf <- batchtools::makeClusterFunctionsInteractive(external = TRUE)
plan(batchtools_custom, cluster.functions = cf)

## Create explicit future
f <- future({
  cat("PID:", Sys.getpid(), "\n")
  42L
})
v <- value(f)
print(v)
