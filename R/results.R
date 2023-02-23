#' Title
#'
#' @param url the url to event page in olympic.com, i.e. https://olympics.com/en/olympic-games/tokyo-2020/results/swimming/men-s-100m-breaststroke
#'
#' @return a tibble of result summary
#' @export
#'
#' @examples
#' get_single_result("https://olympics.com/en/olympic-games/tokyo-2020/results/shooting/skeet-men")
get_single_result <- function(url){

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

  if (length(name) == 0){
    name <- html %>%
      rvest::html_elements(".styles__AthleteName-sc-1yhe77y-3") %>%
      rvest::html_text()
  }

  team <- html %>%
    rvest::html_elements(".styles__CountryName-sc-1r5phm6-1") %>%
    rvest::html_text()

  if (length(team) == 0){
    team <- html %>%
      rvest::html_elements(".styles__CountryName-sc-rh9yz9-8") %>%
      rvest::html_text()
  }

  res <- tibble::tibble(rank = rank, team = team)

  res <- res %>% dplyr::mutate(result = c(result, rep(NA, nrow(res) - length(result))))

  # correction if events are played by paired player
  if (stringr::str_detect(url, "synchronised|team|double|doubles") & (length(name) != 0)){
    name <- tibble(orig = name) %>%
      mutate(id = rep(1:nrow(res), each = 2)) %>%
      tidyr::nest(nested = orig) %>%
      mutate(name = purrr::map(nested, ~dplyr::pull(.x) %>% paste0(collapse = "/ "))) %>%
      tidyr::unnest(name) %>%
      dplyr::pull(name)
    }
  if (length(name) != 0){

    res <- res %>%
      dplyr::mutate(name = name) %>%
      dplyr::select(rank, team, name, result)
  }

  res

}


#' Title
#'
#' @param table the output from get_event
#'
#' @return a tibble of result summary
#' @export
#'
#' @examples
#' get_sports(game = "tokyo-2020") %>% head(1) %>% get_events() %>% head(1) %>% get_results()
get_results <- function(table){
  table %>%
    dplyr::mutate(url = glue::glue("https://olympics.com/en/olympic-games/{game}/results/{sport}/{event}")) %>%
    dplyr::rowwise() %>%
    dplyr::mutate( results = list(get_single_result(url))) %>%
    tidyr::unnest(results) %>%
    dplyr::select(game, sport, event, rank:result)
}

#
