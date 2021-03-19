#' Get thumbnail of video
#'
#' You can use this to add a thumbnail as an annotation to ggplots
#'
#' @param index Which video to get?
#' @param palettes Palette table
#'
#' @return A raster image
get_thumbnail <- function(index, palettes = ftpals::first_takes) {
  img <- jpeg::readJPEG(RCurl::getURLContent(paste0("https://i.ytimg.com/vi/", palettes[["videoId"]][[index]], "/hqdefault.jpg")))
  rasterimg <- grid::rasterGrob(img, interpolate = T)
  rasterimg[["raster"]] <- rasterimg[["raster"]][46:315,1:480]
  rasterimg
}
