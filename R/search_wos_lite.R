#' @name Search web of science
#'
#'
#'
#' @param api_key
#' @param query
#' @param count
#' @param first_record
#'
#' @return data frame
#' @export
#'
#' @examples search_woslite(<your api_key>, query = "ecological traps")

search_woslite <- function(api_key = api_key, query, count = 10, first_record = 1){

  require(jsonlite)
  require(curl)
  require(dplyr)
  require(tidyr)
  require(stringr)

  query = query
  h <- curl::new_handle()
  curl::handle_setheaders(h,
                          "X-ApiKey" ="b4b17edd048dc838bda83c6412238fb82f67cbaf",
                          "accept" = "application/json")

  uri <- "https://wos-api.clarivate.com/api/woslite/?databaseId=WOK" # search all database
  q <- paste0("TI%3D%28", str_replace_all(query, " ", "%20"), "%29")
  count <- 100
  first_record <- 1

  url <- paste0(uri, "&usrQuery=", q, "&count=", count, "&firstRecord=", first_record)
  url

  search <- curl::curl_fetch_memory(url = url, handle = h)

  search <- jsonlite::prettify(rawToChar(search$content))

  search <- jsonlite::fromJSON((search), simplifyDataFrame = TRUE)

  search


  id <- search$Data$UT |>
    tibble::enframe()
  title <- search$Data$Title$Title |>
    tibble::enframe()
  year <- search$Data$Source$Published.BiblioYear |>
    tibble::enframe()
  journal <- search$Data$Source$SourceTitle |>
    tibble::enframe()
  keywords <- search$Data$Keyword$Keywords |>
    tibble::enframe()
  doi <- search$Data$Other$Identifier.Doi |>
    tibble::enframe()

  result <- data.frame(id = id, year = year, title = title, journal = journal, doi = doi, kw = keywords) |>
    dplyr::select(-contains("name")) |>
    unnest("title.value") |>
    unnest("year.value") |>
    unnest("doi.value") |>
    unnest("journal.value") |>
    unnest("kw.value") |>
    group_by(id.value) |>
    mutate(kw = paste(kw.value, collapse = "; ")) |>
    select(-kw.value) |>
    distinct()

  result
  #out <- list(result = tibble::as_tibble(result), query = search$QueryResult)


}

