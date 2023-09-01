#' Initialise srutils environment
#'
#' This function creates a Python virtual environment named 'srutils' and installs the required Python packages using pip.
#' It also sets the RETICULATE_PYTHON environment variable to point to the Python binary within the virtual environment.
#' @import reticulate
#' @importFrom reticulate virtualenv_create use_virtualenv py_install
#' @export

srutils_initialise <- function(){

  require(reticulate)


  virtualenv_remove("srUtils")

  virtualenv_create("srUtils")
  Sys.setenv(RETICULATE_PYTHON = '/Users/julianflowers/.virtualenvs/srUtils/bin/python')
  use_virtualenv("srUtils")
  py_install(c("textract", "semanticscholar", "flair", "PyPDF2"), pip = TRUE, envname = "srutils")

  ss <- import("semanticscholar")
  te <- import("textract")
  flair <- import("flair")
  pdfreader <- import("PyPDF2")
  pdfreader <- pdfreader$PdfReader
  biotagger <- flair$nn$Classifier$load("bioner") ## best model
  fast_tag <- flair$nn$Classifier$load("ner-fast") ## fastest model
  Sentence <- flair$data$Sentence
  splitter <- flair$splitter$SegtokSentenceSplitter


}
