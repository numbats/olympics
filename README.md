
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
#>   game       sport    event                 rank  team  name              result
#>   <chr>      <chr>    <chr>                 <chr> <chr> <chr>              <dbl>
#> 1 tokyo-2020 swimming men-s-100m-backstroke G     ROC   Evgeny Rylov        52.0
#> 2 tokyo-2020 swimming men-s-100m-backstroke S     ROC   Kliment Kolesnik…   52  
#> 3 tokyo-2020 swimming men-s-100m-backstroke B     USA   Ryan Murphy         52.2
#> 4 tokyo-2020 swimming men-s-100m-backstroke 4     ITA   Thomas Ceccon       52.3
#> 5 tokyo-2020 swimming men-s-100m-backstroke 5     CHN   Jiayu Xu            52.5
#> 6 tokyo-2020 swimming men-s-100m-backstroke 6     ESP   Hugo Gonzalez De…   52.8
#> 7 tokyo-2020 swimming men-s-100m-backstroke 7     AUS   Mitchell Larkin     52.8
#> 8 tokyo-2020 swimming men-s-100m-backstroke 8     ROU   Robert Glinta       53.0
```

The full Tokyo 2020 results is available as built-in data in the package
as `tokyo2020`, the same with `beijing2022`. Full results of 21st games
are available at `summer_games` (Tokyo 2020, Rio 2016, London 2012,
Beijing 2008, Athens 2004, and Sydney 2000) and `winter_games` (Beijing
2022, Pyeongchang 2018, Sochi 2014, Vancouver 2010, Turin 2006, and Salt
Lake City 2002).
