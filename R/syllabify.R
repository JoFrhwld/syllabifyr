#' Syllabify
#'
#' This will take a transcription as input, and return it as a data frame.
#'
#' @param pron The CMU dictionary pronunciation, either as a vector,
#' or a string with labels separated by spaces
#' @param alaska_rule Don't maximize onset on lax vowel + s sequences
#'
#' @return Returns a data frame with the following columns
#' \describe{
#'   \item{syll}{A numeric index for each syllable}
#'   \item{part}{What part of the syllable each phone belongs to}
#'   \item{phone}{The phone label from the transcription}
#'   \item{stress}{The syllable stress}
#' }
#'
#' @import purrr
#' @import tibble
#' @import dplyr
#' @import tidyr
#'
#' @examples
#' # String input
#' syllabify("AO0 S T R EY1 L Y AH0")
#'
#' # Vector input
#' syllabify(c("AO0", "S", "T", "R", "EY1", "L", "Y", "AH0"))
#'
#' # Hiatus
#' syllabify("HH AY0 EY1 T AH0 S")
#'
#' # Deficient transcriptions (has warning)
#' syllabify(c("M"))
#' @export

syllabify <- function(pron, alaska_rule = T){
  syll_list <- syllabify_list(pron, alaska_rule)
  phone <- quo(phone)
  syll <- quo(syll)
  stress <- quo(stress)
  nsyl <- length(syll_list)
  output <- syll_list %>%
    map(~.x %>% keep(~length(.x) > 0)) %>%
    map(~.x %>% map(~ data_frame(phone = .x))) %>%
    set_names(seq(nsyl)) %>%
    map(~.x %>% bind_rows(.id = "part")) %>%
    dplyr::bind_rows(.id = "syll") %>%
    mutate(syll = as.numeric(!!syll)) %>%
    group_by(syll) %>%
    mutate(stress = gsub(".*([0-9])", "\\1", !!phone),
           stress = case_when(stress %in% c("0", "1", "2") ~ stress),
           phone = gsub("[0-9]", "", !!phone)) %>%
    fill(stress) %>%
    fill(stress, .direction = "up") %>%
    ungroup()
  return(output)
}

#' Syllabify to a list
#'
#' This will take a transcription as input, and return it as a list.
#'
#' @param pron The CMU dictionary pronunciation, either as a vector,
#' or a string with labels separated by spaces
#' @param alaska_rule Don't maximize onset on lax vowel + s sequences
#' @import purrr
#'
#' @return A with one value per syllable. Each value is a list, with three
#' values: onset, nucleus, coda. Each will contain a vector of the phones
#' which belong to each constituent part of the syllable. Any empty
#' constituent parts will have the value \code{character(0)}
#'
#' @examples
#' # String input
#' syllabify_list("AO0 S T R EY1 L Y AH0")
#'
#' # Vector input
#' syllabify_list(c("AO0", "S", "T", "R", "EY1", "L", "Y", "AH0"))
#' # Hiatus
#' syllabify_list("HH AY0 EY1 T AH0 S")
#'
#' # Deficient transcriptions (has warning)
#' syllabify_list(c("M"))
#' @export

syllabify_list <- function(pron, alaska_rule = TRUE){

  pron <- pronunciation_check_cmu(pron)
  nsyl <- sum(pron %in% VOWELS)
  if (nsyl < 1){
    warning(paste0("transcription '",
                   paste(pron, collapse = " "),
                   "' is defective"))
    nuclei <- list(character(0))
    onsets <- list(pron)
    codas  <- list(character(0))
  }else{
    nuclei <- vector("list", nsyl) %>%
                map(~character(0))
    onsets <- vector("list", nsyl) %>%
                map(~character(0))
    codas  <- vector("list", nsyl) %>%
                map(~character(0))

    vowel_indices <- which(pron %in% VOWELS)


    onset_indices <- make_onset_indices(vowel_indices)

    for (i in seq_along(nuclei)){
      nuclei[[i]] <- pron[vowel_indices[i]]
      onsets[[i]] <- pron[onset_indices[[i]]]
    }
    if (length(pron) > max(vowel_indices)){
      codas[[length(codas)]] <- pron[(vowel_indices[length(vowel_indices)] + 1):length(pron)]
    }

    if (length(nuclei) > 1){
      for (i in seq_along(nuclei)[-1]){
        coda <- character(0)
        if (length(onsets[[i]]) > 1 &
                    onsets[[i]][1] == "R"){
          codas[[i - 1]] <- c(codas[[i - 1]], "R")
          onsets[[i]] <- onsets[[i]][-1]
        }

        if (length(onsets[[i]]) > 2){
          if (onsets[[i]][length(onsets[[i]])] == "Y"){
            nuclei[[i]] <- c("Y", nuclei[[i]])
            onsets[[i]] <- onsets[[i]][-length(onsets[[i]])]
          }
        }

        if (length(onsets[[i]]) > 1 &
            alaska_rule &
            nuclei[[i - 1]][length(nuclei[[i - 1]])] %in% SLAX &
            onsets[[i]][1] == "S"){
            coda <- c(coda, "S")
            onsets[[i]] <- onsets[[i]][-1]
        }

        depth <- 1
        if (length(onsets[[i]]) > 1){
          two_onset <- map(O2, ~all(tail(onsets[[i]], 2) %in% .x)) %>%
                            simplify()
          if (any(two_onset)){
            three_onset <- map(O3, ~all(tail(onsets[[i]], 3) %in% .x)) %>%
                                simplify()
            depth <- ifelse(any(three_onset), 3, 2)
          }
        }
        if ( (length(onsets[[i]]) - depth) > 0){
          for (j in seq(length(onsets[[i]]) - depth)){
            coda <- c(coda, onsets[[i]][1])
            onsets[[i]] <- onsets[[i]][-1]
          }
        }
        codas[[i - 1]] <- c(codas[[i-1]], coda)
      }
    }
  }

  output <- transpose(list(onsets, nuclei, codas)) %>%
                map(~.x %>% set_names(c("onset", "nucleus", "coda")))
  return(output)
}

#' make onset indices
#' @keywords internal
make_onset_indices <- function(nuclei_indices){
  output <- vector("list", length(nuclei_indices))
  if (nuclei_indices[1] == 1){
    output[[1]] <- numeric(0)
  }else{
    output[[1]] <- 1:(nuclei_indices[[1]] - 1)
  }
  if (length(nuclei_indices) > 1){
    for (i in 2:length(nuclei_indices)){
      if (nuclei_indices[[i]] - nuclei_indices[[i - 1]] > 1){
        output[[i]] <- (nuclei_indices[[i - 1]] + 1):(nuclei_indices[[i]] - 1)
      }else{
        output[[i]] <- numeric(0)
      }
    }
  }
  return(output)
}

#' CMU pronunciation check
#' @importFrom stringr str_split
#' @keywords internal

pronunciation_check_cmu <- function(pron){
  if (length(pron) == 1){
    pron <- str_split(pron, "\\s+")[[1]]
  }
  if (!all(pron %in% cmu_labels)){
    bad_pron <- pron[which(!pron %in% cmu_labels)]
    stop(paste0("Not a licit CMU transcription label: ",
                paste(bad_pron, collapse = ", ")))
  }
  return(pron)
}
