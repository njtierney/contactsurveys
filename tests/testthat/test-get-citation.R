test_that("get_citation() works", {
  polymod_doi <- "https://doi.org/10.5281/zenodo.3874557"
  polymod_citation <- get_citation(polymod_doi)
  expect_type(polymod_citation, "character")
  expect_gt(nchar(polymod_citation), 1)
  # verbosity works
  expect_message(get_citation(polymod_citation), "Citation fetched")
  expect_snapshot(get_citation(polymod_citation, verbose = FALSE))
})
