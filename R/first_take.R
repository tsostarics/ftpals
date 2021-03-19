#' Listen to a random song
#'
#' Run to open a random song in youtube. Provide an index to listen to a specific
#' song.
#'
#' @param index Which song to listen to (index in the palette table)
#' @param takes Palette table
first_take <- function(index = sample(seq_len(nrow(takes)), 1), takes=ftpals::first_takes){
  message(paste0("Index: ", index,". Enjoy the music!"))
  utils::browseURL(paste0("https://www.youtube.com/watch?v=", takes[["videoId"]][[index]]))
}
