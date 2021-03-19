#' Fix errors
#'
#' Some videos just have random typos and errors that have to be corrected. Note
#' that there is NO first take #70
#'
#' @param first_takes Palette table
#'
#' @return Cleaned up first take table
.manual_fix_errors <- function(first_takes) {
  first_takes %>%
    dplyr::mutate(take_number = dplyr::case_when(is.na(take_number) & grepl("Rude", artist) ~ 2,
                                                 is.na(take_number) & grepl("shu", artist) ~ 3,
                                                 TRUE ~ take_number),
                  type = ifelse(type == "THE F1RST TAKE", "THE FIRST TAKE", type)) %>%
    dplyr::arrange(type, take_number) %>%
    dplyr::filter(!duplicated(videoId))
}
