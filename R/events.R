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


  raw <- httr::GET(url) |>
    rvest::read_html() %>%
    html_elements("#__NEXT_DATA__") %>%
    rvest::html_text() %>%
    jsonlite::fromJSON() %>%
    .[["props"]] %>% .[["pageProps"]] %>% .[["allDisciplines"]] %>%
    tibble::as_tibble() %>%
    dplyr::mutate(game = game) %>%
    dplyr::select(game, title, slug) %>%
    dplyr::rename(sport = title)

  return(raw)

}


#' Title
#'
#' @param game the olympic game, in the format of tokyo-2020, see the slug column in olympic_game
#' @param sport the sport, see the slug column from get_sports()
#'
#' @return a tibble of event summary
#' @export
#'
#' @examples
#' get_events(game = "tokyo-2020", sport = "swimming")
get_events <- function(game, sport){

  url <- glue::glue("https://olympics.com/en/olympic-games/", game, "/results/", sport)

  raw <- httr::GET(url) |>
    rvest::read_html() %>%
    html_elements("#__NEXT_DATA__") %>%
    rvest::html_text() %>%
    jsonlite::fromJSON() %>%
    .[["props"]] %>% .[["pageProps"]] %>% .[["allEvents"]] %>%
    tibble::as_tibble() %>%
    dplyr::mutate(game = game, sport = sport) %>%
    dplyr::select(game, sport, title, slug, gender) %>%
    dplyr::rename(event = title)

  return(raw)

}

globalVariables(c(".", "title", "slug", "gender", "results", "olympic_game"))
