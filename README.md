
<!-- README.md is generated from README.Rmd. Please edit that file -->

# olympics <a hre='https://numbats.github.io/olympics/'><img src='man/figures/logo.png' align="right" height="138.5" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/numbats/olympics/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/numbats/olympics/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The `olympics` package provides an interface to scrape Olympic data from
<https://olympics.com/>.

## Installation

You can install the development version of olympics from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("numbats/olympics")
```

## Example

The package extracts Olympic results in a sequential order:

-   a *game* slug (i.e. tokyo-2020) can be passed into `get_sports()` to
    find the available *sports* in the *game*,
-   the resulting *sport* table can then be passed into `get_events()`
    to find the *events* under each *sport*,
-   the *event* table can then be passed into `get_results()` to find
    the event results.

The tables in this pipeline can be wrangled to customise the extraction.
For example,

``` r
library(olympics)
get_sports(game = "tokyo-2020") %>% 
  dplyr::filter(sport == "swimming") %>% 
  get_events() %>% 
  head(1) %>% 
  get_results()
#> # A tibble: 8 × 7
#>   game       sport    event                  rank  team  name             result
#>   <chr>      <chr>    <chr>                  <chr> <chr> <chr>            <chr> 
#> 1 tokyo-2020 swimming women-s-800m-freestyle G     USA   Katie Ledecky    8:12.…
#> 2 tokyo-2020 swimming women-s-800m-freestyle S     AUS   Ariarne Titmus   8:13.…
#> 3 tokyo-2020 swimming women-s-800m-freestyle B     ITA   Simona Quadarel… 8:18.…
#> 4 tokyo-2020 swimming women-s-800m-freestyle 4     USA   Katie Grimes     8:19.…
#> 5 tokyo-2020 swimming women-s-800m-freestyle 5     CHN   Jianjiahe Wang   8:21.…
#> 6 tokyo-2020 swimming women-s-800m-freestyle 6     AUS   Kiah Melverton   8:22.…
#> 7 tokyo-2020 swimming women-s-800m-freestyle 7     GER   Sarah Kohler     8:24.…
#> 8 tokyo-2020 swimming women-s-800m-freestyle 8     ROC   Anastasiia Kirp… 8:26.…
```

The full Tokyo 2020 results is available as built-in data in the package
as `tokyo2020`, the same with `beijing2022`. Full results of 21st games
are available at `summer_games` (Tokyo 2020, Rio 2016, London 2012,
Beijing 2008, Athens 2004, and Sydney 2000) and `winter_games` (Beijing
2022, Pyeongchang 2018, Sochi 2014, Vancouver 2010, Turin 2006, and Salt
Lake City 2002).
