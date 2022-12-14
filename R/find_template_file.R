#' @importFrom batchtools findTemplateFile
#' @importFrom utils file_test
find_template_file <- function(template) {
  pathname <- findTemplateFile(template)
  if (is.na(pathname)) {
    pathname <- system.file("templates", sprintf("%s.tmpl", template),
                            package = .packageName)
    if (!file_test("-f", pathname)) pathname <- NA_character_
  }
  if (is.na(pathname)) {
    stopf("Failed to locate a batchtools template file: *%s.tmpl", template)
  }
  pathname
}
