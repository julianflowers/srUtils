---
title: "Using taxonerd in R"
format: 
  html:
    toc: true
    toc_float: true
    keep-md: true
editor: visual
execute: 
   cache: true
bibliography: references.bib
---



## Step by step guide

This process is not for the faint-hearted but gives a rapid way of extracting taxa from texts (\~ 1 min per text) which can enable processing of large numbers of texts to identify similar species in research or facilitate coding for systematic maps. It only needs to be run through once. It uses a state-of-the-art model in terms of accuracy to extract the information @taxonerd; @taxonerd; @reticulate; @leguillarme2021

Uses python language models so we need to install Python and use `reticulate` package in R which allows R and Python to talk to each other.

Also downloads large files so setup time can be quite long

https://besjournals.onlinelibrary.wiley.com/doi/abs/10.1111/2041-210X.13778


::: {.cell hash='extract-taxa-from-text_cache/html/unnamed-chunk-1_f26d745e8be86027c8d3cf1ee8d75c03'}

```{.r .cell-code}
if(!require("reticulate")) install.packages(reticulate)
library(future); library(furrr); library(tidyverse)
```

::: {.cell-output .cell-output-stderr}
```
── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
✔ ggplot2 3.3.6     ✔ purrr   0.3.4
✔ tibble  3.1.7     ✔ dplyr   1.0.9
✔ tidyr   1.2.0     ✔ stringr 1.4.0
✔ readr   2.1.2     ✔ forcats 0.5.2
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
```
:::

```{.r .cell-code}
plan(multisession)

if(!require("taxonerd")) install.packages("https://github.com/nleguillarme/taxonerd/releases/download/v1.3.3/taxonerd_for_R_1.3.3.tar.gz", repos=NULL)
library(taxonerd)

use_python("C:/Users/Julian/OneDrive/Documents/.virtualenvs/r-taxonerd/Scripts/python.exe")
```
:::


If your computer has an NVIDIA graphics card, you should be able to run CUDA which will allow you to use the GPU (graphics processing unit) for processing. This is much quicker than the CPU and can speed up resource intensive tasks like Natural Language Processing.

To check:

-   open windows Device Manager

-   scroll down to Display Adapters and open to see what kind of graphics card you have

