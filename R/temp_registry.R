#' @importFrom batchtools makeRegistry
temp_registry <- local({
  ## All known batchtools registries
  regs <- new.env()

  make_registry <- function(...) {
    ## Temporarily disable batchtools output?
    ## (i.e. messages and progress bars)
    debug <- getOption("future.debug", FALSE)
    batchtools_output <- getOption("future.batchtools.output", debug)

    if (!batchtools_output) {
      oopts <- options(batchtools.verbose = FALSE, batchtools.progress = FALSE)
      on.exit(options(oopts))
    }

    batchtools::makeRegistry(...)
  } ## make_registry()

  function(label = "batchtools", path = NULL, ...) {
    if (is.null(label)) label <- "batchtools"
    ## The job label (the name on the job queue) - may be duplicated
    label <- as.character(label)
    stop_if_not(length(label) == 1L, nchar(label) > 0L)

    ## This session's path holding all of its future batchtools directories
    ##   e.g. .future/<datetimestamp>-<unique_id>/
    if (is.null(path)) path <- future_cache_path()

    ## The batchtools subfolder for a specific future - must be unique
    prefix <- sprintf("%s_", label)

    ## FIXME: We need to make sure 'prefix' consists of only valid
    ## filename characters. /HB 2016-10-19
    prefix <- as_valid_directory_prefix(prefix)

    unique <- FALSE
    while (!unique) {
      ## The FutureRegistry key for this batchtools future - must be unique
      key <- tempvar(prefix = prefix, value = NA, envir = regs)
      ## The directory for this batchtools future
      ##   e.g. .future/<datetimestamp>-<unique_id>/<key>/
      path_registry <- file.path(path, key)
      ## Should not happen, but just in case.
      unique <- !file.exists(path_registry)
    }

    ## FIXME: We need to make sure 'label' consists of only valid
    ## batchtools ID characters, i.e. it must match regular
    ## expression "^[a-zA-Z]+[0-9a-zA-Z_]*$".
    ## /HB 2016-10-19
    reg_id <- as_valid_registry_id(label)
    make_registry(file.dir = path_registry, ...)
  }
})



drop_non_valid_characters <- function(name, pattern, default = "batchtools") {
  as_string <- (length(name) == 1L)
  name <- unlist(strsplit(name, split = "", fixed = TRUE), use.names = FALSE)
  name[!grepl(pattern, name)] <- ""
  if (length(name) == 0L) return(default)
  if (as_string) name <- paste(name, collapse = "")
  name
}

as_valid_directory_prefix <- function(name) {
  pattern <- "^[-._a-zA-Z0-9]+$"
  ## Nothing to do?
  if (grepl(pattern, name)) return(name)
  name <- unlist(strsplit(name, split = "", fixed = TRUE), use.names = FALSE)
  ## All characters must be letters, digits, underscores, dash, or period.
  name <- drop_non_valid_characters(name, pattern = pattern)
  name <- paste(name, collapse = "")
  stop_if_not(grepl(pattern, name))
  name
}

as_valid_registry_id <- function(name) {
  pattern <- "^[a-zA-Z]+[0-9a-zA-Z_]*$"
  ## Nothing to do?
  if (grepl(pattern, name)) return(name)

  name <- unlist(strsplit(name, split = "", fixed = TRUE), use.names = FALSE)

  ## All characters must be letters, digits, or underscores
  name <- drop_non_valid_characters(name, pattern = "[0-9a-zA-Z_]")
  name <- name[nzchar(name)]

  ## First character must be a letter :/
  if (!grepl("^[a-zA-Z]+", name[1])) name[1] <- "z"

  name <- paste(name, collapse = "")

  stop_if_not(grepl(pattern, name))

  name
}
