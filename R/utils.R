get_pkg_user_dir <- function() {
  pkg_user_dir <- tools::R_user_dir("contactsurveys")
  if (!dir.exists(pkg_user_dir)) {
    dir.create(pkg_user_dir, recursive = TRUE)
  }
  pkg_user_dir
}
