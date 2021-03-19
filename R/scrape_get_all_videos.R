#' Get all videos
#'
#' Procedure to scrape all the information about the videos
#'
#' @return Data frame with all the first take videos
.get_all_videos <- function() {
  playlists_df <- .retrieve_playlists()
  # Gets videos from THE FIRST TAKE playlist
  playlist_df <- .get_videos()
  # Mostly gets the oldest songs
  backtracks_df <- .get_backtrack_videos(playlists_df)
  # Gets videos from the main videos page, ~ the most recent 20 videos
  newvideos_df <- .get_videos("https://www.youtube.com/channel/UC9zY_E8mcAo_Oq772LEZq8Q/videos")
  # Gets videos from THE HOME TAKE playlist, not all are in their main playlist
  hometakes_df <- .get_videos("https://www.youtube.com/playlist?list=PLeLvSt3A0Ddll6mG61gi4w03P4-deFSm0")

  videos_df <-
    rbind(playlist_df,
          dplyr::filter(backtracks_df, !videoId %in% playlist_df[["videoId"]]),
          dplyr::filter(newvideos_df, !videoId %in% playlist_df[["videoId"]]),
          dplyr::filter(hometakes_df, !videoId %in% playlist_df[["videoId"]]))
  message(paste0("Scraping ", nrow(videos_df), " take numbers."))
  videos_df[["take_number"]] <- .scrape_take_numbers(videos_df)

  videos_df
}
