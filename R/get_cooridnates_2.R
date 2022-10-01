#' Get lat long
#'
#' @param text
#'
#' @return
#' @export
#'
#' @examples get_coordinates_2(text)
#'

get_coordinates_2 <- function(text){

  require(dplyr)
  require(pdftools)
  require(tibble)
  require(tidyr)
  require(stringi)
  require(stringr)

  pdf_text_unnest <- text |>
    unnest("value") |>
    unnest("value") |>
    group_by(name) |>
    mutate(id = row_number(),
           post_col = lead(text),
           post_col_1 = lead(post_col),
           pre_col = lag(text))

  coords <- pdf_text_unnest |>
    mutate(included = str_detect(text, paste0(stringi::stri_unescape_unicode("\\u00b0")))|
             str_detect(text, stringi::stri_unescape_unicode("\\u25e6"))|
             str_detect(text, stringi::stri_unescape_unicode("\\u2032"))|
             str_detect(text, "[NSEW]\\d{1,2}:\\d{1,2}:\\d{1,2}")
    ) |>
    filter(included == TRUE,
           !str_detect(text, "[C]"))

  coords <- coords |>
    # print(n = 500)
    #filter(name == 30) |>
    #glimpse() |>
    select(name, text, pre_col, post_col, post_col_1) |>
    mutate(coord = ifelse(!str_detect(text, "[NSEW]") & str_detect(post_col, "[NSEW]"),
                          paste0(text, post_col),
                          ifelse(!str_detect(text, "[NSEW]") & !str_detect(post_col, "[NSEW]") & str_detect(post_col_1, "[NSEW]"),
                                 paste0(text, post_col, post_col_1),
                                 ifelse(str_detect(pre_col, "\\d{1,2}\\.\\d{1,2}") & !str_detect(text, "\\d{1,}"),
                                        paste0(pre_col, text),
                                        ifelse(str_detect(pre_col, "\\d{1,2}\\.\\d{1,2}") & !str_detect(text, "\\d{1,}") & str_detect(text, stringi::stri_unescape_unicode("\\u00b0")),
                                               paste0(pre_col, text, post_col),
                                               ifelse(str_detect(text, stringi::stri_unescape_unicode("\\u25e6") ) & str_detect(post_col, "[NSEW]"),
                                                      paste0(pre_col, post_col),
                                                      text)))))) |>
    filter(!str_detect(post_col, "[C]"))

}

