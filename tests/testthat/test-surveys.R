test_that("surveys can be downloaded with download_survey()", {
  skip_if_offline("zenodo.org")
  skip_on_cran()

  doi_peru <- "10.5281/zenodo.1095664" # nolint
  peru_survey_files <- suppressMessages(download_survey(doi_peru))

  expect_true(all(file.exists(peru_survey_files)))
  # expect contains peru
  expect_true(all(grepl("Peru", basename(peru_survey_files), fixed = TRUE)))
  expect_snapshot(basename(peru_survey_files))
  # expect message from downloading again
  expect_snapshot(
    . <- download_survey(doi_peru, overwrite = FALSE) # nolint
  )
  # expect files are the same
  peru_2 <- suppressMessages(download_survey(doi_peru, overwrite = FALSE))
  expect_identical(basename(peru_2), basename(peru_survey_files))

  # expect timings are faster on cache
  ds_time2 <- system.time(suppressMessages(download_survey(
    doi_peru,
    overwrite = FALSE
  )))
  ds_time1 <- system.time(suppressMessages(download_survey(
    doi_peru,
    overwrite = TRUE
  )))

  expect_lt(ds_time2["elapsed"], ds_time1["elapsed"])
})

test_that("multiple DOI's cannot be loaded", {
  skip_if_offline("zenodo.org")
  skip_on_cran()
  # nolint start
  doi_peru <- "10.5281/zenodo.1095664"
  doi_zimbabwe <- "10.5281/zenodo.1127693"
  expect_error(suppressMessages(download_survey(c(
    doi_peru,
    doi_zimbabwe
  ))))
  # nolint end
})
