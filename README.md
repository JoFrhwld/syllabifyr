
<!-- README.md is generated from README.Rmd. Please edit that file -->
syllabify <img src="man/figures/logo.png" align="right" />
==========================================================

[![Travis-CI Build Status](https://travis-ci.org/JoFrhwld/syllabify.svg?branch=master)](https://travis-ci.org/JoFrhwld/syllabify)

The goal of syllabify is to provide tidy syllabification of phonetic transcriptions. So far, only CMU dict transcriptions are supported.

I've largely utilized the same approach as [Kyle Gorman's python implementation](https://github.com/kylebgorman/syllabify)

Installation
------------

You can install syllabify from github with:

``` r
# install.packages("devtools")
devtools::install_github("JoFrhwld/syllabifyr")
```

Example
-------

``` r
library(syllabifyr)
syllabify("AO0 S T R EY1 L Y AH0")
#> Warning in evalq(as.numeric(~phone), <environment>): NAs introduced by
#> coercion
#> # A tibble: 8 x 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1    NA nucleus AO0   0     
#> 2    NA onset   S     0     
#> 3    NA onset   T     0     
#> 4    NA onset   R     0     
#> 5    NA nucleus EY1   1     
#> 6    NA coda    L     1     
#> 7    NA onset   Y     1     
#> 8    NA nucleus AH0   0
syllabify(c("AO0", "S", "T", "R", "EY1", "L", "Y", "AH0"))
#> Warning in evalq(as.numeric(~phone), <environment>): NAs introduced by
#> coercion
#> # A tibble: 8 x 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1    NA nucleus AO0   0     
#> 2    NA onset   S     0     
#> 3    NA onset   T     0     
#> 4    NA onset   R     0     
#> 5    NA nucleus EY1   1     
#> 6    NA coda    L     1     
#> 7    NA onset   Y     1     
#> 8    NA nucleus AH0   0
```

``` r
library(tidyverse)

syllabficiation <- tribble(~word, ~transcription,
                          "Alaska", "AH0 L AE1 S K AH0",
                          "constraint", "K AH0 N S T R EY1 N T",
                          "canyon", "K AE1 N Y AH0 N",
                          "value", "V AE1 L Y UW0")%>%
                        mutate(syllable_df = map(transcription, syllabify))
#> Warning in evalq(as.numeric(~phone), <environment>): NAs introduced by
#> coercion
#> Warning in evalq(as.numeric(~phone), <environment>): NAs introduced by
#> coercion
#> Warning in evalq(as.numeric(~phone), <environment>): NAs introduced by
#> coercion
#> Warning in evalq(as.numeric(~phone), <environment>): NAs introduced by
#> coercion
syllabficiation$syllable_df[[1]]
#> # A tibble: 6 x 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1    NA nucleus AH0   0     
#> 2    NA onset   L     0     
#> 3    NA nucleus AE1   1     
#> 4    NA coda    S     1     
#> 5    NA onset   K     1     
#> 6    NA nucleus AH0   0
syllabficiation$syllable_df[[2]]
#> # A tibble: 9 x 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1    NA onset   K     0     
#> 2    NA nucleus AH0   0     
#> 3    NA coda    N     0     
#> 4    NA onset   S     0     
#> 5    NA onset   T     0     
#> 6    NA onset   R     0     
#> 7    NA nucleus EY1   1     
#> 8    NA coda    N     1     
#> 9    NA coda    T     1
syllabficiation$syllable_df[[3]]
#> # A tibble: 6 x 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1    NA onset   K     1     
#> 2    NA nucleus AE1   1     
#> 3    NA coda    N     1     
#> 4    NA onset   Y     1     
#> 5    NA nucleus AH0   0     
#> 6    NA coda    N     0
syllabficiation$syllable_df[[4]]
#> # A tibble: 5 x 4
#>    syll part    phone stress
#>   <dbl> <chr>   <chr> <chr> 
#> 1    NA onset   V     1     
#> 2    NA nucleus AE1   1     
#> 3    NA coda    L     1     
#> 4    NA onset   Y     1     
#> 5    NA nucleus UW0   0
```
