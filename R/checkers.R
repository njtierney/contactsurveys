check_survey_is_length_one <- function(survey, call = rlang::caller_env()) {
  if (
    !is.character(survey) ||
      length(survey) != 1L ||
      is.na(survey) ||
      !nzchar(survey)
  ) {
    cli::cli_abort(
      message = c(
        "{.arg survey} must be a character of length 1.",
        "i" = "We see survey is of length {.val {length(survey)}}:", # nolint
        "{survey}"
      ),
      call = call
    )
  }
}

check_survey_is_url_doi <- function(survey, call = rlang::caller_env()) {
  is_url <- is_doi(survey) || grepl("^https?://", survey)
  not_url <- !isTRUE(is_url)
  if (not_url) {
    cli::cli_abort(
      message = c(
        "'survey' must be a DOI or URL.",
        "We see: {.val survey}"
      ),
      call = call
    )
  }
}

check_directory <- function(directory, call = rlang::caller_env()) {
  is_contactsurveys_dir <- identical(
    path.expand(directory),
    path.expand(contactsurveys_dir())
  )
  if (!is_contactsurveys_dir) {
    cli::cli_warn(
      message = c(
        "Directory differs from {.fn contactsurveys_dir}",
        "!" = "Files may persist between R sessions.",
        "i" = "See {.fn contactsurveys_dir} for more details." # nolint
      ),
      call = call
    )
  }
}
