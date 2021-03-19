#' Update palettes
#'
#' New videos release approx twice a week, so you can run this to add in any
#' new songs.
#'
#' @param palettes Palette table
.update_palettes <- function(palettes = ftpals::first_takes){
  # This should really only be run once a week! New videos release Wed and Fri
  new_videos <- .get_videos("https://www.youtube.com/channel/UC9zY_E8mcAo_Oq772LEZq8Q/videos")
  first_takes <-
    rbind(palettes,
          dplyr::filter(new_videos, !videoId %in% palettes[["videoId"]])) %>%
    dplyr::arrange(type, take_number)
  usethis::use_data(first_takes)
}
