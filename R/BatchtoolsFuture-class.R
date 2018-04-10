#' A batchtools future is a future whose value will be resolved via batchtools
#'
#' @param expr The R expression to be evaluated
#'
#' @param envir The environment in which global environment
#' should be located.
#'
#' @param substitute Controls whether \code{expr} should be
#' \code{substitute()}:d or not.
#'
#' @param globals (optional) a logical, a character vector, a named list, or
#' a \link[globals]{Globals} object.  If TRUE, globals are identified by code
#' inspection based on \code{expr} and \code{tweak} searching from environment
#' \code{envir}.  If FALSE, no globals are used.  If a character vector, then
#' globals are identified by lookup based their names \code{globals} searching
#' from environment \code{envir}.  If a named list or a Globals object, the
#' globals are used as is.
#'
#' @param label (optional) Label of the future (where applicable, becomes the
#' job name for most job schedulers).
#'
#' @param conf A batchtools configuration environment.
#'
#' @param cluster.functions A batchtools \link[batchtools]{ClusterFunctions}
#' object.
#'
#' @param resources A named list passed to the batchtools template (available
#' as variable \code{resources}).
#'
#' @param workers (optional) The maximum number of workers the batchtools
#' backend may use at any time.   Interactive and "local" backends can only
#' process one future at the time, whereas HPC backends where futures are
#' resolved via separate jobs on a scheduler, the default is to assume an
#' infinite number of workers.
#'
#' @param finalize If TRUE, any underlying registries are
#' deleted when this object is garbage collected, otherwise not.
#'
#' @param \ldots Additional arguments passed to \code{\link[future]{Future}()}.
#'
#' @return A BatchtoolsFuture object
#'
#' @export
#' @importFrom future Future getGlobalsAndPackages
#' @importFrom batchtools submitJobs
#' @keywords internal
BatchtoolsFuture <- function(expr = NULL, envir = parent.frame(),
                             substitute = TRUE,
                             globals = TRUE, packages = NULL,
                             label = NULL, cluster.functions = NULL,
                             resources = list(), workers = NULL,
                             finalize = getOption("future.finalize", TRUE),
                             ...) {
  if (substitute) expr <- substitute(expr)

  if (!is.null(label)) label <- as.character(label)

  if (!is.null(cluster.functions)) {
    stop_if_not(is.list(cluster.functions))
  }

  if (!is.null(workers)) {
    stop_if_not(length(workers) >= 1)
    if (is.numeric(workers)) {
      stop_if_not(!anyNA(workers), all(workers >= 1))
    } else if (is.character(workers)) {
    } else {
      stop_if_not("Argument 'workers' should be either numeric or character: ",
                mode(workers))
    }
  }

  stop_if_not(is.list(resources))

  ## Record globals
  gp <- getGlobalsAndPackages(expr, envir = envir, globals = globals)

  future <- Future(expr = gp$expr, envir = envir, substitute = FALSE,
                   workers = workers, label = label, version = "1.8", ...)

  future$globals <- gp$globals
  future$packages <- unique(c(packages, gp$packages))

  ## Create batchtools registry
  reg <- temp_registry(label = future$label)
  if (!is.null(cluster.functions)) {    ### FIXME
    reg$cluster.functions <- cluster.functions
  }
  debug <- getOption("future.debug", FALSE)
  if (debug) mprint(reg)

  ## batchtools configuration
  config <- list(reg = reg, jobid = NA_integer_,
                 resources = resources)

  future$config <- config

  future <- structure(future, class = c("BatchtoolsFuture", class(future)))

  ## Register finalizer?
  if (finalize) future <- add_finalizer(future)

  future
}


