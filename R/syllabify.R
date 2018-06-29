#' syllabify
#'
#' @import purrr

syllabify_list <- function(pron, alaska_rule = TRUE){

  nsyl <- sum(pron %in% VOWELS)
  nuclei <- vector("list", nsyl)
  onsets <- vector("list", nsyl)
  codas <- vector("list", nsyl)

  phon_indices <- seq_along(pron)
  vowel_indices <- which(pron %in% VOWELS)
  # here, incorporate defective transcriptions
  onset_indices <- make_onset_indices(vowel_indices)

  for(i in seq_along(nuclei)){
    nuclei[[i]] <- pron[vowel_indices[i]]
    onsets[[i]] <- pron[onset_indices[[i]]]
  }
  if(length(pron) > max(vowel_indices)){
    codas[[length(codas)]] <- pron[(vowel_indices[length(vowel_indices)] + 1):length(pron)]
  }

  if(length(nuclei)>1){
    for(i in seq_along(nuclei)[-1]){
      coda = c()
      if(length(onsets[[i]] > 1 &
                  onsets[[i]][1] == "R")){
        nuclei[[i-1]] <- c(nuclei[[i-1]], "R")
        onsets[[i]] <- onsets[[i]][-1]
      }

      if(length(onsets[[i]]) > 2 &
          onsets[[length(onsets)]] == "Y"){
        nuclei[[i]] <- c("Y", nuclei[[o]])
        onsets[[i]] <- onsets[[i]][-length(onsets[[i]])]
      }

      if(length(onsets[[i]]) > 1 &
          alaska_rule &
          nuclei[[i-1]][length(nuclei[[i-1]])] %in% syllabify::SLAX &
          onsets[[i]][1] == "S"){
          coda <- c(coda, "S")
          onsets[[i]] <- onsets[[i]][-1]
      }

      depth = 1
      if(length(onsets[[i]]) > 1){
        two_onset <- map(O2, ~all(tail(onsets[[i]], 2) %in% .x)) %>% simplify()
        if(any(two_onset)){
          three_onset <- map(O3, ~all(tail(onsets[[i]], 3) %in% .x)) %>% simplify()
          depth <- ifelse(three_onset, 3, 2)
        }
      }
      if(length(onsets[[i]])-depth > 0){
        for(j in seq(length(onsets[[i]])-depth)){
          coda <- c(coda, onsets[[i]][1])
          onsets[[i]] <- onsets[[i]][-1]
        }
      }
      codas[[i-1]] <- coda
    }
  }

  return(list(onsets, nuclei, codas))
}


#' make onset indices
#'
make_onset_indices <- function(nuclei_indices){
  output <- vector("list", length(nuclei_indices))
  if(nuclei_indices[1] == 1){
    output[[1]] <- NULL
  }else{
    output[[1]] <- 1:(nuclei_indices[[1]]-1)
  }
  if(length(nuclei_indices) > 1){
    for(i in 2:length(nuclei_indices)){
      if(nuclei_indices[[i]] - nuclei_indices[[i-1]] > 1){
        output[[i]] <- (nuclei_indices[[i-1]]+1):(nuclei_indices[[i]]-1)
      }else{
        output[[i]] <- NULL
      }
    }
  }
  return(output)
}
