## code to prepare `olympic-game` dataset goes here

raw <- httr::GET("https://olympics.com/en/olympic-games/tokyo-2020/results/swimming") |>
  rvest::read_html() %>%
  html_elements("#__NEXT_DATA__") %>%
  rvest::html_text() %>%
  jsonlite::fromJSON()

olympic_game <- tibble::as_tibble(raw$props$pageProps$allGames) %>%
  dplyr::select(-`__typename`) %>%
  tidyr::unnest(meta) %>%
  dplyr::select(name, year, season, location, slug, startDate, endDate) %>%
  dplyr::mutate(startDate = as.POSIXct(startDate),
                endDate = as.POSIXct(endDate))

usethis::use_data(olympic_game, overwrite = TRUE)


