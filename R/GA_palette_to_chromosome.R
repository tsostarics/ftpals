#' Get chromosome of palette
#'
#' @param hex_palette Hex strings for palette
#'
#' @return a vector of RGB values
.palette_to_chromosome <- function(hex_palette) {
  as.vector(grDevices::col2rgb(hex_palette, alpha = F))
}
