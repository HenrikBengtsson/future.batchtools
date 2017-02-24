## Restore original state
options(oopts)
future::plan(oplan)
rm(list=c(setdiff(ls(), ovars)))
