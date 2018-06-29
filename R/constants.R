#' lax vowels
#'
SLAX <- c('IH1', 'IH2', 'EH1', 'EH2', 'AE1', 'AE2', 'AH1', 'AH2',
          'UH1', 'UH2')

#' Vowels
VOWELS <-  c('IY1', 'IY2', 'IY0', 'EY1', 'EY2', 'EY0', 'AA1', 'AA2', 'AA0',
             'ER1', 'ER2', 'ER0', 'AW1', 'AW2', 'AW0', 'AO1', 'AO2', 'AO0',
             'AY1', 'AY2', 'AY0', 'OW1', 'OW2', 'OW0', 'OY1', 'OY2', 'OY0',
             'IH0', 'EH0', 'AE0', 'AH0', 'UH0', 'UW1', 'UW2', 'UW0', 'UW',
             'IY',  'EY',  'AA',  'ER',   'AW', 'AO',  'AY',  'OW',  'OY',
             'UH',  'IH',  'EH',  'AE',  'AH',  'UH', SLAX)


#' medial onsets, size = 2
O2 <- list(
  c('P', 'R'),
  c('T', 'R'),
  c('K', 'R'),
  c('B', 'R'),
  c('D', 'R'),
  c('G', 'R'),
  c('F', 'R'),
  c('TH', 'R'),
  c('P', 'L'),
  c('K', 'L'),
  c('B', 'L'),
  c('G', 'L'),
  c('F', 'L'),
  c('S', 'L'),
  c('K', 'W'),
  c('G', 'W'),
  c('S', 'W'),
  c('S', 'P'),
  c('S', 'T'),
  c('S', 'K'),
  c('HH', 'Y'), # "clerihew"
  c('R', 'W'))

#' medial onsets, size = 3
O3 = list(c('S', 'T', 'R'),
          c('S', 'K', 'L'),
          c('T', 'R', 'W'))


#' CMU labels

cmu_labels <- c(
  VOWELS,
  "B",
  "CH",
  "D",
  "DH",
  "F",
  "G",
  "HH",
  "JH",
  "K",
  "L",
  "M",
  "N",
  "NG",
  "P",
  "R",
  "S",
  "SH",
  "T",
  "TH",
  "V",
  "W",
  "Y",
  "Z",
  "ZH"
)
