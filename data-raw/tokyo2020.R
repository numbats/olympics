## code to prepare `tokyo2020` dataset goes here
tokyo_events <- get_sports(game = "tokyo-2020") %>% get_events()
tokyo2020 <- tokyo_events %>% get_results()

usethis::use_data(tokyo_events, overwrite = TRUE)
usethis::use_data(tokyo2020, overwrite = TRUE)
