td <- withr::local_tempdir(.local_envir = teardown_env())
withr::local_envvar(
  .new = c(CONTACTSURVEYS_HOME = td),
  .local_envir = teardown_env()
)