-   check your card against [this list](http://developer.nvidia.com/cuda-gpus "CUDA enabled graphics cards") - if it is there you can use CUDA.

-   to install the CUDA toolkit on Windows see [the quick setup guide](https://docs.nvidia.com/cuda/cuda-quick-start-guide/index.html#windows)

### Install Python package


::: {.cell hash='extract-taxa-from-text_cache/html/unnamed-chunk-2_b1a4cb4ba461f0302deb349a70681a4b'}

```{.r .cell-code}
install.taxonerd(cuda.version = "cuda112")
```

::: {.cell-output .cell-output-stdout}
```
Using virtual environment "r-taxonerd" ...
```
:::

::: {.cell-output .cell-output-stderr}
```
+ "C:/Users/Julian/OneDrive/Documents/.virtualenvs/r-taxonerd/Scripts/python.exe" -m pip install --upgrade --no-user --ignore-installed "taxonerd[cuda112]==1.3.3"
```
:::
:::


### Install bioBert language model


::: {.cell hash='extract-taxa-from-text_cache/html/unnamed-chunk-3_833609380317e1996b5c83a7d16e925d'}

```{.r .cell-code}
taxonerd::install.model(model = "en_ner_eco_biobert", version = "1.3.0")
```

::: {.cell-output .cell-output-stdout}
```
Using virtual environment "r-taxonerd" ...
```
:::

::: {.cell-output .cell-output-stderr}
```
+ "C:/Users/Julian/OneDrive/Documents/.virtualenvs/r-taxonerd/Scripts/python.exe" -m pip install --upgrade --no-user --ignore-installed "https://github.com/nleguillarme/taxonerd/releases/download/v1.3.0/en_ner_eco_biobert-1.0.0.tar.gz"
```
:::
:::


### Initialise named entity recognition model


::: {.cell hash='extract-taxa-from-text_cache/html/unnamed-chunk-4_92df61259b8f1cc089a775945b5badf3'}

```{.r .cell-code}
linker <- "ncbi_lite"
ner <- init.taxonerd("en_ner_eco_biobert", abbrev = TRUE, sent = FALSE, link = linker, thresh = .7, gpu = TRUE)
```
:::


### Get text to process

`taxonerd` offers functions for extracting taxa from blocks of text, files, or corpora (sets of files) but the file and corpora options don't seem to be functioning properly.

To extract per pdf text I use `readtext` as follows


::: {.cell hash='extract-taxa-from-text_cache/html/unnamed-chunk-5_c3e3d03751edaf624fb7c38c9b2696a1'}

```{.r .cell-code}
# set path to location of pdfs

path <- here::here("G:\\My Drive\\my_corpus\\uploads")

pdfs <- list.files(path, "pdf$", full.names = TRUE)

pdf_text <- purrr::map_dfr(pdfs, readtext::readtext)
```

::: {.cell-output .cell-output-stderr}
```
PDF error: Invalid shared object hint table offset
```
:::

::: {.cell-output .cell-output-stderr}
```
PDF error: xref num 1590 not found but needed, try to reconstruct<0a>
```
:::
:::


### A single example


::: {.cell hash='extract-taxa-from-text_cache/html/check a file_6a07ec395ebf393fcd55eecc3f03ef77'}

```{.r .cell-code}
taxa_file <- find.in.text(ner = ner, text = pdf_text$text[5])

taxa_file |>
  head(10) |>
  tidyr::unnest_auto("entity") |>
  tidyr::unnest_wider("entity")
```

::: {.cell-output .cell-output-stderr}
```
Using `unnest_longer(entity, indices_include = FALSE)`; no element has names
```
:::

::: {.cell-output .cell-output-stderr}
```
New names:
New names:
New names:
New names:
New names:
New names:
• `` -> `...1`
• `` -> `...2`
• `` -> `...3`
```
:::

::: {.cell-output .cell-output-stdout}
```
# A tibble: 6 × 5
  offsets          text               ...1      ...2                ...3
  <chr>            <chr>              <chr>     <chr>              <dbl>
1 LIVB 7991 7999   ryegrass           NCBI:4521 Italian ryegrass   0.832
2 LIVB 8001 8015   Lolium perenne     NCBI:4522 Lolium perenne     1    
3 LIVB 59904 59921 Lolium perenne L.  NCBI:4522 Lolium perenne     0.941
4 LIVB 72905 72917 white clover       NCBI:3899 white clover       1    
5 LIVB 72919 72935 Trifolium repens   NCBI:3899 Trifolium repens   1.00 
6 LIVB 74021 74039 perennial ryegrass NCBI:4522 perennial ryegrass 1    
```
:::
:::


### Scaling up


::: {.cell hash='extract-taxa-from-text_cache/html/unnamed-chunk-7_fea8f108c8c48aebe2ff9fb85c355af3'}

```{.r .cell-code}
library(tictoc)
tic()
taxa_df <- furrr::future_map2_dfr(.x = pdf_text$text, .y = pdf_text$doc_id, ~(find.in.text(ner, .x)) |> mutate(file = .y))
toc()
```

::: {.cell-output .cell-output-stdout}
```
2984.41 sec elapsed
```
:::

```{.r .cell-code}
head(taxa_df) 
```

::: {.cell-output .cell-output-stdout}
```
                offsets              text
T0...1 LIVB 21393 21401          Sphagnum
T1...2 LIVB 22635 22649    Sphagnum peats
T2...3 LIVB 24324 24329             sheep
T3...4 LIVB 26103 26108             sheep
T4...5 LIVB 26875 26892 Rubus chamaemorus
T5...6 LIVB 27953 27960           heather
                                                                                                                                            entity
T0...1                                                                                                                     NCBI:13804, Sphagnum, 1
T1...2                                                                                                      NCBI:13804, Sphagnum, 0.71510237455368
T2...3                                                                                                                         NCBI:9940, sheep, 1
T3...4                                                                                                                         NCBI:9940, sheep, 1
T4...5                                                                                                            NCBI:57936, Rubus chamaemorus, 1
T5...6 NCBI:1256648, C. heatherae, 0.777346432209015, NCBI:2569842, C. heatherae, 0.777346432209015, NCBI:1174604, C. heatherae, 0.777346432209015
                     file
T0...1 09596830094971.pdf
T1...2 09596830094971.pdf
T2...3 09596830094971.pdf
T3...4 09596830094971.pdf
T4...5 09596830094971.pdf
T5...6 09596830094971.pdf
```
:::

```{.r .cell-code}
taxa <- taxa_df |>
  tidyr::unnest_longer("entity") |> 
  mutate(taxa = map(entity, 2 ), 
         prob = map_dbl(entity, 3)) |>
  unnest("taxa")



taxa |>
  select(file, text, taxa, prob) |>
  distinct()
```

::: {.cell-output .cell-output-stdout}
```
# A tibble: 1,192 × 4
   file                             text                 taxa               prob
   <chr>                            <chr>                <chr>             <dbl>
 1 09596830094971.pdf               Sphagnum             Sphagnum          1    
 2 09596830094971.pdf               Sphagnum peats       Sphagnum          0.715
 3 09596830094971.pdf               sheep                sheep             1    
 4 09596830094971.pdf               Rubus chamaemorus    Rubus chamaemorus 1    
 5 09596830094971.pdf               heather              C. heatherae      0.777
 6 09596830094971.pdf               Eriophorum           Eriophorum        1    
 7 09596830094971.pdf               Calluna vulgaris     Calluna vulgaris  1    
 8 09596830094971.pdf               Rubus chamaemorus L. Rubus chamaemoru… 1    
 9 09596830094971.pdf               Eriophorum bog       Eriophorum        0.788
10 1-s2.0-003807179500092S-main.pdf Dairy cow            dairy cow         1    
# … with 1,182 more rows
```
:::
:::
