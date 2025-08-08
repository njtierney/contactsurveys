withr::local_envvar(
  .new = c(CONTACTSURVEYS_HOME = tempfile("filestore")),
  .local_envir = teardown_env()
)
