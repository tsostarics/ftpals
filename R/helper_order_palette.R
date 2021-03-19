#' Order Palette
#'
#' The ordering these palettes use is like so:
#' -Order by increasing luminance
#' -Reorder by flip flopping between high and low values
#'
#' @param hex_palette Palette, given in hex strings
#'
#' @return A palette ordered by the given procedure
.order_palette <- function(hex_palette) {
  rgb_mat <- grDevices::col2rgb(hex_palette)
  luminance_vals <- vapply(seq_len(ncol(rgb_mat)),
                           function(i)
                             .relative_luminance(rgb_mat[,i]),
                           1.0
  )
  hex_palette <- hex_palette[order(luminance_vals, decreasing = T)]
  indices <- seq_len(length(hex_palette))
  rev_indices <- rev(indices)
  half <- indices[1:(length(indices) %/% 2)]
  merged_indices <-
    unlist(lapply(half, function(x) c(indices[x],rev_indices[x])))
  if (length(hex_palette) %% 2)
    merged_indices <- c(merged_indices, (length(indices) %/% 2 + 1))
  hex_palette[merged_indices]
}
