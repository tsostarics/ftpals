#' RGB values to hex palette
#'
#' Convert from an rgb representation to hex representation
#'
#' @param rgb_vector RGB vector for a color
.rgb_to_hex <- function(rgb_vector) {
  rgb_mat <- matrix(rgb_vector, nrow = 3)
  vapply(seq_len(ncol(rgb_mat)),
         function(x){
           grDevices::rgb(red = rgb_mat[1,x]/255,
                          green = rgb_mat[2,x]/255,
                          blue = rgb_mat[3,x]/255)
         },
         "char"
  )

}
