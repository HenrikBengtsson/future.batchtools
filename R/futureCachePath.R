#' @importFrom R.utils isDirectory mkdirs
#' @importFrom utils sessionInfo
futureCachePath <- local({
  ## The path used for this session
  path <- NULL

  function(rootPath=".future", absolute=TRUE, create=TRUE) {
    if (is.null(path)) {
      id <- basename(tempdir())
      id <- gsub("Rtmp", "", id, fixed=TRUE)
      timestamp <- format(Sys.time(), format="%Y%m%d_%H%M%S")
      dir <- sprintf("%s-%s", timestamp, id)
      pathT <- file.path(rootPath, dir)
      if (create && !isDirectory(pathT)) {
        mkdirs(pathT)
        pathnameT <- file.path(pathT, "sessioninfo.txt")
        writeLines(captureOutput(print(sessionInfo())), con=pathnameT)
      }
      path <<- pathT
    }
    if (absolute) path <- file.path(getwd(), path)

    path
  }
})
