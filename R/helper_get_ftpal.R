#' Get a palette
#'
#' @param index Index (row number) of palette
#' @param palette Palette
#' @param type F for first take, H for home take
#' @param take Integer, which video to use
#'
#' @return A hex string vector for the palette
#' @export
get_ftpal <- function(index = NA, palette = 1L, type = NA, take = NA) {
  pal <- ifelse(palette == 1L, "palette", "optimized_palette")

  if (is.na(index) & (is.na(type) | is.na(take)))
    stop("If index is not specified, both type and take_number must be used.")
  else if (is.na(index)) {
    type_char <- stringr::str_extract(type, "^.")
    series <- dplyr::case_when(grepl("[Ff]", type_char) ~ "THE FIRST TAKE",
                               grepl("[Hh]", type_char) ~ "THE HOME TAKE",
                               TRUE ~ "ERROR")
    if (series == "ERROR")
      stop("Type must be F for First Take or H for Home Take")

    selected_pal <- dplyr::filter(ftpals::first_takes,
                                  type == series,
                                  take_number == take)
    return(selected_pal[[pal]][[1L]])
  }
  else
    ftpals::first_takes[[pal]][[index]]
}

#' Get bar color
#'
#' @param index Index (row number) of palette
#' @param type F for first take, H for home take
#' @param take Integer, which video to use
#'
#' @export
barcolor <- function(index = NA, type = NA, take = NA) {
  if (is.na(index) & (is.na(type) | is.na(take)))
    stop("If index is not specified, both type and take_number must be used.")
  else if (is.na(index)) {
    type_char <- stringr::str_extract(type, "^.")
    series <- dplyr::case_when(grepl("[Ff]", type_char) ~ "THE FIRST TAKE",
                               grepl("[Hh]", type_char) ~ "THE HOME TAKE",
                               TRUE ~ "ERROR")
    if (series == "ERROR")
      stop("Type must be F for First Take or H for Home Take")

    selected_pal <- dplyr::filter(ftpals::first_takes,
                                  type == series,
                                  take_number == take)
    selected_pal[["bar_color"]][[1L]]
  }
  else
    ftpals::first_takes[["bar_color"]][[index]]
}
