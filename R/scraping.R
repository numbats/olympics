#' Functions to scrape olympic data
#'
#' Functions to scrape olympic data from olympic.com
#'
#' @param game used in [get_sports()]; \cr in the format of tokyo-2020, see the slug column in the built-in data [olympic_game].
#'
#' @return a tibble of event summary
#' @export
#' @rdname scrape
#'
#' @examples
#' # sport table in Tokyo 2020
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
    dplyr::arrange(desc(sport))


  return(raw)

}

#' @param url used in [get_single_event()] and [get_single_result()]; \cr the URL to the sport/ event page, see examples.
#' @export
#' @rdname scrape
#'
#' @examples
#'
#' # event table from URL or sport table
#'get_single_event("https://olympics.com/en/olympic-games/tokyo-2020/results/swimming")
#'get_sports(game = "tokyo-2020") %>% head(1) %>% get_events()
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

#' @param table used in [get_events()] and [get_results()]; \cr the tibble produced by [get_sports()] and [get_events()], see examples.
#' @export
#' @rdname scrape
get_events <- function(table){
  table %>%
    dplyr::mutate(url = glue::glue("https://olympics.com/en/olympic-games/{game}/results/{sport}")) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(results = list(get_single_event(url))) %>%
    tidyr::unnest(results) %>%
    dplyr::select(game, sport, slug, gender) %>%
    dplyr::rename(event = slug) %>%
    dplyr::arrange(desc(sport), desc(event))

}

#' @export
#' @rdname scrape
#'
#' @examples
#'
#' # event results from URL or event table
#' get_single_result("https://olympics.com/en/olympic-games/tokyo-2020/results/swimming")
#' get_sports(game = "tokyo-2020") %>% head(1) %>% get_events() %>% head(1) %>% get_results()
get_single_result <- function(url){
#browser()

  html <- httr::GET(url) %>% rvest::read_html()

  rank <- html %>%
    rvest::html_elements(".styles__MedalWrapper-sc-rh9yz9-0") %>%
    rvest::html_text()

  result <-  html %>%
    rvest::html_elements(".styles__Info-sc-cjoz4h-0") %>%
    rvest::html_text() %>%
    stringr::str_remove("Results:")


  result <- result[1:length(result) %%2 == 1]

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
  paired_string <- "synchronised|synchronized|team|double|doubles|fx|470|mixed|49er|pair|beach-volleyball|2-man|2-woman|keelboat|two-woman|two-man"
  if (stringr::str_detect(url, paired_string) & (length(name) != 0)){

    false_positive <- "double-trap|individual-mixed|dinghy-mixed|open-laser-mixed"
    if (stringr::str_detect(url, false_positive)){
      name <- name # no action if false positive
    } else{
      name <- tibble(orig = name) %>%
        mutate(id = rep(1:nrow(res), each = 2)) %>%
        tidyr::nest(nested = orig) %>%
        mutate(name = purrr::map(nested, ~dplyr::pull(.x) %>% paste0(collapse = "/ "))) %>%
        tidyr::unnest(name) %>%
        dplyr::pull(name)
    }
  }
  if (length(name) != 0){

    res <- res %>%
      dplyr::mutate(name = name) %>%
      dplyr::select(rank, team, name, result)
  }

  res

}

#' @export
#' @rdname scrape
get_results <- function(table){
  table %>%
    dplyr::mutate(url = glue::glue("https://olympics.com/en/olympic-games/{game}/results/{sport}/{event}")) %>%
    dplyr::rowwise() %>%
    dplyr::mutate( results = list(get_single_result(url))) %>%
    tidyr::unnest(results) %>%
    dplyr::select(game, sport, event, rank:result)
}

globalVariables(c(".", "title", "slug", "gender", "results", "olympic_game",
                  "game", "sport", "event", "result", "orig", "nested"))
