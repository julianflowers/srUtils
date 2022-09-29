## function to extract location coordinates

#' Get lat-longs
#'
#' @param text
#'
#' @return matrix
#' @export
#'
#' @examples
#' get_coordinates(text$text)
#'


get_coordinates <- function(text){

  require(tibble)
  require(dplyr)
  require(stringr)
  require(tidyr)

  colon <- "([NnSsEeWw])(\\d{1,2}):(\\d{1,2}):(\\d{1,2})"
  decimal <- "(\\d{1,2})\\.(\\d{1,2}).?(◦|°).?([NnSsEeWw])"
  polar_lat <- "(\\d{1,2})(◦|°|)\\s?(\\d{1,2})\\D*([NnSs])"
  polar_long <- "(\\d{1,2})(◦|°|)\\s?(\\d{1,3})\\D*([EeWw])"
  e_n <- "(\\d{4,6})\\D?([NnSs]).*(\\d{4,6})\\D?([EeWw])"

  colon_pattern <- str_match_all(text, colon) |>
    enframe()
  decimal_pattern <- str_match_all(text, decimal) |>
    enframe()

  polar_lat_pattern <- str_match_all(text, polar_lat) |>
    enframe()

  polar_long_pattern <- str_match_all(text, polar_long) |>
    enframe()

  e_n_pattern <- str_match_all(text, e_n) |>
    enframe()

  out <- bind_rows(c = colon_pattern, d = decimal_pattern, lat = polar_lat_pattern,
                          long = polar_long_pattern, en = e_n_pattern)
  out
}


