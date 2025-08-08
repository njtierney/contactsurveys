test_that("list of surveys is not empty", {
  skip_if_offline("zenodo.org")
  skip_on_cran()
  skip_on_ci()
  expect_gt(nrow(list_surveys()), 0)
})
