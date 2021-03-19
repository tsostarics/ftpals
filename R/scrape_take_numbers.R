#' Scrape take numbers in bulk
#'
#' @param video_df Video data frame from get_videos()
#'
#' @return Vector of take numbers
.scrape_take_numbers <- function(video_df) {
  requireNamespace("purrr", quietly = TRUE)
  video_ids <- video_df[['videoId']]
  num_vids <- seq_len(length(video_ids))
  buffer <- purrr::list_along(num_vids)

  for (i in num_vids) {
    buffer[[i]] <- .get_take_number(video_ids[[i]])
    Sys.sleep(5)
    if (i %% 5 == 0)
      message(i)
  }

  unlist(buffer)
}
