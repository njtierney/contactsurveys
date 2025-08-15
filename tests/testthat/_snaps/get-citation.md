# get_citation() works

    Code
      get_citation(polymod_doi, verbose = FALSE)
    Output
      @dataset{joel_mossong_2020_3874557,
        author       = {Joël Mossong and
                        Niel Hens and
                        Mark Jit and
                        Philippe Beutels and
                        Kari Auranen and
                        Rafael Mikolajczyk and
                        Marco Massari and
                        Stefania Salmaso and
                        Gianpaolo Scalia Tomba and
                        Jacco Wallinga and
                        Janneke Heijne and
                        Malgorzata Sadkowska-Todys and
                        Magdalena Rosinska and
                        W. John Edmunds},
        title        = {POLYMOD social contact data},
        month        = jun,
        year         = 2020,
        publisher    = {Zenodo},
        version      = 2,
        doi          = {10.5281/zenodo.3874557},
        url          = {https://doi.org/10.5281/zenodo.3874557},
      }

---

    Code
      get_citation(polymod_doi, style = "mystery")
    Message
      i Fetching citation
    Condition
      Error in `get_citation()`:
      ! `style` must be one of "bibtex", "apa", "havard-cite-them-right", "modern-language-association", "vancouver", "chicago-fullnote-bibliography", or "ieee", not "mystery".
    Message
      x Fetching citation [13ms]
      

