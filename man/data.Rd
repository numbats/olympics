% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{olympic_game}
\alias{olympic_game}
\alias{tokyo2020}
\alias{medals}
\alias{beijing2022}
\alias{summer_games}
\alias{winter_games}
\title{Built-in data}
\format{
An object of class \code{tbl_df} (inherits from \code{tbl}, \code{data.frame}) with 53 rows and 7 columns.

An object of class \code{tbl_df} (inherits from \code{tbl}, \code{data.frame}) with 6900 rows and 7 columns.

An object of class \code{tbl_df} (inherits from \code{tbl}, \code{data.frame}) with 1747 rows and 6 columns.

An object of class \code{tbl_df} (inherits from \code{tbl}, \code{data.frame}) with 3785 rows and 6 columns.

An object of class \code{tbl_df} (inherits from \code{tbl}, \code{data.frame}) with 43248 rows and 7 columns.

An object of class \code{tbl_df} (inherits from \code{tbl}, \code{data.frame}) with 18628 rows and 7 columns.
}
\usage{
olympic_game

tokyo2020

medals

beijing2022

summer_games

winter_games
}
\description{
Built-in data
}
\details{
TODO
}
\examples{
# slug for the recent 5 summer games
olympic_game \%>\% dplyr::filter(season == "Summer") \%>\% dplyr::pull(slug) \%>\% head(5)


# Female single swimmer leaderboard
tokyo2020 \%>\%
 dplyr::filter(sport == "swimming",
              stringr::str_detect(event, "women"),
              !is.na(name),
              rank \%in\% c("G", "S", "B")) \%>\%
  dplyr::count(name, rank) \%>\%
  tidyr::pivot_wider(names_from = "rank", values_from = "n", values_fill = 0) \%>\%
  dplyr::select(name, G, S, B) \%>\%
  dplyr::arrange(desc(G), desc(S), desc(B))

# medal board from ...
unique(medals$game) \%>\% stringr::str_extract("\\\\d+") \%>\% min()

# Beijing winter olympic sports:
unique(beijing2022$sport)

# how many events are played in each summer/ winter game
summer_games \%>\% tidyr::nest(rank:result) \%>\% dplyr::count(game, sort = TRUE)
winter_games \%>\% tidyr::nest(rank:result) \%>\% dplyr::count(game, sort = TRUE)
}
\keyword{datasets}
