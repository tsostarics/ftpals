#' Fit contrast ratios
#'
#' Equation 9. There is a slight modification where I include pure black
#' and pure white as additional comparisons to avoid the algorithm settling on
#' those values. This also has an effect of reducing saturation more generally.
#'
#' The threshold can be modified, especially for the black/white comparisons,
#' but I had to set them >6 to get interesting results. You could try using
#' different values for each one.
#'
#' @param new_mat Matrix of rgb colors
#' @param contiguity_matrix Matrix for comparisons
#' @param threshold Fit threshold
#'
#' @return Vector of cj values
.fit_cj <- function(new_mat, contiguity_matrix, threshold = 5) {
  ncols <- seq_len(ncol(new_mat))
  comparisons <- .generate_comparisons(contiguity_matrix)

  c(vapply(ncols,
           function(i) {
             a = comparisons[i,1L]
             b = comparisons[i,2L]
             (20 + min(.contrast_ratio(new_mat[,a], new_mat[,b]) - threshold, 0)) / 20
           },
           1.0
  ),
  (20 + min(.contrast_ratio(new_mat[,1], c(255,255,255)) - 7, 0)) / 20,
  (20 + min(.contrast_ratio(new_mat[,2], c(0,0,0)) - 7, 0)) / 20
  )

}
