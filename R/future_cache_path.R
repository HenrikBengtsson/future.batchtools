#' @importFrom utils file_test sessionInfo
future_cache_path <- local({
  ## The path used for this session
  path <- NULL

  function(root_path = Sys.getenv("R_FUTURE_CACHE_PATH", ".future"), absolute = TRUE, create = TRUE) {
    if (is.null(path)) {
      id <- basename(tempdir())
      id <- gsub("Rtmp", "", id, fixed = TRUE)
      timestamp <- format(Sys.time(), format = "%Y%m%d_%H%M%S")
      dir <- sprintf("%s-%s", timestamp, id)
      path_tmp <- file.path(root_path, dir)
      if (create && !file_test("-d", path_tmp)) {
        dir.create(path_tmp, recursive = TRUE)
        pathname_tmp <- file.path(path_tmp, "sessioninfo.txt")
        writeLines(capture_output(print(sessionInfo())), con = pathname_tmp)
      }
      path <<- path_tmp
    }
    if (absolute) path <- normalizePath(path, mustWork = FALSE)

    path
  }
})
