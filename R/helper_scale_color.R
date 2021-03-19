#' Scale color
#'
#' Just a helper to scale colors to [0,1]
#'
#' @param color Color, in RGB vector format
#'
#' @return Vector of doubles in [0,1]
.scale_color <- function(color){
  color <- unlist(color,use.names = T)

  if (any(color > 1))
    color/255
  else
    color
}
