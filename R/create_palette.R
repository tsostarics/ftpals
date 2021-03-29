#' Create palette
#'
#' Create a palette from the thumbnail of the given video. Requires the GA
#' package. Parallel processing possible but turned off by default. This actually
#' works with any thumbnail, doesn't have to be from the first take.
#'
#' @param video_id youtube video ID
#' @param n number of colors to create (default 6)
#' @param monitor set to plot to view convergence in progress
#' @param parallel number of cores to use for parallel processing (F by default)
#' @param maxiter Max number of iterations for the genetic algorithm
#'
#' @return A color palette, in hex strings
#' @importFrom stats kmeans
create_palette <- function(video_id, n=6, maxiter = 45, monitor = plot, parallel = F){
  # Download file and convert to an RGB data frame
  requireNamespace("jpeg", quietly = TRUE)
  requireNamespace("GA", quietly = TRUE)
  requireNamespace("RCurl", quietly = TRUE)

  img <-  jpeg::readJPEG(RCurl::getURLContent(paste0("https://i.ytimg.com/vi/",video_id,"/hqdefault.jpg")))
  Sys.sleep(2)
  img <- img[46:315,1:480,1:3] # remove black bars
  dimensions <- dim(img)[1:2]
  midpoint <- round(dimensions[1] * dimensions[2] / 2 - dimensions[1]/2, digits = 0)

  img_df <- data.frame(
    red = matrix(img[,,1]*255, ncol = 1),
    green = matrix(img[,,2]*255, ncol = 1),
    blue = matrix(img[,,3]*255, ncol = 1)
  )

  # Quantize colors with kmeans clustering
  set.seed(255)
  K <- stats::kmeans(img_df, centers = n, nstart = 5)

  # Create base palette
  palette_vals <-
    dplyr::transmute(
      tibble::as_tibble(K[["centers"]]),
      rgbval = grDevices::rgb(red/255, green/255, blue/255)
    )[["rgbval"]]

  # Create the optimized palette via genetic algorithm
  optimized_vals <- .optimize_palette(palette_vals,
                                      maxiter = maxiter,
                                      monitor = monitor,
                                      parallel = parallel)

  tibble::tibble(
    videoId = video_id,
    palette = list(.order_palette(palette_vals)),
    bar_color = grDevices::rgb(img_df[midpoint,]/255),
    optimized_palette = list(optimized_vals)
  )
}
