#' Title
#'
#' @param game the olympic game, in the format of tokyo-2020, see the slug column in olympic_game
#'
#' @return a tibble of event summary
#' @export
#'
#' @examples
#' get_sports(game = "tokyo-2020")
get_sports <- function(game){

  season <- olympic_game %>% dplyr::filter(slug == game) %>% dplyr::pull(season)

  if (season == "Winter"){
    url <- glue::glue("https://olympics.com/en/olympic-games/", game, "/results/snowboard")
  } else if (season == "Summer"){
    url <- glue::glue("https://olympics.com/en/olympic-games/", game, "/results/swimming")
  } else{
    cli::cli_abort("game not found, please use the slug as shown in {.data olympic_game}")
  }


  raw <- httr::GET(url) %>%
    rvest::read_html() %>%
    html_elements("#__NEXT_DATA__") %>%
    rvest::html_text() %>%
    jsonlite::fromJSON() %>%
    .[["props"]] %>% .[["pageProps"]] %>% .[["allDisciplines"]] %>%
    tibble::as_tibble() %>%
    dplyr::mutate(game = game) %>%
    dplyr::select(game, slug) %>%
    dplyr::rename(sport = slug) %>%
    dplyr::arrange(sport)


  return(raw)

}


#' Title
#'
#' @param url the URL to the event
#'
#' @return a tibble of event summary
#' @export
#'
#' @examples
#'get_single_event("https://olympics.com/en/olympic-games/tokyo-2020/results/shooting")
get_single_event <- function(url){

  raw <- httr::GET(url) %>%
    rvest::read_html() %>%
    html_elements("#__NEXT_DATA__") %>%
    rvest::html_text() %>%
    jsonlite::fromJSON() %>%
    .[["props"]] %>% .[["pageProps"]] %>% .[["allEvents"]] %>%
    tibble::as_tibble()
    # dplyr::mutate(game = game, sport = sport) %>%
    # dplyr::select(game, sport, title, slug, gender) %>%
    # dplyr::rename(event = title)

  return(raw)

}


#' Title
#'
#' @param table a table from get_sports()
#'
#' @return a tibble of event summary
#' @export
#'
#' @examples
#' get_sports(game = "tokyo-2020") %>% head(1) %>% get_events()
get_events <- function(table){
  table %>%
    dplyr::mutate(url = glue::glue("https://olympics.com/en/olympic-games/{game}/results/{sport}")) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(results = list(get_single_event(url))) %>%
    tidyr::unnest(results) %>%
    dplyr::select(game, sport, slug, gender) %>%
    dplyr::rename(event = slug) %>%
    dplyr::arrange(sport, desc(event))

}

globalVariables(c(".", "title", "slug", "gender", "results", "olympic_game",
                  "game", "sport", "event", "result", "orig", "nested"))
