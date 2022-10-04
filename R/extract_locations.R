#' Extract locations from text (simple version)
#'
#' @param text
#'
#' @return list
#' @export
#'
#' @examples extract_location(text)

extract_location <- function(text){

  options(java.parameters = c("-XX:+UseConcMarkSweepGC", "-Xmx8192m"))
  gc()  ## https://stackoverflow.com/questions/34624002/r-error-java-lang-outofmemoryerror-java-heap-space

  if (!require("pacman")) install.packages("pacman")
  pacman::p_load_gh("trinker/entity")
  require(dplyr)
  require(tidyr)
  require(purrr)
  require(tictoc)
  require(tibble)

  tic()

  safe_loc <- purrr::safely(location_entity)

  locs <- safe_loc(text) %>%
    .["result"] |>
    tibble::enframe()

  toc()

  locs

}


