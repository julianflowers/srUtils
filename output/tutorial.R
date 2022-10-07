remotes::install_github("julianflowers/srUtils", force = TRUE)
remove.packages("srUtils")
library(srUtils);library(tidyverse)

  
path <- here::here("G:\\My Drive\\my_corpus\\uploads")
path
pdfs <- list.files(path, "pdf$", full.names = TRUE)
pdfs
pdfs_1 <- pdfs |>
  tibble::enframe() |>
  filter(!str_detect(value, "_00.*pdf$"))
pdfs_1

pdf_list <- pluck(pdfs_1, "value")

pdf_text <- pdfs_1 |>
  mutate(text = map(value, readtext::readtext))

spacy_download_langmodel(model = "https://github.com/nleguillarme/taxonerd/releases/download/v1.4.0/en_core_eco_biobert-1.0.2.tar.gz")
spacy_finalize()

spacy_initialize(model = "https://github.com/nleguillarme/taxonerd/releases/download/v1.4.0/en_core_eco_biobert-1.0.2.tar.gz
library(spacyr)
pdf_text |>
  unnest_wider("text")|>
  slice(1:20) |>
  mutate(sp = map(text, ~(entity_consolidate(spacy_parse(.x))))) |>
  select(-text) |>
  unnest("sp", names_repair = "universal") |>
  filter(pos== "ENTITY" & entity_type %in% c("GPE", "LOC", "NORP")) |>
  #head() |>
  gt::gt()


n <- 80
  
x <- pdf_text[n,2] |>
  str_squish()

srUtils::unnest_toc()

srUtils::unnest_toc(pdf_list[n])

a <- srUtils::get_air_temperature(x)
a
a |>
  unnest("value")

b <- srUtils::extract_location(x)
b |>
  unnest("value") |>
  unnest("value")

c <- srUtils::get_coordinates(x)

c$lat.value
c$long.value
c$d.value
c$en.value

d <- srUtils::get_elevation(x)
d |>
  unnest("value")

e <- srUtils::get_chemical(x)
e |>
  unnest("value") |>
  distinct()
