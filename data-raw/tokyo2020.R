## code to prepare `tokyo2020` dataset goes here
tokyo_events <- get_sports(game = "tokyo-2020") %>% get_events()
tokyo2020 <- tokyo_events %>% get_results()

usethis::use_data(tokyo_events, overwrite = TRUE)
usethis::use_data(tokyo2020, overwrite = TRUE)

## code to prepare `beijing2020` dataset goes here
beijing_events <- get_sports(game = "beijing-2022") %>% get_events()
beijing2022 <- beijing_events %>% get_results()

usethis::use_data(beijing_events, overwrite = TRUE)
usethis::use_data(beijing2022, overwrite = TRUE)


#tokyo-2020, rio-2016, london-2012, beijing-2008, athens-2004, sydney-2000
summer_games_slugs <- olympic_game %>%
  dplyr::filter(season == "Summer") %>%
  dplyr::pull(slug) %>%
  head(6)

summer_games <- purrr::map_dfr(
  summer_games_slugs,
  ~.x %>% get_sports() %>% get_events() %>% get_results()
)
usethis::use_data(summer_games, overwrite = TRUE)



winter_games_slugs <- olympic_game %>%
  dplyr::filter(season == "Winter") %>%
  dplyr::pull(slug) %>%
  head(6)

winter_games <- purrr::map_dfr(
  winter_games_slugs,
  ~.x %>% get_sports() %>% get_events() %>% get_results())
usethis::use_data(winter_games, overwrite = TRUE)
