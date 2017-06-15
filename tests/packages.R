library(batchtools)
library(future)
library(future.batchtools)
library(data.table)

make_data.table <- function(x){
  return(data.table(a = x))
}


#define plan based on batchtools socket cluster
reg <- makeRegistry(NA)
reg$cluster.functions=makeClusterFunctionsSocket(2)
plan(batchtools_custom,cluster.functions=reg$cluster.functions, workers=2)


#this always works
x %<-% make_data.table(1)

#this used to break because it didn't load data.table on the workers
xs <- future_lapply(1:10,make_data.table)
