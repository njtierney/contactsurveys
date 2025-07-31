#' @title Citation for a survey
#'
#' @description Gets a full citation for a "contact_survey" object, created
#'   with [as_contact_survey()].
#'
#' @param x a character vector of surveys to cite
#' @return citation as bibentry
#' @importFrom httr GET content
#' @importFrom utils bibentry
#' @examples
#' \dontrun{
#' # not run because it requires an internet connection
#' current_surveys <- list_surveys()
#' polymod_url <- subset(current_surveys, grepl("POLYMOD", title))[["url"]]
#' # "https://doi.org/10.5281/zenodo.3874557"
#' polymod <- get_survey(polymod_url)
#' polymod
#' citation <- get_citation(polymod)
#' print(citation)
#' print(citation, style = "bibtex")
#' }
#' @export
get_citation <- function(x) {
  survey <- get_survey(x)
  if (is.null(x$reference)) {
    stop("No citation defined for ", ifelse(is.null(x$name), "survey", x$name))
  }

  ref <- c(
    list(header = gettextf("To cite %s in publications use:", x$ref$title)),
    x$reference
  )

  bref <- do.call(bibentry, ref)

  return(bref)
}
