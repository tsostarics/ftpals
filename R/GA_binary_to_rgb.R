#' Binary chromosome to RGB representation
#'
#' @param binary_chromosome Binary representation of chromosome
#'
#' @return RGB representation of chromosome
.binary_to_rgb <- function(binary_chromosome) {
  lhs <- seq(1, length(binary_chromosome), by = 8)
  rhs <- lhs + 7

  vapply(1:(length(binary_chromosome)/8),
         function(x){
           GA::binary2decimal(binary_chromosome[lhs[x]:rhs[x]])
         },
         1.0
  )
}

# Convert binary chromosome to rgb matrix
.bchromosome_to_matrix <- function(chromosome, pal_size = 6) {
  matrix(.binary_to_rgb(chromosome), ncol = pal_size)
}
