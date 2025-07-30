# nolint start
library(testthat)
library(contactsurveys)
# nolint end

library(data.table)
data.table::setDTthreads(1)
test_check("contactsurveys")
