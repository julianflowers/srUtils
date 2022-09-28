
## install packages
if(!require("taxonerd")) install.packages("https://github.com/nleguillarme/taxonerd/releases/download/v1.3.3/taxonerd_for_R_1.3.3.tar.gz", repos=NULL)

#vignette("taxonerd") # See vignette for more information on how to install and use TaxoNERD for R

## load packages
library(taxonerd)
require(tidyverse)


## set python to correct path
#reticulate::use_python("C:/Users/Julian/OneDrive/Documents/.virtualenvs/r-taxonerd/Scripts/python.exe")

## install taxonerd python package (can omit cuda.version)
install.taxonerd(cuda.version = "cuda112")

## load language model
taxonerd::install.model(model = "en_ner_eco_biobert", version = "1.3.0")



## initialise named entity model (can have link = gbf_backbone, link = ncbi_lite)
ner <- init.taxonerd("en_ner_eco_biobert", abbrev = TRUE, sent = FALSE, link = "ncbi_lite", thresh = .7, gpu = TRUE)


## get some pdfs

library(rplos)
library(comprehenr)
library(data.table)
library(dplyr)

corpus.dir <- "./my_corpus"
dir.create(corpus.dir, showWarnings = FALSE)
# Get DOIs for full article in PLoS One
res <- searchplos('biodiversity AND (habitat OR distribution OR survey) AND neotropics', c('id','publication_date','title'), list('subject:ecology', 'journal_key:PLoSONE','doc_type:full'), limit = 10)
# Download full-text articles in PDF format
for (doi in res$data$id) {
  pdf.url <- gsub("manuscript", "printable", full_text_urls(doi=doi))
  dest.file <- file.path(corpus.dir, paste(gsub("/", "_", doi), "pdf", sep="."))
  download.file(pdf.url, dest.file)
}


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
   separate(entity, remove = TRUE, c("NCBI" , "taxa", "prob"), sep = ", ") |>
  mutate(NCBI = str_remove_all(NCBI, "list\\("),
         prob = parse_number(prob))


setDT(taxa)[]
