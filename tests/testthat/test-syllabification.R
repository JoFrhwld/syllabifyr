context("syllabification")



test_that("Syllabification returns data frames", {
  syls_df <- syllabify_test_dict %>%
    mutate(syl_df = map(trans, ~try(syllabify(.x))),
           class = map(syl_df, ~class(.x)[1]) %>% simplify())

  for(i in seq_along(syls_df$syl_df)){
    expect_is(syls_df$syl_df[[i]], "tbl_df")
  }
})


test_that("Check Pronunciation", {
  expect_equal(length(pronunciation_check_cmu("F UW1")), 2)
  expect_equal(length(pronunciation_check_cmu("F  UW1")), 2)
  expect_error(pronunciation_check_cmu("C"), "Not a licit CMU transcription label: C")
})



test_that("Check Pronunciation", {
  expect_equal(length(pronunciation_check_cmu("F UW1")), 2)
  expect_equal(length(pronunciation_check_cmu("F  UW1")), 2)
  expect_error(pronunciation_check_cmu("C"), "Not a licit CMU transcription label: C")
})


test_that("Data columns", {
  syls_df <- syllabify_test_dict %>%
    mutate(syl_df = map(trans, ~try(syllabify(.x))))%>%
    unnest(syl_df)

  expect_type(syls_df$syll, "double")
  expect_type(syls_df$part, "character")
  expect_type(syls_df$phone, "character")
  expect_type(syls_df$stress, "character")

  expect_true(all(syls_df$stress %in% c("0", "1", "2", NA)))
  expect_true(all(syls_df$part %in% c("onset", "nucleus", "coda")))
})
