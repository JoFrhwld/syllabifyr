
<!-- README.md is generated from README.Rmd. Please edit that file -->
syllabify
=========

[![Travis-CI Build Status](https://travis-ci.org/JoFrhwld/syllabify.svg?branch=master)](https://travis-ci.org/JoFrhwld/syllabify)

The goal of syllabify is to provide tidy syllabification of phonetic transcriptions. So far, only CMU dict transcriptions are supported.

I've largely utilized the same approach as [Kyle Gorman's python implementation](https://github.com/kylebgorman/syllabify)

Installation
------------

You can install syllabify from github with:

``` r
# install.packages("devtools")
devtools::install_github("JoFrhwld/syllabify")
```

Example
-------

``` r
library(syllabify)
syllabify("AO0 S T R EY1 L Y AH0")
#> # A tibble: 8 x 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1     1 nucleus AO0   0     
#> 2     2 onset   S     1     
#> 3     2 onset   T     1     
#> 4     2 onset   R     1     
#> 5     2 nucleus EY1   1     
#> 6     2 coda    L     1     
#> 7     3 onset   Y     0     
#> 8     3 nucleus AH0   0
syllabify(c("AO0", "S", "T", "R", "EY1", "L", "Y", "AH0"))
#> # A tibble: 8 x 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1     1 nucleus AO0   0     
#> 2     2 onset   S     1     
#> 3     2 onset   T     1     
#> 4     2 onset   R     1     
#> 5     2 nucleus EY1   1     
#> 6     2 coda    L     1     
#> 7     3 onset   Y     0     
#> 8     3 nucleus AH0   0
```

``` r
library(tidyverse)

syllabficiation <- tribble(~word, ~transcription,
                          "Alaska", "AH0 L AE1 S K AH0",
                          "constraint", "K AH0 N S T R EY1 N T",
                          "canyon", "K AE1 N Y AH0 N",
                          "value", "V AE1 L Y UW0")%>%
                        mutate(syllable_df = map(transcription, syllabify))
syllabficiation$syllable_df[[1]]
#> # A tibble: 6 x 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1     1 nucleus AH0   0     
#> 2     2 onset   L     1     
#> 3     2 nucleus AE1   1     
#> 4     2 coda    S     1     
#> 5     3 onset   K     0     
#> 6     3 nucleus AH0   0
syllabficiation$syllable_df[[2]]
#> # A tibble: 9 x 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1     1 onset   K     0     
#> 2     1 nucleus AH0   0     
#> 3     1 coda    N     0     
#> 4     2 onset   S     1     
#> 5     2 onset   T     1     
#> 6     2 onset   R     1     
#> 7     2 nucleus EY1   1     
#> 8     2 coda    N     1     
#> 9     2 coda    T     1
syllabficiation$syllable_df[[3]]
#> # A tibble: 6 x 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1     1 onset   K     1     
#> 2     1 nucleus AE1   1     
#> 3     1 coda    N     1     
#> 4     2 onset   Y     0     
#> 5     2 nucleus AH0   0     
#> 6     2 coda    N     0
syllabficiation$syllable_df[[4]]
#> # A tibble: 5 x 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1     1 onset   V     1     
#> 2     1 nucleus AE1   1     
#> 3     1 coda    L     1     
#> 4     2 onset   Y     0     
#> 5     2 nucleus UW0   0
```
