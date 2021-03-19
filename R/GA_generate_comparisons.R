#' Generate comparisons
#'
#' Returns indices to use in comparisons
#'
#' @param contiguity_matrix Binary matrix for comparisons
.generate_comparisons <- function(contiguity_matrix){
  which(contiguity_matrix == 1, arr.ind = T)
}
