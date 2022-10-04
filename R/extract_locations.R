#' Extract locations from text (simple version)
#'
#' @param text
#'
#' @return list
#' @export
#'
#' @examples extract_location(text)

extract_location <- function(text, doc_id){

  options(java.parameters = c("-XX:+UseConcMarkSweepGC", "-Xmx8192m"))
  gc()  ## https://stackoverflow.com/questions/34624002/r-error-java-lang-outofmemoryerror-java-heap-space

  if (!require("pacman")) install.packages("pacman")
  pacman::p_load_gh("trinker/entity")
  require(dplyr)
  require(tidyr)
  require(purrr)
  require(tictoc)

  tic()

  safe_loc <- purrr::safely(location_entity)

  locs <- safe_loc(text) %>%
    .["result"] |>
    enframe() |>
    mutate(file = doc_id)

  toc()

  locs

}

# rte$text[1]
# t <- map2_df(rte$text, rte$doc_id, extract_location)
# t |>
#   filter(value != "NULL") |>
#   unnest("value") |>
#   filter(value != "NULL") |>
#   unnest("value")
#
# location_entity(rte$text[2])
