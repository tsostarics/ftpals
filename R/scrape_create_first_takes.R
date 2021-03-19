#' Title
#' Creates first take table
.create_first_takes <- function(){
  requireNamespace("stringr", quietly = TRUE)
  .get_all_videos() %>%
    .generate_all_palettes(ftpals::first_takes) %>%
    .manual_fix_errors()
}
