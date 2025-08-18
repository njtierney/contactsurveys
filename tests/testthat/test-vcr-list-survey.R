test_that("list_surveys() works", {
  vcr::local_cassette("list-survey")
  survey_data <- list_surveys(overwrite = TRUE)
  expect_named(survey_data, c("date_added", "title", "creator", "url"))
})
