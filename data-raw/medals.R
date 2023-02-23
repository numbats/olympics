## code to prepare the `medals` dataset goes here

medals <- map_dfr(olympic_game$slug[stringr::str_sub(olympic_game$slug, -4, -1) > 1904], get_medals)
usethis::use_data(medals, overwrite = TRUE)
