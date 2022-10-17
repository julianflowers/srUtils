#' Initialize text extraction
#'
#' @return
#' @export
#'
#' @examples textextract_initialize()

textextract_initialize <- function(){

  require(reticulate)

  py_install("textract", pip = TRUE)

}
