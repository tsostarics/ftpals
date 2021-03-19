#' Backtracking through playlists
#'
#' @param playlists Playlist dataframe from .get_playlists()
.calculate_backtrack <- function(playlists) {
  requireNamespace("data.table", quietly = TRUE)
  # When retrieving a playlist's videos, you only get 100 results at a time
  # so this gives you which playlists you should check for missing videos
  num_oor <- as.numeric(playlists[[playlists[['playlistName']] == 'THE FIRST TAKE', 'numVideos']]) - 100

  number_playlists <- num_oor %/% 9 + 1
  playlist_lookup <- seq_len(number_playlists) + 8
  playlist_lookup[1] <- 1
   paste0("^No.",playlist_lookup,"[~～]")
}

.backtrack_playlists <- function(playlists) {
  backtracks <- .calculate_backtrack(playlists)
  dplyr::filter(playlists, grepl(backtracks, playlistName))
}

.get_backtrack_videos <- function(playlists) {
  bt_lists <- .backtrack_playlists(playlists)
  lapply(bt_lists[["playlistId"]],
         function(x)
           .get_videos(paste0("https://www.youtube.com/playlist?list=", x))) %>%
    data.table::rbindlist() %>%
    tibble::as_tibble()
}
