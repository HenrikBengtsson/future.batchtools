source("incl/start.R")

strategies <- c("batchtools_lsf", "batchtools_openlava", "batchtools_sge",
                "batchtools_slurm", "batchtools_torque")
print(all_strategies())

for (strategy in strategies) {
  if (!test_strategy(strategy)) {
    message(sprintf("*** %s() ... NOT SUPPORTED", strategy))
    next
  }

  plan(strategy)
  print(plan())
  
  x %<-% Sys.info()
  print(x)
  
  message(sprintf("*** %s() ... DONE", strategy))
}

source("incl/end.R")
