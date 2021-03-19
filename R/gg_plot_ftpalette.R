#' View palette compared to thumbnail
#'
#' @param index Which video to get? an integer
#' @param palettes the palette table
#' @param show_thumbnail Should the thumbnail be downloaded and shown? Requires RCurl
#' @param use_theme a theme to use, such as theme_minimal, theme_gray, theme_dark, etc.
#'
#' @export
plot_ftpalette <- function(index,
                           palettes = ftpals::first_takes,
                           use_theme = ggplot2::theme_gray,
                           show_thumbnail = TRUE) {
  if (show_thumbnail) {
    requireNamespace("RCurl", quietly = TRUE)
    thumbnail <- get_thumbnail(index)
    thumb_an <- ggplot2::annotation_custom(thumbnail, xmin = 2, xmax = 5, ymin = 1, ymax = 2)
  }
  n <- length(palettes[['palette']][index][[1L]])
  p <-
    data.frame(x = factor(rep(seq_len(n), times = 2)),
               y = rep(c(1,-1), each = n),
               i = as.character(c(1:9,91,92,93))) %>% # rewrite this line to work with n>6
    ggplot2::ggplot(ggplot2::aes(x = x, y = y, fill = i)) +
    ggplot2::geom_bar(stat = 'identity', color = "black") +
    ggplot2::scale_fill_manual(values = c(palettes[["palette"]][[index]],
                                 palettes[["optimized_palette"]][[index]])) +
    ggplot2::coord_cartesian(ylim = c(-1,2)) +
    ggplot2::labs(caption = "`palette` on top, `optimized_palette` on bottom") +
    ggplot2::xlab("Palette Index") +
    ggplot2::ylab("")


  p <- p + use_theme() + ggplot2::theme(legend.position = 'none')
  if (show_thumbnail)
    p + thumb_an
  else
    p
}
