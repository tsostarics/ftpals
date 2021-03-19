#' RGB to rgb conversion
#'
#' Equation 6
#'
#' @param color RGB vector of color
#'
#' @return Returns a vector of small rgb values
.RGB_to_rgb <- function(color){
  color <- .scale_color(color)
  if (color[1] <= 0.03928 & color[2] <= 0.03928 & color[3] <= 0.03928)
    color/12.92
  else
    ((color + 0.055)/1.055)^2.4

}
