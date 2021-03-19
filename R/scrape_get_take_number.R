#' Get take number from video id
#'
#' @param video_id First take video ID to look up
#'
#' @return The number for the video
.get_take_number <- function(video_id) {
  html <- RCurl::getURLContent(paste0("https://www.youtube.com/watch?v=", video_id))
  match_number <- as.numeric(stringr::str_match(html, "(Episode |第)(\\d+)")[,3])
  if (is.na(match_number))
    if (grepl("\u521d\u56de", html))
      match_number <- 1
  else if (grepl("\u7b2c\u4e8c", html))
    match_number <- 2
  else if (grepl("\u7b2c\u4e09", html))
    match_number <- 3
  match_number
}
