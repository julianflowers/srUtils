#' Ask openai
#' 
#' Leverage the openai python module and GPT-3 to provide AI driven answers 
#' 
#'
#' @param text 
#' @param api_key 
#'
#' @return list
#' @export
#'
#' @examples ask_openai(text)

ask_openai <- function(text, api_key){
  
  require(reticulate); require(tidyverse)
   reticulate::virtualenv_create("openai")
   reticulate::use_virtualenv("openai", required = TRUE)

  py_install("openai", pip = TRUE, envname = "openai")

  oai <- import("openai", as = "oai")
  os <- import("os")

  oai$api_key = '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'

   text <- text

  n <- as.integer(500)

response <- oai$Completion$create(
  
  model="text-davinci-002",
  prompt = text,
  temperature= 1.0,
  max_tokens=n,
  top_p=1.0,
  frequency_penalty=0.0,
  presence_penalty=0.0
  
)

text <- as.character(response)[[1]] |>
  stringr::str_split('\\n')

out <- text[[1]][7] |>
  str_remove_all("\\\\n") |>
  str_remove("\\s.*text.*:\\s") |>
  str_remove_all('\\\"')

return(out)

}

