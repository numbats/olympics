#' Built-in data
#' @details TODO
#' @rdname data
#' @examples
#' # slug for the recent 5 summer games
#' olympic_game %>% dplyr::filter(season == "Summer") %>% dplyr::pull(slug) %>% head(5)
"olympic_game"

#' @rdname data
#' @examples
#'
#'
#' # Female single swimmer leaderboard
#' tokyo2020 %>%
#'  dplyr::filter(sport == "swimming",
#'               stringr::str_detect(event, "women"),
#'               !is.na(name),
#'               rank %in% c("G", "S", "B")) %>%
#'   dplyr::count(name, rank) %>%
#'   tidyr::pivot_wider(names_from = "rank", values_from = "n", values_fill = 0) %>%
#'   dplyr::select(name, G, S, B) %>%
#'   dplyr::arrange(desc(G), desc(S), desc(B))
"tokyo2020"

#' @rdname data
#' @examples
#'
#' # medal board from ...
#' unique(medals$game) %>% stringr::str_extract("\\d+") %>% min()
"medals"

#' @rdname data
#' @examples
#'
#' # Beijing winter olympic sports:
#' unique(beijing2022$sport)
"beijing2022"

#' @rdname data
#' @examples
#'
#' # how many events are played in each summer/ winter game
#' summer_games %>% tidyr::nest(rank:result) %>% dplyr::count(game, sort = TRUE)
#' winter_games %>% tidyr::nest(rank:result) %>% dplyr::count(game, sort = TRUE)
"summer_games"

#' @rdname data
"winter_games"
