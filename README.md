
<!-- README.md is generated from README.Rmd. Please edit that file -->

# olympics

<!-- badges: start -->

[![R-CMD-check](https://github.com/numbats/olympics/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/numbats/olympics/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of olympics is to …

## Installation

You can install the development version of olympics from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("numbats/olympics")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(olympics)
url <- "https://olympics.com/en/olympic-games/tokyo-2020/results/swimming/men-s-100m-breaststroke"
get_results(url)
#> # A tibble: 8 × 3
#>   country name               result
#>   <chr>   <chr>               <dbl>
#> 1 GBR     Adam Peaty           57.4
#> 2 NED     Arno Kamminga        58  
#> 3 ITA     Nicolo Martinenghi   58.3
#> 4 USA     Michael Andrew       58.8
#> 5 GBR     James Wilby          59.0
#> 6 CHN     Zibei Yan            59.0
#> 7 USA     Andrew Wilson        59.0
#> 8 BLR     Ilya Shymanovich     59.4
```
