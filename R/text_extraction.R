
#' Extract text
#' A wrapper for the python function `textract`
#'
#' @param file
#'
#' @return
#' @export
#'
#' @examples textextract(file)
textextract <- function(file){

  require(reticulate)
  txtrct <- reticulate::import("textract")

  text <- txtrct$process(file)

  out <- as.character(py_to_r(text))

  out <- list(out = out)
}



