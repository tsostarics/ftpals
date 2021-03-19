#' Fitness function
#'
#' Equation 7, used in the genetic algorithm
#'
#' @param new_chromosome New binary chromosome
#' @param old_chromosome Original binary chromosome from kmeans palette
#' @param contiguity_matrix Matrix for comparisons for cj calculation
#' @param pal_size Size of the palette
#'
#' @return A fitness score
.color_fitness <- function(new_chromosome, old_chromosome, contiguity_matrix, pal_size = 6) {
  new_mat <- .bchromosome_to_matrix(new_chromosome, pal_size = pal_size)
  old_mat <- .bchromosome_to_matrix(old_chromosome, pal_size = pal_size)
  lms_mat <- .reduce_matrix_components(new_mat)
  k <- pal_size*(pal_size - 1) + 2
  di <- .fit_di(new_mat, old_mat)
  cj <- .fit_cj(lms_mat, contiguity_matrix = contiguity_matrix)

  (prod((1 - di)) * prod(cj))^(1/(pal_size + k))
}
