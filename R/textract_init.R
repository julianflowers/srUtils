#' Initialize text extraction
#'
#' @return
#' @export
#'
#' @examples textextract_initialize()

srutils_initialise <- function(){

  require(reticulate)

  virtualenv_create("srutils")
  Sys.setenv(RETICULATE_PYTHON = '/Users/julianflowers/.virtualenvs/srutils/bin/python')
  use_virtualenv("srutils")
  py_install(c("textract", "semanticscholar", "flair", "taxonerd"), pip = TRUE, envname = "srutils")

}
