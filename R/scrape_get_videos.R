#' Get videos
#'
#' Retrieve information about videos on a page, works with the video
#' upload page or with a playlist page.
#'
#' @param playlist_url Set to the "THE FIRST TAKE" playlist by default
.get_videos <- function(playlist_url = "https://www.youtube.com/playlist?list=PLeLvSt3A0Ddk9lGjNqmzT0ctVPA5xfinn") {
  requireNamespace("stringr", quietly = TRUE)
  # Default retrieves from the playlist titled "THE FIRST TAKE" which has
  # almost every song (but NOT in the order of release)
  matches <-
    RCurl::getURLContent(playlist_url) %>%
    stringr::str_match_all("vi/([^/]+).{100,200}text\":\"([^\\}]+) ?[-–] ?([^/]+) ?/ ?([^\"]+)")
  # Last row is extraneous
  matches[[1]][seq_len(nrow(matches[[1]]) - 1),2:5] %>%
    as.data.frame() %>%
    setNames(c("videoId", "artist", "song", "type")) %>%
    tibble::as_tibble() %>%
    dplyr::mutate(dplyr::across(where(is.character), function(x) gsub("(^ +)|( +$)", "", x)),
           song = ifelse(song == "", stringr::str_match(artist," [-–] (.+)")[,2], song),
           artist = ifelse(grepl(" [-–] ", artist), stringr::str_match(artist, "(.+) [・] ")[,2], artist))
}
