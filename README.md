
<!-- README.md is generated from README.Rmd. Please edit that file -->

# syllabifyr <img src="man/figures/logo.png" align="right" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/JoFrhwld/syllabifyr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/JoFrhwld/syllabifyr/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/syllabifyr.png)](https://CRAN.R-project.org/package=syllabifyr)
[![DOI](https://zenodo.org/badge/139162633.svg)](https://zenodo.org/badge/latestdoi/139162633)
<!-- badges: end -->

The goal of `syllabifyr` is to provide tidy syllabification of phonetic
transcriptions. So far, only CMU dict transcriptions are supported.

I’ve largely utilized the same approach as [Kyle Gorman’s python
implementation](https://github.com/kylebgorman/syllabify)

## Installation

`syllabifyr` is now on Cran

``` r
install.packages("syllabifyr")
```

You can also install `syllabifyr` from github with:

``` r
# install.packages("devtools")
devtools::install_github("JoFrhwld/syllabifyr")
```

## Example

``` r
library(syllabifyr)
syllabify("AO0 S T R EY1 L Y AH0")
#> # A tibble: 8 × 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1     1 nucleus AO    0     
#> 2     2 onset   S     1     
#> 3     2 onset   T     1     
#> 4     2 onset   R     1     
#> 5     2 nucleus EY    1     
#> 6     2 coda    L     1     
#> 7     3 onset   Y     0     
#> 8     3 nucleus AH    0
syllabify(c("AO0", "S", "T", "R", "EY1", "L", "Y", "AH0"))
#> # A tibble: 8 × 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1     1 nucleus AO    0     
#> 2     2 onset   S     1     
#> 3     2 onset   T     1     
#> 4     2 onset   R     1     
#> 5     2 nucleus EY    1     
#> 6     2 coda    L     1     
#> 7     3 onset   Y     0     
#> 8     3 nucleus AH    0
```

``` r
library(tidyverse)
#> Warning: package 'ggplot2' was built under R version 4.3.1
#> Warning: package 'lubridate' was built under R version 4.3.1

syllabficiation <- tribble(~word, ~transcription,
                          "Alaska", "AH0 L AE1 S K AH0",
                          "constraint", "K AH0 N S T R EY1 N T",
                          "canyon", "K AE1 N Y AH0 N",
                          "value", "V AE1 L Y UW0")%>%
                        mutate(syllable_df = map(transcription, syllabify))
syllabficiation$syllable_df[[1]]
#> # A tibble: 6 × 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1     1 nucleus AH    0     
#> 2     2 onset   L     1     
#> 3     2 nucleus AE    1     
#> 4     2 coda    S     1     
#> 5     3 onset   K     0     
#> 6     3 nucleus AH    0
syllabficiation$syllable_df[[2]]
#> # A tibble: 9 × 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1     1 onset   K     0     
#> 2     1 nucleus AH    0     
#> 3     1 coda    N     0     
#> 4     2 onset   S     1     
#> 5     2 onset   T     1     
#> 6     2 onset   R     1     
#> 7     2 nucleus EY    1     
#> 8     2 coda    N     1     
#> 9     2 coda    T     1
syllabficiation$syllable_df[[3]]
#> # A tibble: 6 × 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1     1 onset   K     1     
#> 2     1 nucleus AE    1     
#> 3     1 coda    N     1     
#> 4     2 onset   Y     0     
#> 5     2 nucleus AH    0     
#> 6     2 coda    N     0
syllabficiation$syllable_df[[4]]
#> # A tibble: 5 × 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1     1 onset   V     1     
#> 2     1 nucleus AE    1     
#> 3     1 coda    L     1     
#> 4     2 onset   Y     0     
#> 5     2 nucleus UW    0
```
