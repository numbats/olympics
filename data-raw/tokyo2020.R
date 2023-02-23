## code to prepare `tokyo2020` dataset goes here
tokyo2020 <- get_sports(game = "tokyo-2020") %>% get_events() %>% get_results()
usethis::use_data(tokyo2020, overwrite = TRUE)

## code to prepare `beijing2020` dataset goes here
beijing2022 <- get_sports(game = "beijing-2022") %>% get_events() %>% get_results()
usethis::use_data(beijing2022, overwrite = TRUE)

#tokyo-2020, rio-2016, london-2012, beijing-2008, athens-2004, sydney-2000
summer_games <- olympic_game %>%
  dplyr::filter(season == "Summer") %>%
  dplyr::pull(slug) %>%
  head(6) %>%
  purrr::map_dfr(~.x %>% get_sports() %>% get_events() %>% get_results())
usethis::use_data(summer_games, overwrite = TRUE)

# beijing-2022, pyeongchang-2018, sochi-2014, vancouver-2010, turin-2006, salt-lake-city-2002
winter_games <- olympic_game %>%
  dplyr::filter(season == "Winter") %>%
  dplyr::pull(slug) %>%
  head(6) %>%
  purrr::map_dfr(~.x %>% get_sports() %>% get_events() %>% get_results())
usethis::use_data(winter_games, overwrite = TRUE)
