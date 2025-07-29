# nolint start
library(testthat)
library(contactsurveys)
# nolint end

data.table::setDTthreads(1)
test_check("contactsurveys")
