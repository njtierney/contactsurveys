test_that("list of surveys is not empty", {
  skip_if_offline("zenodo.org")
  skip_on_cran()
  skip_on_ci()
  ls_time1 <- system.time(dat <- list_surveys())
  expect_s3_class(dat, c("data.table", "data.frame"))
  expect_gt(nrow(dat), 0)
  expect_true(all(c("title", "creator") %in% names(dat)))
  # verify file exists
  survey_path <- list.files(
    path = contactsurveys_dir(),
    pattern = "survey_list.rds",
    full.names = TRUE
  )
  expect_true(file.exists(survey_path))

  # verify time taken is shorter on a second run
  ls_time2 <- system.time(dat2 <- list_surveys())

  expect_lt(ls_time2["elapsed"], ls_time1["elapsed"])

  # verify message when overwrite = FALSE
  expect_snapshot(
    . <- list_surveys()
  )
})
