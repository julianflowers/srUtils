library(spacyr); library(tidyverse)
reticulate::use_python('C:\Users\Julian\AppData\Local\r-miniconda\envs\spacy_condaenv/python.exe')
spacy_download_langmodel()
spacy_install()

p_df_text

parse_text <- spacyr::spacy_parse(pdf_text$text)

p <- entity_extract(parse_text) |>
  tibble::tibble()

p %>%
  #str()
  filter(entity_type %in% c("GPE", "LOC"))
