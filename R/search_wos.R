#' Search Web of Science
#'
#' This function searches the Web of Science database using a query and returns the results.
#'
#' @param api_key (optional) the API key for accessing the Web of Science API
#' @param query the search query
#' @param count the number of results to return (default is 100)
#' @param first_record the index of the first result to return (default is 1)
#' @return a list containing the search results and the total count of matched records
#' @import jsonlite
#' @import curl
#' @import dplyr
#' @import tidyr
#' @import stringr
#' @examples
#' search_wos("my-api-key", "climate change")

#' @export


search_wos <- function(api_key = api_key, query, count = 100, first_record = 1){

  require(jsonlite)
  require(curl)
  require(dplyr)
  require(tidyr)
  require(stringr)

  ss <- query
  #AND (UK OR Britain OR United Kingdom OR Great Britain) AND (Urban OR Town OR City OR Village)"

  query = ss
  h <- curl::new_handle()
  curl::handle_setheaders(h,
                          "X-ApiKey" = api_key,
                          "accept" = "application/json")

  uri <- "https://wos-api.clarivate.com/api/woslite/?databaseId=WOK" # search all databases
  q <- str_replace_all(query, " ", "%20")
  count <- 100
  first_record <- first_record

  url <- paste0(uri, "&usrQuery=", q, "&count=", count, "&firstRecord=", first_record)
  url

  search <- curl::curl_fetch_memory(url = url, handle = h)

  search <- jsonlite::prettify(rawToChar(search$content))

  search <- jsonlite::fromJSON((search), simplifyDataFrame = TRUE)

  out <- list(res = search$Data, count = search$QueryResult)

}




