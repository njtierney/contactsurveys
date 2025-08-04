#' Download a survey from its Zenodo repository
#'
#' @description Downloads survey data
#' @param survey a URL (see [list_surveys()])
#' @param dir a directory to save the files to; if not given, will save to a
#'   temporary directory
#' @param sleep time to sleep between requests to avoid overloading the server
#'   (passed on to \code{\link[base]{Sys.sleep}})
#' @importFrom httr GET content status_code http_error config user_agent
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom curl curl_download
#' @importFrom utils read.csv packageVersion
#' @importFrom xml2 xml_text xml_find_first xml_find_all xml_attr
#' @autoglobal
#' @examples
#' \dontrun{
#' list_surveys()
#' peru_survey <- download_survey("https://doi.org/10.5281/zenodo.1095664")
#' }
#' @return a vector of filenames that can be used with [load_survey()]
#' @seealso [load_survey()]
#' @export
download_survey <- function(survey, dir = NULL, sleep = 1, overwrite = FALSE) {
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

  temp_body <- GET(
    survey_url,
    config = config(
      followlocation = 1
    )
  )

  temp_body <- GET(
    survey_url,
    config = config(
      followlocation = 1
    ),
    user_agent(paste0(
      "http://github.com/epiforecasts/contactsurveys R package contactsurveys/v.",
      packageVersion("contactsurveys")
    ))
  )
  if (status_code(temp_body) == 404) {
    stop("DOI '", survey, "' not found", call. = FALSE)
  }
  if (http_error(temp_body)) {
    stop(
      "Could not fetch the resource. ",
      "This could an issue with the website server or your own connection.",
      call. = FALSE
    )
  }

  parsed_body <- content(temp_body, encoding = "UTF-8")
  parsed_cite <- fromJSON(
    xml_text(
      xml_find_first(parsed_body, '//script[@type="application/ld+json"]')
    )
  )

  reference <- list(
    title = parsed_cite$name,
    bibtype = "Misc",
    author = parsed_cite$author$name,
    year = data.table::year(parsed_cite$datePublished)
  )
  if ("version" %in% names(parsed_cite)) {
    reference[["note"]] <- paste("Version", parsed_cite$version)
  }
  reference[[ifelse(is.doi, "doi", "url")]] <- survey

  links <- xml_find_all(
    parsed_body,
    "//link[@type='text/csv' and @rel='item']"
  ) |>
    xml_attr("href")

  zenodo_links <- data.table(url = links)
  ## only download csv files
  zenodo_links[, file_name := tolower(basename(url))]

  if (anyDuplicated(zenodo_links$file_name) > 0) {
    warning(
      "Zenodo repository contains files with names that only differ by case. ",
      "This will cause unpredictable behaviour on case-insensitive file systems. ",
      "Please contact the authors to get this fixed.",
      call. = FALSE
    )
    zenodo_links <- zenodo_links[!duplicated(file_name)]
  }

  dir <- dir %||% get_pkg_user_dir()

  # add the directory
  # assuming that `survey` is a DOI like "10.5281/zenodo.1095664"
  dir_doi <- gsub("/", "_", gsub("\\.", "-", survey))

  dir_name <- file.path(dir, dir_doi)
  # maybe take a look at usethis:::check_files_absent for this pattern
  if (!dir.exists(dir_name)) {
    dir.create(dir_name, recursive = TRUE)
  } else if (dir.exists(dir_name) && !overwrite) {
    stop("Files already exist, use `overwrite = TRUE` to overwrite.")
  }

  message("Getting ", parsed_cite$name, ".")

  lcs <- find_common_prefix(zenodo_links$file_name)
  reference_file_path <- file.path(dir_name, paste0(lcs, "reference.json"))
  reference_json <- toJSON(reference)
  write(reference_json, reference_file_path)

  zenodo_url <- zenodo_links$url
  download_path <- file.path(dir_name, zenodo_links$file_name)

  files <- c(
    reference_file_path,
    vapply(
      seq_len(nrow(zenodo_links)),
      function(i) {
        message("Downloading ", zenodo_url)
        Sys.sleep(sleep)
        dl <- curl_download(
          url = zenodo_url,
          destfile = download_path
        )
        download_path
      },
      ""
    )
  )

  return(files)
}

find_common_prefix <- function(vec) {
  # find initial longest common subequence of file names
  i <- 1
  finish <- FALSE
  lcs <- ""
  while (!finish) {
    initial_bits <- vapply(vec, substr, start = 1, stop = i, "x")
    if (length(unique(initial_bits)) > 1) {
      finish <- TRUE
    } else {
      lcs <- unique(initial_bits)
      i <- i + 1
    }
  }

  lcs
}

##' Checks if a character string is a DOI
##'
##' @param x Character vector; the string or strings to check
##' @return Logical; \code{TRUE} if \code{x} is a DOI, \code{FALSE} otherwise
##' @author Sebastian Funk
is_doi <- function(x) {
  is.character(x) && grepl("^10.[0-9.]{4,}/[-._;()/:A-z0-9]+$", x)
}
