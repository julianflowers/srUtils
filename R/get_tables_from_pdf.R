#' Tables from pdfs
#' Extracts tqbles from pdf files using the tabula-py Python package
#'
#' @param pdf 
#'
#' @return list
#' @export
#'
#' @examples tables_from_pdfs

tables_from_pdfs <- function(pdf){
  
  library(reticulate); library(tidyverse)
  py_install("tabula-py", pip = TRUE)
  
  tabula <- import("tabula")
  pd <- import("pandas", as = "pd")
  import("os")
  
  tables <- tabula$read_pdf(pdf, stream = TRUE, pages = "all" )
  tables
}

