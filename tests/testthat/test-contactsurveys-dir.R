test_that("contactsurveys_dir()", {
  x <- contactsurveys_dir()
  expect_identical(x, Sys.getenv("CONTACTSURVEYS_HOME"))
})
