#' Get air temperature
#'
#' @param text
#'
#' @return character
#' @export
#'
#' @examples get_air_temperature(text)
#'

get_air_temperature <- function(text){

  require(tibble)
  require(dplyr)
  require(stringr)
  require(tidyr)
  require(stringi)

  at_pattern <- paste0("(\\d{1,}\\.?\\d{1,2}?)\\D*", "(", stringi::stri_unescape_unicode('\\u00b0'), "|", stringi::stri_unescape_unicode('\\u25e6'), "|", "degrees", ")", "(", ".?[C]", ")", "\\D*")
  at <- str_match_all(text, at_pattern) |>
    tibble::enframe()

}
