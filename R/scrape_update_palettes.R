#' Update palettes
#'
#' New videos release approx twice a week, so you can run this to add in any
#' new songs.
#'
#' @param palettes Palette table
.update_palettes <- function(palettes = ftpals::first_takes){
  # This should really only be run once a week! New videos release Wed and Fri
  new_videos <-
    .get_videos("https://www.youtube.com/channel/UC9zY_E8mcAo_Oq772LEZq8Q/videos") %>%
    dplyr::filter(!videoId %in% palettes[["videoId"]])
  new_videos$take_number <-  .scrape_take_numbers(new_videos)
  new_videos <- .manual_fix_errors(new_videos) %>% .generate_all_palettes()
  first_takes <-
    rbind(palettes,
          dplyr::filter(new_videos, !videoId %in% palettes[["videoId"]])) %>%
    dplyr::arrange(type, take_number)
  usethis::use_data(first_takes,overwrite = TRUE)
}
