#' Reduce to LMS color space
#'
#' Equation 10, 12, 13
#'
#' @param rgb_color RGB vector of color
.get_reduced_components <- function(rgb_color) {

  RGB_to_LMS <- matrix(c(17.8824, 3.45565, 0.0299566,
                         43.5161, 27.1554, 0.184309,
                         4.11935, 3.86714, 1.46709),
                       ncol = 3)

  cb_transformation <- matrix(c(1, 0.494207, 0,
                                         0, 0, 0,
                                         0, 1.24827, 1),
                                       ncol = 3)

  floor(solve(RGB_to_LMS) %*% (cb_transformation %*% (RGB_to_LMS %*% rgb_color)))

}

# Apply to a matrix of rgb colors
.reduce_matrix_components <- function(chromosome_matrix) {
  matrix(
    unlist(
      lapply(seq_len(ncol(chromosome_matrix)),
             function(x)
               .get_reduced_components(chromosome_matrix[,x])
      )
    ),
    ncol = ncol(chromosome_matrix)
  )
}
