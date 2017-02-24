## Use local batchtools futures
plan(batchtools_local)

## A global variable
a <- 1

## Create explicit future
f <- future({
  b <- 3
  c <- 2
  a * b * c
})
v <- value(f)
print(v)


## Create implicit future
v %<-% {
  b <- 3
  c <- 2
  a * b * c
}
print(v)
