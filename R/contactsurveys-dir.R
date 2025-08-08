#' Default directory for persistent storage for contact surveys
#'
#' Use `contactsurveys_dir()` to view the default storage location for files
#' that are downloaded. The [download_survey()] function downloads files into
#' `contactsurveys_dir()`. This uses a directory that is specific to your
#' operating system, powered by the base function, [tools::R_user_dir()]. You
#' can override this by setting an environment variable, `CONTACTSURVEYS_HOME`.
#' The functions [list_surveys()] and [download_survey()] will use this default
#' directory. You can also specify the `dir` argument in these functions in
#' place of the default value, `contact_surveys_dir()`. This approach has been
#' borrowed from Carl Boetigger's `neonstore` R package.
#'
#' @return the active `contactsurveys` directory.
#' @export
#' @examples
#'
#' contactsurveys_dir()
#'
#' ## Override with an environmental variable:
#' Sys.setenv(CONTACTSURVEYS_HOME = tempdir())
#' contactsurveys_dir()
#' ## Unset
#' Sys.unsetenv("CONTACTSURVEYS_HOME")
#'
contactsurveys_dir <- function() {
  Sys.getenv(
    "CONTACTSURVEYS_HOME",
    tools::R_user_dir("contactsurveys")
  )
}
