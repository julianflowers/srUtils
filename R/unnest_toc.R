#' Unnest table of contents
#'
#' @param files
#'
#' @return
#' @export
#'
#' @examples
unnest_toc <- function(files){

  require(purrr)
  require(tibble)
  require(dplyr)
  require(pdftools)

  text <- pdf_toc(files)
  title <- text$children[[1]]$title
  heads <- text$children[[1]]$children |>
    purrr::map("title")
  subheads <- text$children[[1]]$children |>
    purrr::map("children") |>
    purrr::flatten() |>
    purrr::map_chr("title")

  a <- title |> enframe() |>
    mutate_at(.vars = "value",  as.character)
  b <- heads |> enframe()
  c <- subheads |> enframe() |>
    mutate_at(.vars = "value",  as.character)

  df <- data.frame(a, c)

  tibble(df)
}
