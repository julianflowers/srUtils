## searches
##


search1 <- "(urban OR cit* OR town) AND (rewild* OR restor*) AND (biodiversity OR richness)"

woslite <- Sys.getenv("WOSLITE")

res <- search_wos(api_key = woslite, query = search1)

res$count

res$res$Title

selection <- c(2, 13, 19, 22)

res$res[selection, ]

search2 <- "(urban OR cit* OR town) AND (rewild* OR restor*) AND (systematic review OR meta-analysis)"

woslite <- Sys.getenv("WOSLITE")

res1 <- search_wos(api_key = woslite, query = search2)

res1$count

res1$res$Title

search3 <- "(urban OR cit* OR town) AND (roundabout*) AND (biodiversity OR richness)"

woslite <- Sys.getenv("WOSLITE")

res3 <- search_wos(api_key = woslite, query = search3)

res3$count

res3$res$Title

search4 <- "(urban OR cit* OR town) AND (green* OR park* OR forest) AND (biodiversity OR richness)"

woslite <- Sys.getenv("WOSLITE")

res4 <- search_wos(api_key = woslite, query = search4)

res4$count

fr <- seq(0, ceiling(res4$count$RecordsFound), 100)

full_res <- purrr::map(1:length(fr), \(x) search_wos(query = search4, api_key = woslite, first_record = fr[x]), .progress = TRUE)

res5 <- purrr::map(full_res, "res") |>
  purrr::list_rbind()

c(2, 3, 5, 22)

res5[22,]


###
###

search6 <- "species area relationship AND review"
res6 <- search_wos(api_key = woslite, query = search6)
res6$res
