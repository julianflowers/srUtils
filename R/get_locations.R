library(spacyr); library(tidyverse)
#reticulate::use_python("C:/Users/Julian/OneDrive/Documents/.virtualenvs/r-taxonerd/Scripts/python.exe")
spacy_download_langmodel()
spacy_install()

p_df_text

parse_text <- spacyr::spacy_parse(p_df_text$text[4])

p <- entity_extract(parse_text) |>
  tibble::tibble()

p %>%
  #str()
  filter(entity_type %in% c("GPE", "LOC"))
