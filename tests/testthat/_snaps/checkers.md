# check_is_url_doi() works

    Code
      check_is_url_doi(x = "a/mystery")
    Condition
      Error:
      ! `"a/mystery"` must be a DOI or URL.
      We see: "a/mystery"

# ensure_dir_exists() works

    Code
      ensure_dir_exists(directory = 123)
    Condition
      Error:
      ! `directory` must be a valid file path.
      We see: `123`

