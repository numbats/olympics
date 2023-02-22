#' Title
#'
#' @param url the url to event page in olympic.com, i.e. https://olympics.com/en/olympic-games/tokyo-2020/results/swimming/men-s-100m-breaststroke
#'
#' @return a tibble of result summary
#' @export
#'
#' @examples
#' url <- "https://olympics.com/en/olympic-games/tokyo-2020/results/swimming/men-s-100m-breaststroke"
#' get_results(url)
get_results <- function(url){
  
  html <- httr::GET(url) %>% rvest::read_html()
  
  rank <- html %>%
    rvest::html_elements(".styles__MedalWrapper-sc-rh9yz9-0") %>%
    rvest::html_text()
  
  result <-  html %>%
    rvest::html_elements(".styles__Info-sc-cjoz4h-0") %>%
    rvest::html_text() %>%
    stringr::str_extract("\\d+\\.\\d+") %>% as.numeric() %>% stats::na.omit()
  
  name <- html %>%
    rvest::html_elements(".styles__AthleteName-sc-1yhe77y-3") %>%
    rvest::html_text() %>%
    stringr::str_to_title()
  
  country <- html %>%
    rvest::html_elements(".styles__CountryName-sc-1r5phm6-1") %>%
    rvest::html_text()
  
  tibble::tibble(country = country, name = name, result = result, rank = rank)
  
}
