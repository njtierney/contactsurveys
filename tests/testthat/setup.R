withr::local_envvar(
  .new = c(CONTACTSURVEYS_HOME = tempdir()),
  .local_envir = teardown_env()
)
