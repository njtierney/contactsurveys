library(contactsurveys)
library(here)
library(tictoc)
library(purrr)

## list all surveys
ls <- list_surveys()

dir.create(here("surveys"), showWarnings = FALSE)
## download all surveys using the `url` column in the survey list and
## save them in the `surveys` folder (which is created if it does not exist)
# use `possibly` to ensure this continues running

possibly_download_survey <- possibly(.f = download_survey, otherwise = NULL)

tic()
survey_files <- map(ls$url, function(x) {
  Sys.sleep(5)
  survey_downloads <- possibly_download_survey(
    survey = x,
    dir = "surveys"
  )
})


toc()
# identify issue with download
which_did_not_download <- which(map(survey_files, is.null) |> flatten_lgl())

browseURL(ls$url[which_did_not_download])
https://zenodo.org/records/3878754
## name list elements according to url
names(survey_files) <- paste0(ls$title, " (", ls$url, ")")
## save list of survey files
saveRDS(survey_files, here("surveys", "survey_files.rds"))
