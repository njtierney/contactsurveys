#' Check if Zenodo files exist
#'
#' For use inside [download_survey()].
#'
#' @param directory A single string specifying the directory path.
#' @param records A records object with a `files` component.
#' @noRd
#' @note internal
#'
#' @returns TRUE/FALSE indicating whether all files exist
zenodo_files_exist <- function(directory, records) {
  the_zenodo_files <- zenodo_files(directory, records)
  if (is.character(the_zenodo_files)) {
    return(TRUE)
  } else if (is.null(the_zenodo_files)) {
    return(FALSE)
  }
}

zenodo_files <- function(directory, records) {
  zenodo_files <- file.path(directory, names(records$files))
  do_all_files_exist <- all(file.exists(zenodo_files))
  if (do_all_files_exist) {
    return(zenodo_files)
  } else {
    return(NULL)
  }
}
