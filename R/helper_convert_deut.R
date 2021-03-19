#' Convert to deuteronopia color space
#'
#' Helper to quickly convert to deuteronopia color vision
#'
#' @param hex_palette Hex strings of a palette
#'
#' @return New palette with new colors
.convert_deut <- function(hex_palette) {
  requireNamespace("GA", quietly = TRUE)
  hex_palette %>%
    .palette_to_chromosome() %>%
    .chromosome_as_binary() %>%
    .bchromosome_to_matrix(pal_size = length(hex_palette)) %>%
    .reduce_matrix_components() %>%
    .rgb_to_hex()
}
