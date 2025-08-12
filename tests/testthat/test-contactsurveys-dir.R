test_that("contactsurveys_dir()", {
  x <- contactsurveys_dir()
  expect_identical(x, Sys.getenv("CONTACTSURVEYS_HOME"))
})

test_that("contactsurveys_dir() falls back to R_user_dir when env set to NA", {
  withr::local_envvar(CONTACTSURVEYS_HOME = NA_character_)
  p <- contactsurveys_dir()
  expect_true(nzchar(p))
  expect_identical(
    p,
    tools::R_user_dir("contactsurveys")
  )
})

test_that("empty CONTACTSURVEYS_HOME falls back to R_user_dir when env empty", {
  withr::local_envvar(CONTACTSURVEYS_HOME = "")
  p <- contactsurveys_dir()
  expect_true(nzchar(p))
  expect_identical(
    p,
    tools::R_user_dir("contactsurveys")
  )
})
