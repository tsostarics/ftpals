#' Color distance
#'
#' Equation 8
#'
#' @param new_mat Matrix of rgb colors
#' @param old_mat Original matrix of rgb colors
#'
#' @return Vector of distance values to use in the fitness function
.fit_di <- function(new_mat, old_mat) {
  vapply(seq_len(ncol(new_mat)),
         function(i) {
           .lab_edist(new_mat[,i], old_mat[,i]) / .lab_edist()
         },
         1.0
  )
}