#' Prints a batchtools future
#'
#' @param x An BatchtoolsFuture object
#' @param \ldots Not used.
#'
#' @export
#' @keywords internal
print.BatchtoolsFuture <- function(x, ...) {
  NextMethod("print")

  ## batchtools specific
  reg <- x$config$reg

  ## Type of batchtools future
  printf("batchtools cluster functions: %s\n",
         sQuote(reg$cluster.functions$name))

  ## Ask for status once
  status <- status(x)
  printf("batchtools status: %s\n", paste(sQuote(status), collapse = ", "))
  if ("error" %in% status) printf("Error: %s\n", loggedError(x))

  if (is_na(status)) {
    printf("batchtools %s: Not found (happens when finished and deleted)\n",
           class(reg))
  } else {
    printf("batchtools Registry:\n  ")
    print(reg)
    printf("  File dir exists: %s\n", file_test("-d", reg$file.dir))
    printf("  Work dir exists: %s\n", file_test("-d", reg$work.dir))
  }

  invisible(x)
}


status <- function(...) UseMethod("status")
finished <- function(...) UseMethod("finished")
loggedError <- function(...) UseMethod("loggedError")
loggedOutput <- function(...) UseMethod("loggedOutput")

#' Status of batchtools future
#'
#' @param future The future.
#' @param \ldots Not used.
#'
#' @return A character vector or a logical scalar.
#'
#' @aliases status finished value
#'          loggedError loggedOutput
#' @keywords internal
#'
#' @export
#' @export status
#' @export finished
#' @export value
#' @export loggedError
#' @export loggedOutput
#' @importFrom batchtools getStatus
status.BatchtoolsFuture <- function(future, ...) {
  ## WORKAROUND: Avoid warnings on partially matched arguments
  get_status <- function(...) {
    ## Temporarily disable batchtools output?
    ## (i.e. messages and progress bars)
    debug <- getOption("future.debug", FALSE)
    batchtools_output <- getOption("future.batchtools.output", debug)
    if (!batchtools_output) {
      oopts <- options(batchtools.verbose = FALSE, batchtools.progress = FALSE)
    } else {
      oopts <- list()
    }
    on.exit(options(oopts))
    batchtools::getStatus(...)
  } ## get_status()

  config <- future$config
  reg <- config$reg
  if (!inherits(reg, "Registry")) return(NA_character_)
  ## Closed and deleted?
  if (!file_test("-d", reg$file.dir)) return(NA_character_)

  jobid <- config$jobid
  if (is.na(jobid)) return("not submitted")
  status <- get_status(reg = reg, ids = jobid)
  status <- (unlist(status) == 1L)
  status <- status[status]
  status <- sort(names(status))
  status <- setdiff(status, c("n"))
  
  result <- future$result
  if (inherits(result, "FutureResult")) {
    condition <- result$condition
    if (inherits(condition, "error")) status <- c("error", status)
  }
  
  status
}


#' @export
#' @keywords internal
finished.BatchtoolsFuture <- function(future, ...) {
  status <- status(future)
  if (is_na(status)) return(NA)
  any(c("done", "error", "expired") %in% status)
}

#' @export
#' @keywords internal
loggedError.BatchtoolsFuture <- function(future, ...) {
  stat <- status(future)
  if (is_na(stat)) return(NULL)

  if (!finished(future)) {
    label <- future$label
    if (is.null(label)) label <- "<none>"
    msg <- sprintf("%s ('%s') has not finished yet", class(future)[1L], label)
    stop(BatchtoolsFutureError(msg, future = future))
  }

  if (!"error" %in% stat) return(NULL)

  config <- future$config
  reg <- config$reg
  jobid <- config$jobid
  res <- getErrorMessages(reg = reg, ids = jobid)  ### CHECKED
  msg <- res$message
  msg <- paste(sQuote(msg), collapse = ", ")
  msg
} # loggedError()


