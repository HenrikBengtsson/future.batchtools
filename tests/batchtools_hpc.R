source("incl/start.R")

print(all_strategies())

message("All HPC strategies:")
strategies <- c("batchtools_lsf", "batchtools_openlava", "batchtools_sge",
                "batchtools_slurm", "batchtools_torque")
mprint(strategies)

message("Supported HPC strategies:")
strategies <- strategies[sapply(strategies, FUN = test_strategy)]
mprint(strategies)

for (strategy in strategies) {
  plan(strategy)
  print(plan())
  
  x %<-% Sys.info()
  print(x)
  
  message(sprintf("*** %s() ... DONE", strategy))
}

source("incl/end.R")
