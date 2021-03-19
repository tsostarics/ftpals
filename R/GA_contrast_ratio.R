#' Compute contrast ratio
#'
#' Equation 4
#'
#' @param color1 First color, in RGB vector format
#' @param color2 Second color, in RGB vector format
#'
#' @return C, the contrast ratio
.contrast_ratio <- function(color1, color2) {
  L1 <-  .relative_luminance(color1)
  L2 <-  .relative_luminance(color2)

  (max(L1, L2) + 0.05 ) / (min(L1, L2) + 0.05 )
}
