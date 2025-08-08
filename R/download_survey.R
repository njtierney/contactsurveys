#' Download a survey from its Zenodo repository
#'
#' @description Downloads survey data
#'
#' @param survey A DOI of a survey, (see [list_surveys()]). If a HTML link is
#'   given, the DOI will be isolated and used.
#' @param directory a directory to save the files to; if not given, will save to a
#'   temporary directory
#' @param verbose Whether downloads should be echoed to output. Default TRUE.
#' @param overwrite If files should be overwritten if they already exist.
#'   Default TRUE.
#' @param timeout A numeric value specifying timeout in seconds. Default 60
#'  seconds.
#'
#' @return a vector of filenames, where the surveys were downloaded
#'
#' @autoglobal
#' @examples
#' \dontrun{
#' list_surveys()
#' peru_survey <- download_survey("https://doi.org/10.5281/zenodo.1095664")
#' }
#' @seealso [list_surveys()]
#' @importFrom zen4R get_zenodo
#' @export
download_survey <- function(
  survey,
  directory = tempdir(),
  verbose = TRUE,
  overwrite = TRUE,
  timeout = 60
) {
  if (!is.character(survey) || length(survey) > 1) {
    stop("'survey' must be a character of length 1", call. = FALSE)
  }

  survey <- sub("^(https?:\\/\\/(dx\\.)?doi\\.org\\/|doi:)", "", survey)
  survey <- sub("#.*$", "", survey)
  is.doi <- is_doi(survey)
  is.url <- is.doi || grepl("^https?:\\/\\/", survey)

  if (!is.url) {
    stop("'survey' is not a DOI or URL.", call. = FALSE)
  }

  if (is.doi) {
    survey_url <- paste0("https://doi.org/", survey)
  } else {
    survey_url <- survey
  }

  message("Fetching contact survey filenames from DOI ", survey_url, ".")
  records <- get_zenodo(survey)

  files_already_exist <- zenodo_files_exist(directory, records)
  do_not_download <- files_already_exist && !overwrite
  if (do_not_download) {
    stop(
      "Files already exist, use `overwrite = TRUE` to overwrite.",
      call. = FALSE
    )
  } else {
    message("Downloading from ", survey_url, ".")
    records$downloadFiles(
      path = directory,
      quiet = !verbose,
      overwrite = overwrite,
      timeout = timeout
    )
    return(zenodo_files(directory, records))
  }
}

##' Checks if a character string is a DOI
##'
##' @param x Character vector; the string or strings to check
##' @return Logical; \code{TRUE} if \code{x} is a DOI, \code{FALSE} otherwise
##' @author Sebastian Funk
is_doi <- function(x) {
  is.character(x) && grepl("^10.[0-9.]{4,}/[-._;()/:A-z0-9]+$", x)
}
