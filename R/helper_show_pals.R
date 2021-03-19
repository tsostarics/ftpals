#' Show colors
#'
#' Helper to visualize both palettes from the palette table with the given index
#'
#' @param index Which palette to get?
#' @param palettes Palette table
#'
#' @importFrom scales show_col
#' @export
show_pals <- function(index, palettes = ftpals::first_takes) {
  primary <- palettes[["palette"]][index][[1]]
  optimized <- palettes[["optimized_palette"]][index][[1]]
  n = length(primary) %/% 2
  scales::show_col(c(primary,rep(NA, n),optimized), ncol = n)
}