#' @importFrom batchtools getLog
#' @export
#' @keywords internal
loggedOutput.BatchtoolsFuture <- function(future, ...) {
  stat <- status(future)
  if (is_na(stat)) return(NULL)

  if (!finished(future)) {
    label <- future$label
    if (is.null(label)) label <- "<none>"
    msg <- sprintf("%s ('%s') has not finished yet", class(future)[1L], label)
    stop(BatchtoolsFutureError(msg, future = future))
  }

  config <- future$config
  reg <- config$reg
  jobid <- config$jobid
  getLog(id = jobid, reg = reg)
} # loggedOutput()


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Future API
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#' @importFrom future resolved
#' @export
#' @keywords internal
resolved.BatchtoolsFuture <- function(x, ...) {
  ## Has internal future state already been switched to be resolved
  resolved <- NextMethod("resolved")
  if (resolved) return(TRUE)

  ## If not, checks the batchtools registry status
  resolved <- finished(x)
  if (is.na(resolved)) return(FALSE)

  resolved
}

#' @importFrom future value
#' @export
#' @keywords internal
value.BatchtoolsFuture <- function(future, signal = TRUE,
                                   onMissing = c("default", "error"),
                                   default = NULL, cleanup = TRUE, ...) {
  ## Has the value already been collected?
  if (future$state %in% c("done", "failed", "interrupted")) {
    return(NextMethod("value"))
  }

  if (future$state == "created") {
    future <- run(future)
  }

  stat <- status(future)
  if (is_na(stat)) {
    onMissing <- match.arg(onMissing)
    if (onMissing == "default") return(default)
    label <- future$label
    if (is.null(label)) label <- "<none>"
    stop(sprintf("The value no longer exists (or never existed) for Future ('%s') of class %s", label, paste(sQuote(class(future)), collapse = ", "))) #nolint
  }

  result <- await(future, cleanup = FALSE)
  stop_if_not(inherits(result, "FutureResult"))
  future$result <- result
  future$state <- "finished"
  if (cleanup) delete(future, ...)

  NextMethod("value")
} # value()



run <- function(...) UseMethod("run")

#' @importFrom future getExpression
#' @importFrom batchtools batchExport batchMap saveRegistry setJobNames
run.BatchtoolsFuture <- function(future, ...) {
  if (future$state != "created") {
    label <- future$label
    if (is.null(label)) label <- "<none>"
    stop(sprintf("A future ('%s') can only be launched once.", label))
  }

  mdebug <- import_future("mdebug")

  ## Assert that the process that created the future is
  ## also the one that evaluates/resolves/queries it.
  assertOwner <- import_future("assertOwner")
  assertOwner(future)

  ## Temporarily disable batchtools output?
  ## (i.e. messages and progress bars)
  debug <- getOption("future.debug", FALSE)
  batchtools_output <- getOption("future.batchtools.output", debug)
  if (!batchtools_output) {
    oopts <- options(batchtools.verbose = FALSE, batchtools.progress = FALSE)
  } else {
    oopts <- list()
  }
  on.exit(options(oopts))

  expr <- getExpression(future)

  ## Always evaluate in local environment
  expr <- substitute(local(expr), list(expr = expr))

  reg <- future$config$reg
  stop_if_not(inherits(reg, "Registry"))

  ## (ii) Attach packages that needs to be attached
  packages <- future$packages
  if (length(packages) > 0) {
    mdebug("Attaching %d packages (%s) ...",
                    length(packages), hpaste(sQuote(packages)))

    ## Record which packages in 'pkgs' that are loaded and
    ## which of them are attached (at this point in time).
    is_loaded <- is.element(packages, loadedNamespaces())
    is_attached <- is.element(packages, attached_packages())

    ## FIXME: Update the expression such that the new session
    ## will have the same state of (loaded, attached) packages.

    reg$packages <- packages
    saveRegistry(reg = reg)

    mdebug("Attaching %d packages (%s) ... DONE",
                    length(packages), hpaste(sQuote(packages)))
  }
  ## Not needed anymore
  packages <- NULL

  ## (iii) Export globals?
  if (length(future$globals) > 0) {
    batchExport(export = future$globals, reg = reg)
  }

  ## 1. Add to batchtools for evaluation
  mdebug("batchtools::batchMap()")
  jobid <- batchMap(fun = geval, list(expr),
                    more.args = list(substitute = TRUE), reg = reg)

  ## 1b. Set job name, if specified
  label <- future$label
  if (!is.null(label)) {
    setJobNames(ids = jobid, names = label, reg = reg)
  }
  
  ## 2. Update
  future$config$jobid <- jobid
  mdebug("Created %s future #%d", class(future)[1], jobid$job.id)

  ## WORKAROUND: (For multicore and OS X only)
  if (reg$cluster.functions$name == "Multicore") {
    ## On some OS X systems, a system call to 'ps' may output an error message
    ## "dyld: DYLD_ environment variables being ignored because main executable
    ##  (/bin/ps) is setuid or setgid" to standard error that is picked up by
    ## batchtools which incorrectly tries to parse it.  By unsetting all DYLD_*
    ## environment variables, we avoid this message.  For more info, see:
    ## * https://github.com/tudo-r/BatchJobs/issues/117
    ## * https://github.com/HenrikBengtsson/future.BatchJobs/issues/59
    ## /HB 2016-05-07
    dyld_envs <- tryCatch({
      envs <- list()
      res <- system2("ps", stdout = TRUE, stderr = TRUE)
      if (any(grepl("DYLD_", res))) {
        envs <- Sys.getenv()
        envs <- envs[grepl("^DYLD_", names(envs))]
        if (length(envs) > 0L) lapply(names(envs), FUN = Sys.unsetenv)
      }
      envs
    }, error = function(ex) list())
  }

  ## 3. Submit
  future$state <- "running"
  resources <- future$config$resources
  if (is.null(resources)) resources <- list()

  batchtools::submitJobs(reg = reg, ids = jobid, resources = resources)

  mdebug("Launched future #%d", jobid$job.id)

  invisible(future)
} ## run()


