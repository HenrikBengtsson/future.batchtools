include .make/Makefile

future.tests/%:
	$(R_SCRIPT) -e "future.tests::check" --args --test-plan=$*

future.tests: future.tests/future.batchtools\:\:batchtools_local
