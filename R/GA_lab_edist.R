#' Compute LAB color space euclidean distance
#'
#' Equation 3. Max distance between Green and Blue
#'
#' @param color1 Color, RGB vector format. Default green.
#' @param color2 Color, RGB vector format. Default Blue
#'
#' @return Euclidean distance between two colors in LAB colorspace
.lab_edist <- function(color1 = c(0,255,0), color2 = c(0,0,255)) {
  color1 <- grDevices::convertColor(color1, "sRGB", "Lab")
  color2 <- grDevices::convertColor(color2, "sRGB", "Lab")

  sqrt(
    (color1[1] - color2[1])^2 + (color1[2] - color2[2])^2 + (color1[3] - color2[3])^2
  )
}
