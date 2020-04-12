library(future.batchtools)

## Use local batchtools futures
plan(batchtools_local)

## A global variable
a <- 1

v %<-% {
  b <- 3
  c <- 2
  a * b * c
}

print(v)
