# surveys can be downloaded with download_survey()

    Code
      basename(peru_survey_files)
    Output
      [1] "2015_Grijalva_Peru_sday.csv"              
      [2] "2015_Grijalva_Peru_participant_common.csv"
      [3] "2015_Grijalva_Peru_hh_extra.csv"          
      [4] "2015_Grijalva_Peru_hh_common.csv"         
      [5] "2015_Grijalva_Peru_dictionary.xls"        
      [6] "2015_Grijalva_Peru_contact_common.csv"    
      [7] "2015_Grijalva_Peru_participant_extra.csv" 

---

    Code
      . <- download_survey(doi_peru, overwrite = FALSE)
    Message
      Fetching contact survey filenames from: https://doi.org/10.5281/zenodo.1095664.
      v Successfully fetched list of published records!
      ! No record for DOI '10.5281/zenodo.1095664'!
      i Try to get deposition by Zenodo specific record id '1095664'
      v Successfully fetched list of published records!
      ! No record for id '1095664'!
      i Successfully fetched list of published records - page 1
      v Successfully fetched list of published records!
      v Successfully fetched published record for concept DOI '10.5281/zenodo.1095664'!
      Skipping download.
      i Files already exist, and `overwrite = FALSE`
      i Set `overwrite = TRUE` to force a re-download.

# download_survey() is silent when verbose = FALSE

    Code
      . <- download_survey(doi_peru, verbose = FALSE)

