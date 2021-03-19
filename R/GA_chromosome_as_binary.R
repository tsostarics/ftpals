#' RGB chromosome to binary representation
#'
#' @param chromosome RGB value representation of the chromosome
#'
#' @return Create a binary representation of the palette chromosome
.chromosome_as_binary <- function(chromosome){
  unlist(lapply(chromosome, function(x) GA::decimal2binary(x, 8)))
}
