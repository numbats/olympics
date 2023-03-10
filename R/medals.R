#' Scrape Olympic medal board
#'
#' @param game the Olympic game, in the format of tokyo-2020, see the slug column in the built-in olympic_game data
#'
#' @return a tibble of medal table
#' @export
#'
#' @examples
#' get_medals(game = "tokyo-2020")
get_medals <- function(game){
  if (game %in% dplyr::pull(olympic_game, slug)){
    url <- glue::glue("https://olympics.com/en/olympic-games/", game, "/medals")
  } else{
    cli::cli_abort("game not found, please use the slug as shown in {.data olympic_game}")
  }
  if (stringr::str_sub(game, -4, -1) <= 1904){
    cli::cli_abort("medal tables for games in 1904 and before 1904 are not available")
  }

  html <- httr::GET(url) %>% rvest::read_html()

  team <- html %>%
    rvest::html_elements(".styles__CountryTriLetterCode-sc-fehzzg-5") %>%
    rvest::html_text()
  team <- gsub(' ', '', team)

  medals <- html %>%
    rvest::html_elements(".Medalstyles__Wrapper-sc-1tu6huk-0") %>%
    rvest::html_text() %>% matrix(nrow = length(team), ncol = 4, byrow = TRUE)
  medals[medals == "-"] <- 0
  medals <- apply(medals, 2, as.numeric)
  raw <- tibble::tibble(game = game, team = team,
                        gold = medals[,1], silver = medals[,2], bronze = medals[,3],
                        total = medals[,4])

  return(raw)
}
