## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval = T------------------------------------------------------------
devtools::install_github("patrickreidy/textgRid")

## ------------------------------------------------------------------------
library(textgRid)
library(syllabify)
library(dplyr)
library(purrr)
library(tidyr)

## ------------------------------------------------------------------------
tg_path <- system.file("extdata", "l_reading.TextGrid", package = "syllabify")
tg_df <- as.data.frame(TextGrid(tg_path))
head(tg_df)

## ------------------------------------------------------------------------
tg_df <- tg_df %>%
            select(-TierType)%>%
            separate(TierName, into = c("speaker", "tier_type"), sep = " - ")

## ------------------------------------------------------------------------
phon_tier <- tg_df %>% 
                filter(tier_type == "phone")%>%
                rename(phone_index = Index,
                       phone_end = EndTime,
                       phone = Label)%>%
                mutate(phone_start = StartTime)
word_tier <- tg_df %>% filter(tier_type == "word") %>%
                filter(tier_type == "word")%>%
                rename(word_index = Index,
                       word_end = EndTime,
                       word = Label)%>%
                mutate(word_start = StartTime)%>%
                select(-tier_type, -TierNumber)

## ------------------------------------------------------------------------
phon_tier %>%
  left_join(word_tier)%>%
  head()

## ------------------------------------------------------------------------
phon_tier %>%
  left_join(word_tier)%>%
  fill(starts_with("word")) %>%
  head()

## ------------------------------------------------------------------------
phon_tier %>%
  left_join(word_tier)%>%
  fill(starts_with("word"))%>%
  mutate(next_phone = lead(phone)) %>%
  group_by(word, word_index, word_start, word_end)%>%
  mutate(phone_n = 1:n(),
         position = case_when(n()==1 ~ "coextensive",
                              phone_n == 1 ~ "initial",
                              phone_n == n() ~ "final",
                              TRUE ~ "internal"))%>%
  head()

## ------------------------------------------------------------------------
word_nested <- phon_tier %>%
        left_join(word_tier) %>%
        fill(starts_with("word"))%>%
        mutate(next_phone = lead(phone)) %>%
        group_by(word, word_index, word_start, word_end) %>%
        mutate(phone_n = 1:n(),
               position = case_when(n()==1 ~ "coextensive",
                                    phone_n == 1 ~ "initial",
                                    phone_n == n() ~ "final",
                                    TRUE ~ "internal")) %>%
        nest()%>%
        filter(grepl("[A-Z]", word))

## ------------------------------------------------------------------------
head(word_nested)

## ------------------------------------------------------------------------
syllabified <- word_nested %>%
    mutate(syll_df = map(data, ~syllabify(.x$phone) %>% select(-phone)),
           joined = map2(data,
                         syll_df,
                         bind_cols))%>%
  unnest(joined)

head(syllabified)

## ------------------------------------------------------------------------
syllabified %>% 
  filter(phone == "L") %>%
  select(word, phone, position, part, stress, syll, next_phone)

