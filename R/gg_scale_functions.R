#' Scale fill first take
#'
#' You can the index of the row from the first_takes table you want to use,
#' although this isn't stable long-term for uploads from THE HOME TAKE series
#' since they're at the end of the table and will continually be pushed down.
#' To avoid this, you can provide which series you want to use with the type
#' argument and then the take_number you want to use.
#'
#' @param ... Arguments passed from ggplot
#' @param index Index of video (ie row number)
#' @param palette 1 for `palette`, else `optimized_palette`
#' @param type F for first take, H for home take, case insensitive
#' @param take an integer for which video you want to use
#' @param order Integer vector if you want to use an orer other than 1:6
#'
#' @export
scale_fill_ftake <- function(..., index = NA, palette = 1L,
                             type = NA,
                             take = NA,
                             order = 1:6) {
  pal <- get_ftpal(index = index, palette = palette, type = type, take = take)
  ggplot2::scale_fill_manual(..., values = pal[order])
}

#' Scale color first take
#'
#' You can the index of the row from the first_takes table you want to use,
#' although this isn't stable long-term for uploads from THE HOME TAKE series
#' since they're at the end of the table and will continually be pushed down.
#' To avoid this, you can provide which series you want to use with the type
#' argument and then the take_number you want to use.
#'
#' @param ... Arguments passed from ggplot
#' @param index Index of video (ie row number)
#' @param palette 1 for `palette`, else `optimized_palette`
#' @param type F for first take, H for home take, case insensitive
#' @param take an integer for which video you want to use
#' @param order Integer vector if you want to use an orer other than 1:6
#'
#' @export
scale_color_ftake <- function(..., index = NA, palette = 1L,
                              type = NA,
                              take = NA,
                              order = 1:6) {
  pal <- get_ftpal(index = index, palette = palette, type = type, take = take)
  ggplot2::scale_color_manual(..., values = pal[order])
}

