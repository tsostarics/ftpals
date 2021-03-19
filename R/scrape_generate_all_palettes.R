#' Generate all palettes
#'
#' Creates creates the palettes in bulk. Takes about an hour on my computer for
#' 117 videos.
#'
#' @param first_takes Palette table
.generate_all_palettes <- function(first_takes = ftpals::first_takes) {
  requireNamespace("data.table", quietly = TRUE)
  video_ids <- first_takes[['videoId']]

  dplyr::left_join(first_takes,
            tibble::as_tibble(
              data.table::rbindlist(
                lapply(video_ids,
                       function(x){
                         print(x)
                         create_palette(x)
                       }
                )
              )
            )
  )
}
