#' Show colors
#'
#' Helper to visualize both palettes from the palette table with the given index
#'
#' @param index Which palette to get?
#' @param palettes Palette table
#'
#' @importFrom scales show_col
#' @export
show_pals <- function(index = NA, type = "F", take = NA, palettes = ftpals::first_takes) {
  primary <- get_ftpal(index = index, palette = 1L, type = type, take = take)
  optimized <- get_ftpal(index = index, palette = 2L, type = type, take = take)
  n = length(primary) %/% 2
  scales::show_col(c(primary,rep(NA, n),optimized), ncol = n)
}
