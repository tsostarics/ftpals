#' Generate comparison matrix.
#'
#' The comparisons I decided on is such that each color is compared to the
#' two colors it's next two, as well as every other color in the palette.
#' So, all the odd values are compared, and all the even values are compared.
#'
#' This matrix is a slight modification on the matrices (models) used in
#' Troiano, Birtolo, and Miranda 2008
#'
#' @param n Size of the palette
#'
#' @return A comparison matrix
.generate_matrix <- function(n = 6) {
  # is this inefficient? of course it is. am i going to rewrite this in C++? no
  # could this be done with bit flipping? sure. am i going to do that? also no
  vec <- c()
  for (i in seq_len(n)) {
    for (j in seq_len(n)) {
      if (i == j)
        vec <- c(vec, 0)
      else if (j == (i + 1) | j == (i - 1))
        vec <- c(vec, 1)
      else if ((i %% 2 == 0) & (j %% 2 == 0))
        vec <- c(vec, 1)
      else if ((i %% 2 == 1) & (j %% 2 == 1))
        vec <- c(vec, 1)
      else
        vec <- c(vec, 0)
    }
  }
  matrix(vec, ncol = n)
}
