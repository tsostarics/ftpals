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
