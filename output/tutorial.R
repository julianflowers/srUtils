devtools::install_github("julianflowers/srUtils")
library(srUtils);library(tidyverse)

  
path <- here::here("G:\\My Drive\\my_corpus\\uploads")
pdfs <- list.files(path, "pdf$", full.names = TRUE)
pdfs_1 <- pdfs |>
  tibble::enframe() |>
  filter(!str_detect(value, "_00.*pdf$"))

pdf_list <- pluck(pdfs_1, "value")

pdf_text <- map_dfr(pdf_list, readtext::readtext)

n <- 10

x <- pdf_text[n,2] |>
  str_squish()

srUtils::unnest_toc(pdf_list[n])
a <- srUtils::get_air_temperature(x)
a |>
  unnest("value")

b <- srUtils::extract_location(x)
b |>
  unnest("value") |>
  unnest("value")

c <- srUtils::get_coordinates(x)

c$lat.value
c$long.value



d <- srUtils::get_elevation(x)
d |>
  unnest("value")

e <- srUtils::get_chemical(x)
e |>
  unnest("value") |>
  distinct()
