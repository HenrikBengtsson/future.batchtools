#' @importFrom utils file_test sessionInfo
future_cache_path <- local({
  ## The subfolder used for this session
  dir <- NULL

  function(root_path = getOption("future.cache.path", ".future"), absolute = TRUE, create = TRUE) {
    if (is.null(dir)) {
      id <- basename(tempdir())
      id <- gsub("Rtmp", "", id, fixed = TRUE)
      timestamp <- format(Sys.time(), format = "%Y%m%d_%H%M%S")
      dir <<- sprintf("%s-%s", timestamp, id)
    }
    
    path <- file.path(root_path, dir)
    if (create && !file_test("-d", path)) {
      dir.create(path, recursive = TRUE)
      pathname <- file.path(path, "sessioninfo.txt")
      writeLines(capture_output(print(sessionInfo())), con = pathname)
    }

    if (absolute) path <- normalizePath(path, mustWork = FALSE)

    path
  }
})
