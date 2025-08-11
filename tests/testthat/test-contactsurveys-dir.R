test_that("contactsurveys_dir()", {
  x <- contactsurveys_dir()
  expect_identical(x, Sys.getenv("CONTACTSURVEYS_HOME"))
})

test_that("contactsurveys_dir() falls back to R_user_dir when env unset", {
  withr::local_envvar(CONTACTSURVEYS_HOME = NA_character_)
  p <- contactsurveys_dir()
  expect_true(nzchar(p))
  expect_true(
    dir.exists(p),
    info = "contactsurveys_dir() should ensure the directory exists"
  )
})

test_that("empty CONTACTSURVEYS_HOME falls back and creates dir", {
  withr::local_envvar(CONTACTSURVEYS_HOME = "")
  p <- contactsurveys_dir()
  expect_true(nzchar(p))
  expect_true(dir.exists(p))
})
