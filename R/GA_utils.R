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
#' RGB chromosome to binary representation
#'
#' @param chromosome RGB value representation of the chromosome
#'
#' @return Create a binary representation of the palette chromosome
.chromosome_as_binary <- function(chromosome){
  unlist(lapply(chromosome, function(x) GA::decimal2binary(x, 8)))
}
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
#' Compute contrast ratio
#'
#' Equation 4
#'
#' @param color1 First color, in RGB vector format
#' @param color2 Second color, in RGB vector format
#'
#' @return C, the contrast ratio
.contrast_ratio <- function(color1, color2) {
  L1 <-  .relative_luminance(color1)
  L2 <-  .relative_luminance(color2)

  (max(L1, L2) + 0.05 ) / (min(L1, L2) + 0.05 )
}
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
#' Generate comparisons
#'
#' Returns indices to use in comparisons
#'
#' @param contiguity_matrix Binary matrix for comparisons
.generate_comparisons <- function(contiguity_matrix){
  which(contiguity_matrix == 1, arr.ind = T)
}
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
#' Compute LAB color space euclidean distance
#'
#' Equation 3. Max distance between Green and Blue
#'
#' @param color1 Color, RGB vector format. Default green.
#' @param color2 Color, RGB vector format. Default Blue
#'
#' @return Euclidean distance between two colors in LAB colorspace
.lab_edist <- function(color1 = c(0,255,0), color2 = c(0,0,255)) {
  color1 <- grDevices::convertColor(color1, "sRGB", "Lab")
  color2 <- grDevices::convertColor(color2, "sRGB", "Lab")

  sqrt(
    (color1[1] - color2[1])^2 + (color1[2] - color2[2])^2 + (color1[3] - color2[3])^2
  )
}
#' Optimize palette
#'
#' Given a palete, run the genetic algorithm described in Troiano, Birtolo,
#' and Miranda 2008 to create a palette that should work better for those
#' with colorblindness.
#'
#' @param palette Original palette, in hex strings
#' @param maxiter Number of iterations to run
#' @param parallel Should you run in parallel? F to turn off, else # of cores to use
#' @param monitor Monitor convergence? use plot to view, F to turn off
#'
#' @return A hex string with a new palette
.optimize_palette <- function(palette, maxiter = 45, parallel = F, monitor = plot) {
  requireNamespace("GA", quietly = TRUE)
  if (is.list(palette))
    palette <- unlist(palette)
  palette <- .order_palette(palette)
  initial_pop <- .palette_to_chromosome(palette)
  binary_pop <- .chromosome_as_binary(initial_pop)
  contiguity_matrix <- .generate_matrix(length(palette))
  ga_results <-
    GA::ga(type = "binary",
       fitness = function(x) .color_fitness(x,
                                           binary_pop,
                                           contiguity_matrix = contiguity_matrix,
                                           pal_size = length(palette)
       ),
       crossover = GA::ga_spCrossover,
       pcrossover = .8,
       pmutation = .2,
       selection = GA::gabin_tourSelection,
       elitism = 5,
       nBits = length(binary_pop),
       monitor = monitor,
       maxiter = maxiter, # tends to converge around 45
       parallel = parallel,
       seed = 123,
       popSize = 200 # diminishing returns at larger pop sizes
    )

  palette <- .rgb_to_hex(.binary_to_rgb(ga_results@solution))
  .order_palette(palette)
}
#' Get chromosome of palette
#'
#' @param hex_palette Hex strings for palette
#'
#' @return a vector of RGB values
.palette_to_chromosome <- function(hex_palette) {
  as.vector(grDevices::col2rgb(hex_palette, alpha = F))
}
#' Relative Luminance
#'
#' Equation 5
#'
#' @param color Color, in RGB vector format
#'
#' @return L, the relative luminance
.relative_luminance <- function(color) {
  color <- .RGB_to_rgb(color)
  0.2126*color[1] + 0.7152*color[2] + 0.0722*color[3]
}
#' RGB to rgb conversion
#'
#' Equation 6
#'
#' @param color RGB vector of color
#'
#' @return Returns a vector of small rgb values
.RGB_to_rgb <- function(color){
  color <- .scale_color(color)
  if (color[1] <= 0.03928 & color[2] <= 0.03928 & color[3] <= 0.03928)
    color/12.92
  else
    ((color + 0.055)/1.055)^2.4

}
