#' @importFrom R.utils isDirectory mkdirs
#' @importFrom utils sessionInfo
future_cache_path <- local({
  ## The path used for this session
  path <- NULL

  function(root_path = ".future", absolute = TRUE, create = TRUE) {
    if (is.null(path)) {
      id <- basename(tempdir())
      id <- gsub("Rtmp", "", id, fixed = TRUE)
      timestamp <- format(Sys.time(), format = "%Y%m%d_%H%M%S")
      dir <- sprintf("%s-%s", timestamp, id)
      path_tmp <- file.path(root_path, dir)
      if (create && !isDirectory(path_tmp)) {
        mkdirs(path_tmp)
        pathname_tmp <- file.path(path_tmp, "sessioninfo.txt")
        writeLines(capture_output(print(sessionInfo())), con = pathname_tmp)
      }
      path <<- path_tmp
    }
    if (absolute) path <- file.path(getwd(), path)

    path
  }
})
