python  <- "C:/Users/Julian/OneDrive/Documents/.virtualenvs/r-taxonerd/Scripts/python.exe"
#python <- 'C:/Users/Julian/AppData/Local/r-miniconda/envs/spacy_condaenv/python.exe'

## install packages
if(!require("taxonerd")) install.packages("https://github.com/nleguillarme/taxonerd/releases/download/v1.3.3/taxonerd_for_R_1.3.3.tar.gz", repos=NULL)

#vignette("taxonerd") # See vignette for more information on how to install and use TaxoNERD for R

## load packages
library(taxonerd)
require(tidyverse)


python <- python
cuda <- NULL

## set python to correct path
reticulate::use_python(python)

## install taxonerd python package (can omit cuda.version)
install.taxonerd(cuda.version = cuda)

## load language model
taxonerd::install.model(model = "en_ner_eco_biobert", version = "1.3.0")



## initialise named entity model (can have link = gbf_backbone, link = ncbi_lite)
linker <- "taxref"
ner <- init.taxonerd("en_ner_eco_biobert", abbrev = TRUE, sent = FALSE, link = linker, thresh = .7, gpu = TRUE)


## get some pdfs


## path-to-pdfs
path <- here::here("my_corpus")
pdfs <- list.files(path, "pdf$", full.names = TRUE)

## extract pdf text
p_df_text <- purrr::map_dfr(pdfs, readtext::readtext)

## parse for taxa (file 5)
taxa_file <- find.in.text(ner = ner, text = p_df_text$text[5])

taxa_file |>
  head()

## parse all files

taxa_df <- map2_dfr(.x = p_df_text$text, .y = p_df_text$doc_id, ~(find.in.text(ner, .x)) |> mutate(file = .y))

taxa <- taxa_df |>
  mutate(taxa1 = map(entity, ~unlist(unlist(.x)))) |>
  separate(taxa1, remove = TRUE, c("NCBI" , "taxa", "prob"), sep = ", ") |>
  select(-NCBI) |>
  mutate(prob = parse_number(prob))

taxa


