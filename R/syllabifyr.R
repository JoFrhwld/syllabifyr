#' Syllabify: A package for doing tidy syllabification
#'
#' This is a package to do tidy syllabification of phonetic transcriptions.
#' The syllabifier "maximizes onset".
#' The algorithmic approach to this is adapted from Kyle Gorman's python implementation
#' (\url{https://github.com/kylebgorman/syllabify})
#'
#' @section Functions:
#' The key function is \code{syllabify()}. Given a CMU transcription,
#' it will return a tibble. See \code{?syllabify()} for more info.
#'
#' Also available is \code{syllabify_list()}. This is a list representation
#' of the syllables. See \code{?syllabify_list()} for more info.
#'
#' @docType package
#' @name syllabifyr
NULL
