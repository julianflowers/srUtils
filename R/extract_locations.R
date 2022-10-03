#' Extract locations from text (simple version)
#'
#' @param text
#'
#' @return list
#' @export
#'
#' @examples extract_location(text)

extract_location <- function(text){

  if (!require("pacman")) install.packages("pacman")
  pacman::p_load_gh("trinker/entity")
  require(dplyr)
  require(tidyr)

  text |>
    mutate(loc = map(value, location_entity)) |>
    unnest("loc") |>
    unnest_auto("loc")

}
