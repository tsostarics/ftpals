#' Relative Luminance
#'
#' Equation 5
#'
#' @param color Color, in RGB vector format
#'
#' @return L, the relative luminance
.relative_luminance <- function(color) {
  color <- .RGB_to_rgb(color)
  0.2126*color[1] + 0.7152*color[2] + 0.0722*color[3]
}
