source("incl/start.R")

options("R_FUTURE_DEMO_MANDELBROT_PLANES"=4L)

message("*** Demos ...")

message("*** Mandelbrot demo of the 'future' package ...")

plan(batchtools_local)
demo("mandelbrot", package="future", ask=FALSE)

message("*** Demos ... DONE")

source("incl/end.R")
