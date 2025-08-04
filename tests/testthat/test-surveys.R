test_that("list of surveys is not empty", {
  skip_if_offline("zenodo.org")
  skip_on_cran()
  skip_on_ci()
  expect_gt(nrow(list_surveys()), 0)
})

test_that("surveys can be downloaded with download_survey()", {
  skip_if_offline("zenodo.org")
  skip_on_cran()

  doi_peru <- "10.5281/zenodo.1095664"
  peru_survey_files <- suppressMessages(download_survey(doi_peru)) # nolint

  expect_true(all(file.exists(peru_survey_files)))
  # expect contains peru
  expect_true(all(grepl("peru", basename(peru_survey_files))))
})

test_that("multiple DOI's cannot be loaded", {
  skip_if_offline("zenodo.org")
  skip_on_cran()
  # nolint start
  doi_zimbabwe <- "10.5281/zenodo.1127693"
  expect_error(suppressMessages(download_survey(c(
    doi_peru,
    doi_zimbabwe
  ))))
  # nolint end
})
