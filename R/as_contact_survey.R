#' @title Check and coerce to contact survey data
#'
#' @description Checks if a survey fulfills all the requirements to work with
#'   the 'contact_matrix' function.
#'
#' @param x list containing:
#'  - an element named 'participants', a data frame containing participant
#'   information.
#'  - an element named 'contacts', a data frame containing contact information.
#'  - (optionally) an element named 'reference', a list containing information
#'   information needed to reference the survey, in particular it can contain:
#'   "title", "bibtype", "author", "doi", "publisher", "note", "year".
#' @param id.column the column in both the `participants` and `contacts` data
#'   frames that links contacts to participants.
#' @param country.column the column in the `participants` data frame containing
#'   the country in which the participant was queried.
#' @param year.column the column in the `participants` data frame containing
#'   the year in which the participant was queried.
#' @importFrom checkmate assert_list assert_names assert_data_frame
#'   assert_character
#' @importFrom purrr walk
#' @importFrom data.table setnames fifelse tstrsplit
#' @return invisibly returns a character vector of the relevant columns
#' @examples
#' \dontrun{
#' # not run because it requires an internet connection
#' polymod_url <- "https://doi.org/10.5281/zenodo.3874557"
#' polymod <- get_survey(polymod_url)
#' polymod
#' as_contact_survey(polymod)
#' }
#' @export
as_contact_survey <- function(
  x,
  id.column = "part_id",
  country.column = "country",
  year.column = "year"
) {
  ## check arguments
  assert_list(x, names = "named")
  assert_names(names(x), must.include = c("participants", "contacts"))
  assert_data_frame(x$participants)
  assert_data_frame(x$contacts)
  assert_list(x$reference, names = "named", null.ok = TRUE)
  assert_character(id.column)
  assert_character(year.column, null.ok = TRUE)
  assert_character(country.column, null.ok = TRUE)
  assert_names(colnames(x$participants), must.include = id.column)
  assert_names(colnames(x$contacts), must.include = id.column)

  setnames(x$participants, id.column, "part_id")
  setnames(x$contacts, id.column, "part_id")

  ## check optional columns exist if provided
  to_check <- list(
    country = country.column,
    year = year.column
  )

  walk(
    .x = names(to_check),
    .f = function(column) {
      col_name <- to_check[[column]]
      name_provided <- !is.null(col_name)
      name_not_in_participants <- !(col_name %in% colnames(x$participants))
      column_not_in_participants <- name_provided && name_not_in_participants

      if (column_not_in_participants) {
        stop(
          column,
          " column '",
          col_name,
          "' does not exist ",
          "in the participant data frame",
          call. = FALSE
        )
      } else if (name_provided) {
        # rename only when a column name was provided
        setnames(x$participants, col_name, column)
      }
    }
  )

  if (is.null(x$reference)) {
    warning("No reference provided", call. = FALSE)
  }

  survey <- new_contact_survey(
    participants = x$participants,
    contacts = x$contacts,
    reference = x$reference
  )
  survey <- clean(survey)

  return(survey)
}
