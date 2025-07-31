#' List all surveys available for download
#'
#' @return character vector of surveys
#' @inheritParams get_survey
#' @importFrom memoise memoise
#' @examples
#' \dontrun{
#' list_surveys()
#' }
#' @export
list_surveys <- function(clear_cache = FALSE) {
  if (
    !("list_surveys" %in% names(contactsurveys$cached_functions)) ||
      clear_cache
  ) {
    contactsurveys$cached_functions$list_surveys <- memoise(.list_surveys)
  }
  contactsurveys$cached_functions$list_surveys()
}

#' @autoglobal
#' @importFrom oai list_records
#' @importFrom data.table data.table setkey rbindlist
#' @keywords internal
.list_surveys <- function() {
  record_list <-
    data.table(list_records(
      url = "https://zenodo.org/oai2d",
      metadataPrefix = "oai_datacite",
      set = "user-social_contact_data"
    ))
  ## find common DOI for different versions, i.e. the "relation" that is a DOI
  relations <- grep("^relation(\\.|$)", colnames(record_list), value = TRUE)
  DOIs <- apply(
    X = record_list,
    MARGIN = 1,
    FUN = function(x) {
      min(grep("^https://doi.org/.*zenodo", x[relations], value = TRUE))
    }
  )
  record_list <- record_list[, common_doi := DOIs]
  record_list <- record_list[,
    url := sub("doi:", "https://doi.org/", common_doi, fixed = TRUE)
  ]
  ## get number within version DOI, this is expected to be ascending by version
  record_list <-
    record_list[,
      doi.nb := as.integer(sub("^.*zenodo\\.org:", "", identifier.1))
    ]
  ## save date at which first entered
  record_list <- record_list[, date := min(date), by = common_doi]
  ## order by DOI number and extract newest version
  record_list <- record_list[order(-doi.nb)]
  record_list <- record_list[, .SD[1], by = common_doi]
  ## order by date
  setkey(record_list, date)
  return(record_list[, list(
    date_added = date,
    title,
    creator,
    url = identifier.2
  )])
}

#' List all countries contained in a survey
#'
#' @param country.column column in the survey indicating the country
#' @param ... further arguments for [get_survey()]
#' @return list of countries
#' @inheritParams get_survey
#' @examples
#' \dontrun{
#' # not run because it requires an internet connection
#' current_surveys <- list_surveys()
#' polymod_url <- subset(current_surveys, grepl("POLYMOD", title))[["url"]]
#' # "https://doi.org/10.5281/zenodo.3874557"
#' polymod <- get_survey(polymod_url)
#' polymod
#' survey_countries(polymod)
#' }
#' @export
survey_countries <- function(survey, country.column = "country", ...) {
  survey <- get_survey(survey, ...)
  return(as.character(unique(survey[["participants"]][[country.column]])))
}