await <- function(...) UseMethod("await")

#' Awaits the value of a batchtools future
#'
#' @param future The future.
#' @param cleanup If TRUE, the registry is completely removed upon
#' success, otherwise not.
#' @param timeout Total time (in seconds) waiting before generating an error.
#' @param delta The number of seconds to wait between each poll.
#' @param alpha A factor to scale up the waiting time in each iteration such
#' that the waiting time in the k:th iteration is \code{alpha ^ k * delta}.
#' @param \ldots Not used.
#'
#' @return The value of the evaluated expression.
#' If an error occurs, an informative Exception is thrown.
#'
#' @details
#' Note that \code{await()} should only be called once, because
#' after being called the actual asynchronous future may be removed
#' and will no longer available in subsequent calls.  If called
#' again, an error may be thrown.
#'
#' @export
#' @importFrom batchtools getErrorMessages loadResult waitForJobs
#' @importFrom utils tail
#' @keywords internal
await.BatchtoolsFuture <- function(future, cleanup = TRUE,
                                   timeout = getOption("future.wait.timeout",
                                                       30 * 24 * 60 * 60),
                                   delta = getOption("future.wait.interval",
                                                     1.0),
                                   alpha = getOption("future.wait.alpha", 1.01),
                                   ...) {
  mdebug <- import_future("mdebug")
  stop_if_not(is.finite(timeout), timeout >= 0)
  stop_if_not(is.finite(alpha), alpha > 0)
  
  debug <- getOption("future.debug", FALSE)

  expr <- future$expr
  config <- future$config
  reg <- config$reg
  jobid <- config$jobid

  mdebug("batchtools::waitForJobs() ...")

  ## Control batchtools info output
  oopts <- options(batchtools.verbose = debug)
  on.exit(options(oopts))

  ## Sleep function - increases geometrically as a function of iterations
  sleep_fcn <- function(i) delta * alpha ^ (i - 1)
 
  res <- waitForJobs(ids = jobid, timeout = timeout, sleep = sleep_fcn,
                     stop.on.error = FALSE, reg = reg)
  mdebug("- batchtools::waitForJobs(): %s", res)
  stat <- status(future)
  mdebug("- status(): %s", paste(sQuote(stat), collapse = ", "))
  mdebug("batchtools::waitForJobs() ... done")

  finished <- is_na(stat) || any(c("done", "error", "expired") %in% stat)

  res <- NULL
  if (finished) {
    mdebug("Results:")
    label <- future$label
    if (is.null(label)) label <- "<none>"
    if ("done" %in% stat) {
      res <- loadResult(reg = reg, id = jobid)
      if (inherits(res, "FutureResult")) {
        if (inherits(res$condition, "error")) {
          cleanup <- FALSE
        }
      }
    } else if ("error" %in% stat) {
      cleanup <- FALSE
      msg <- sprintf("BatchtoolsError in %s ('%s'): %s",
                     class(future)[1], label, loggedError(future))
      stop(BatchtoolsFutureError(msg, future = future,
                                 output = loggedOutput(future)))
    } else if ("expired" %in% stat) {
      cleanup <- FALSE
      msg <- sprintf("BatchtoolsExpiration: Future ('%s') expired (registry path %s).", label, reg$file.dir)
      output <- loggedOutput(future)
      hint <- unlist(strsplit(output, split = "\n", fixed = TRUE))
      hint <- hint[nzchar(hint)]
      hint <- tail(hint, n = 6L)
      if (length(hint) > 0) {
        hint <- paste(hint, collapse = "\n")
        msg <- sprintf("%s. The last few lines of the logged output:\n%s",
                       msg, hint)
      } else {
        msg <- sprintf("%s. No logged output exist.", msg)
      }
      stop(BatchtoolsFutureError(msg, future = future, output = output))
    } else if (is_na(stat)) {
      msg <- sprintf("BatchtoolsDeleted: Cannot retrieve value. Future ('%s') deleted: %s", label, reg$file.dir) #nolint
      stop(BatchtoolsFutureError(msg, future = future))
    }
    if (debug) { mstr(res) }
  } else {
    cleanup <- FALSE
    msg <- sprintf("AsyncNotReadyError: Polled for results for %s seconds every %g seconds, but asynchronous evaluation for future ('%s') is still running: %s", timeout, delta, label, reg$file.dir) #nolint
    stop(BatchtoolsFutureError(msg, future = future))
  }

  ## Cleanup?
  if (cleanup) {
    delete(future, delta = 0.5 * delta, ...)
  }

  res
} # await()


