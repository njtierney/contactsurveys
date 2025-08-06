#' Citation for a survey
#'
#' @description Gets a full citation from a DOI
#'
#' @param doi A DOI.
#' @param style Optional. Citation style.
#' @param ... Passed to `zen4R::get_citation()`.
#'
#' @returns
#' A citation. Prints a message with citation instructions.
#'
#' @examples
#' \dontrun{
#' # not run because it requires an internet connection
#' polymod_url <- "https://doi.org/10.5281/zenodo.3874557"
#' citation <- get_citation(polymod)
#' }
#' @export
get_citation <- function(doi, style = "apa", ...) {
  doi_citation <- zen4R::get_citation(
    doi = doi,
    style = style,
    ...
  )
  # need to capture bad/empty results (e.g., where style isn't specified)

  message("To cite ", doi, " in publications use:")
  doi_citation
}
