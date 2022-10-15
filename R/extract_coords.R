p <- here::here("G:\\My Drive\\my_corpus\\uploads")
f <- list.files(p, "pdf", full.names = TRUE)

pacman::p_load(tidyverse, pdftools, readtext)
pacman::p_load_gh("julianflowers/srUtils")
library(srUtils)


pdfs <- map(f, pdftools::pdf_text)

coords <- map(pdfs, get_coordinates)

decimal <-map(coords, "d.value")
decimal
colon <- map(coords, "c.value")
colon

lat <- map(coords, "lat.value") |>
  enframe() |>
    unnest("value") |>
    mutate(nrow = map(value, nrow)) |>
    filter(nrow > 0) |>
    unnest("value") |>
    data.frame()

lat

long <- map(coords, "long.value") |>
  enframe() |>
  unnest("value") |>
  mutate(nrow = map(value, nrow)) |>
  filter(nrow > 0) |>
  unnest("value") |>
  data.frame()

polar <- lat |>
 rbind(long)

polar1 <- polar$value |>
  data.frame()

polar1 <- polar1 |>
  bind_cols(file = polar$name)

polar1_dec <- polar1 |>
  select(file, X1) |>
  mutate(coords = str_extract_all(X1, pattern = paste0("(\\d{1,3}.?)", "(", stringi::stri_unescape_unicode('\\u00b0'), "|",
                                                     stringi::stri_unescape_unicode('\\u25e6'), ")", "\\s?", "(\\d{1,3})", "\\D{1,}", "([EWNS])")),
         coords = str_remove_all(coords, "[[:punct:]]"),
         coords = str_remove_all(coords, "\\003|\\004"),
         coords1 = str_match_all(coords, pattern = paste0("(\\d{1,3}.?)", "(", stringi::stri_unescape_unicode('\\u00b0'), "|",
                                                        stringi::stri_unescape_unicode('\\u25e6'), ")", "\\s?", "(\\d{1,3})", "\\D?", "([EWNS])")),
         coords2 = coords1
  ) |>
  select(file, coords, coords1) |>
  separate(coords1, c("text", "deg", "sym", "min", "pole"), sep = ",") %>%
  mutate(deg = parse_number(deg),
         min = parse_number(min),
         pole = str_extract(pole, "[NSEW]")) |>
  select(file, deg, min, pole) |>
  mutate(min = ifelse(min > 100, min/10, min),
         dec = round(deg + min / 36, 2),
         dec = ifelse(pole %in% c("W", "S"), -dec, dec)) |>
  select(file, dec, pole) |>
  arrange(file) |>
  distinct()


dec1 <- decimal |>
  enframe() |>
  unnest("value") |>
  mutate(nrow = map(value, nrow)) |>
  filter(nrow > 0) |>
  unnest("value") |>
  data.frame()

dec1_dec <- dec1$value |>
  data.frame() |>
  bind_cols(file = dec1$name) |>
  select(file, deg = X2, min = X3, pole = X5) |>
  mutate_at(.vars = 2:3, as.numeric) |>
  mutate(dec = deg + min /100,
         dec = ifelse(pole %in% c("W", "S"), -dec, dec)) |>
  select(file, dec, pole) |>
  arrange(file) |>
  distinct()
)


col1 <- colon |>
  enframe() |>
  unnest("value") |>
  mutate(nrow = map(value, nrow)) |>
  filter(nrow > 0) |>
  unnest("value") |>
  data.frame()

col1_dec <- col1$value |>
  data.frame() |>
  bind_cols(file = col1$name) |>
  select(file, deg = X3, min = X4, pole = X2) |>
  mutate_at(.vars = 2:3, as.numeric) |>
  mutate(dec = deg + min /100,
         dec = ifelse(pole %in% c("W", "S"), -dec, dec)) |>
  select(file, dec, pole) |>
  arrange(file) |>
  distinct()

misc1 <- map(coords, "misc.value") |>
  enframe() |>
  unnest("value") |>
  mutate(nrow = map(value, nrow)) |>
  filter(nrow > 0) |>
  unnest("value") |>
  data.frame()

misc1$value |>
  data.frame() |>
  bind_cols(file = misc1$name) |>
  select(file, X1) |>
  mutate(lat = stringr::str_match_all(X1, pattern = "(\\d{1,2}u)(\\d{1,2}9).*([NS])"),
         long = stringr::str_match_all(X1, pattern = "\\s(\\d{1,2}u)(\\d{1,2}9).*([EW])")) |>
  select(-X1) |>
  pivot_longer(names_to = "polarity", values_to = "coords", cols = lat:long) |>
  unnest("coords") |>
  as.data.frame() |>
  mutate(deg = parse_number(coords.2))