delete <- function(...) UseMethod("delete")

#' Removes a batchtools future
#'
#' @param future The future.
#' @param onRunning Action if future is running or appears to run.
#' @param onFailure Action if failing to delete future.
#' @param onMissing Action if future does not exist.
#' @param times The number of tries before giving up.
#' @param delta The delay interval (in seconds) between retries.
#' @param alpha A multiplicative penalty increasing the delay
#' for each failed try.
#' @param \ldots Not used.
#'
#' @return (invisibly) TRUE if deleted and FALSE otherwise.
#'
#' @export
#' @importFrom batchtools clearRegistry removeRegistry
#' @importFrom utils file_test
#' @keywords internal
delete.BatchtoolsFuture <- function(future,
                                onRunning = c("warning", "error", "skip"),
                                onFailure = c("error", "warning", "ignore"),
                                onMissing = c("ignore", "warning", "error"),
                                times = 10L,
                                delta = getOption("future.wait.interval", 1.0),
                                alpha = getOption("future.wait.alpha", 1.01),
                                ...) {
  mdebug <- import_future("mdebug")

  onRunning <- match.arg(onRunning)
  onMissing <- match.arg(onMissing)
  onFailure <- match.arg(onFailure)

  debug <- getOption("future.debug", FALSE)

  ## Identify registry
  config <- future$config
  reg <- config$reg
  path <- reg$file.dir

  ## Already deleted?
  if (is.null(path) || !file_test("-d", path)) {
    if (onMissing %in% c("warning", "error")) {
      msg <- sprintf("Cannot remove batchtools registry, because directory does not exist: %s", sQuote(path)) #nolint
      mdebug("delete(): %s", msg)
      if (onMissing == "warning") {
        warning(msg)
      } else if (onMissing == "error") {
        stop(BatchtoolsFutureError(msg, future = future))
      }
    }
    return(invisible(TRUE))
  }


  ## Is the future still not resolved?  If so, then...
  if (!resolved(future)) {
    if (onRunning == "skip") return(invisible(TRUE))
    status <- status(future)
    label <- future$label
    if (is.null(label)) label <- "<none>"
    msg <- sprintf("Will not remove batchtools registry, because is appears to hold a non-resolved future (%s; state = %s; batchtools status = %s): %s", sQuote(label), sQuote(future$state), paste(sQuote(status), collapse = ", "), sQuote(path)) #nolint
    mdebug("delete(): %s", msg)
    if (onRunning == "warning") {
      warning(msg)
      return(invisible(TRUE))
    } else if (onRunning == "error") {
      stop(BatchtoolsFutureError(msg, future = future))
    }
  }

  ## FIXME: Make sure to collect the results before deleting
  ## the internal batchtools registry
  result <- future$result
  if (is.null(result)) {
    value(future, signal = FALSE)
    result <- future$result
  }
  stop_if_not(inherits(result, "FutureResult"))

  ## To simplify post mortem troubleshooting in non-interactive sessions,
  ## should the batchtools registry files be removed or not?
  mdebug("delete(): Option 'future.delete = %s",
         sQuote(getOption("future.delete", "<NULL>")))
  if (!getOption("future.delete", interactive())) {
    status <- status(future)
    res <- future$result
    if (inherits(res, "FutureResult")) {
      if (inherits(res$condition, "error")) status <- "error"
    }
    mdebug("delete(): status(<future>) = %s",
           paste(sQuote(status), collapse = ", "))
    if (any(c("error", "expired") %in% status)) {
      msg <- sprintf("Will not remove batchtools registry, because the status of the batchtools was %s and option 'future.delete' is FALSE or running in an interactive session: %s", paste(sQuote(status), collapse = ", "), sQuote(path)) #nolint
      mdebug("delete(): %s", msg)
      warning(msg)
      return(invisible(FALSE))
    }
  }

  ## Control batchtools info output
  oopts <- options(batchtools.verbose = debug)
  on.exit(options(oopts))

  ## Try to delete registry
  interval <- delta
  for (kk in seq_len(times)) {
    try(clearRegistry(reg = reg), silent = TRUE)
    try(removeRegistry(wait = 0.0, reg = reg), silent = FALSE)
    if (!file_test("-d", path)) break
    Sys.sleep(interval)
    interval <- alpha * interval
  }


  ## Success?
  if (file_test("-d", path)) {
    if (onFailure %in% c("warning", "error")) {
      msg <- sprintf("Failed to remove batchtools registry: %s", sQuote(path))
      mdebug("delete(): %s", msg)
      if (onMissing == "warning") {
        warning(msg)
      } else if (onMissing == "error") {
        stop(BatchtoolsFutureError(msg, future = future))
      }
    }
    return(invisible(FALSE))
  }

  mdebug("delete(): batchtools registry deleted: %s", sQuote(path))

  invisible(TRUE)
} # delete()


add_finalizer <- function(...) UseMethod("add_finalizer")

add_finalizer.BatchtoolsFuture <- function(future, ...) {
  ## Register finalizer (will clean up registries etc.)

  reg.finalizer(future, f = function(gcenv) {
    if (inherits(future, "BatchtoolsFuture") &&
        "future.batchtools" %in% loadedNamespaces()) {
      try({
        delete(future, onRunning = "skip", onMissing = "ignore",
               onFailure = "warning")
      })
    }
  }, onexit = TRUE)

  invisible(future)
}
