BatchtoolsSSHRegistry <- local({
  last <- NULL
  cluster <- NULL
  
  function(action = c("get", "start", "stop"), workers = NULL, makeCluster = .makeCluster, ...) {
    action <- match.arg(action, choices = c("get", "start", "stop"))

    if (is.null(workers)) {
    } else if (is.numeric(workers)) {
      workers <- as.integer(workers)
      stop_if_not(length(workers) == 1, !is.na(workers), is.finite(workers))
    } else if (is.character(workers)) {
      stop_if_not(length(workers) >= 1, !anyNA(workers))
      workers <- sort(workers)
    } else {
      stopf("Unknown mode of argument 'workers': %s", mode(workers))
    }

    if (length(cluster) == 0L && action != "stop") {
      cluster <<- makeCluster(workers, ...)
      last <<- workers
    }

    if (action == "get") {
      return(cluster)
    } else if (action == "start") {
      ## Already setup?
      if (!identical(workers, last)) {
        BatchtoolsSSHRegistry(action = "stop")
        cluster <<- makeCluster(workers, ...)
        last <<- workers
      }
    } else if (action == "stop") {
      cluster <<- NULL
      last <<- NULL
    }

    invisible(cluster)
  }
}) ## BatchtoolsSSHRegistry()


#' @importFrom batchtools Worker
.makeCluster <- function(workers, ...) {
  if (is.numeric(workers)) {
    stop_if_not(length(workers) == 1L, !is.na(workers), is.finite(workers), workers >= 1)
    workers <- rep("localhost", times = workers)
  }
  if (length(workers) == 0L) return(NULL)
  ncpus <- table(workers)

  mapply(names(ncpus), ncpus, FUN = function(hostname, ncpus) {
    Worker$new(hostname, ncpus = ncpus)
  })
}
