library(socialmixr) # nolint
library(purrr)
library(here) # nolint
library(tictoc) # nolint

## load list of survey files
survey_files <- readRDS(here("surveys", "survey_files.rds"))

## define safe checking function
safe_as_contact_survey <- safely(\(files) as_contact_survey(load_survey(files)))
tic()
## check all surveys
checks <- map(survey_files, safe_as_contact_survey)

errors <- map(checks, "error")
no_error <- map_vec(errors, is.null)
error_messages <- map(errors[!no_error], "message")
toc()
cat("Errors:\n\n")
error_messages
cat("\n\nWarnings:\n\n")
warnings()

file_names_that_error <- names(error_messages)
debugonce(load_survey)
load_survey(survey_files[[file_names_that_error[1]]])
