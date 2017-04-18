#' @importFrom R.utils removeDirectory isFile
.onUnload <- function(libpath) {
  ## (a) Force finalizer of Future objects to run such
  ##     that their batchtools directories are removed
  gc()

  ## (b) Remove batchtools root directory if only a set
  ##     of known files exists, i.e. not any directories etc.
  path <- futureCachePath(create = FALSE)
  ## Only known files left?
  files <- dir(path = path)
  known_files <- c("sessioninfo.txt")
  if (all(files %in% known_files)) {
    for (file in known_files) {
      pathname_tmp <- file.path(path, file)
      if (isFile(pathname_tmp)) try(file.remove(pathname_tmp))
    }
    try(removeDirectory(path, recursive = FALSE, mustExist = FALSE),
        silent = TRUE)
  }
}
