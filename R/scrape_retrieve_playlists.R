#' Get playlists from First Take channel
#'
#' @return Playlists from channel
#'
#' @importFrom stats setNames
.retrieve_playlists <- function() {
  # Mostly used when looking up older videos, the No.X~No.Y playlists aren't
  # updated consistently though.
  matches <-
    RCurl::getURLContent("https://www.youtube.com/channel/UC9zY_E8mcAo_Oq772LEZq8Q/playlists?view=1") %>%
    stringr::str_match_all("\"playlistId\":\"([^\"]+).{0,217}text\":\"([^\"]+)\",.{0,450}text\":\"([^\"]+)")

  setNames(as.data.frame(matches[[1]][,2:4]),
           c("playlistId", "playlistName", "numVideos"))
}
