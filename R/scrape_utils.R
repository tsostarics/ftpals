#' Backtracking through playlists
#'
#' @param playlists Playlist dataframe from .get_playlists()
.calculate_backtrack <- function(playlists) {
  requireNamespace("data.table", quietly = TRUE)
  # When retrieving a playlist's videos, you only get 100 results at a time
  # so this gives you which playlists you should check for missing videos
  num_oor <- as.numeric(playlists[[playlists[['playlistName']] == 'THE FIRST TAKE', 'numVideos']]) - 100

  number_playlists <- num_oor %/% 9 + 1
  playlist_lookup <- seq_len(number_playlists) + 8
  playlist_lookup[1] <- 1
   paste0("^No.",playlist_lookup,"[~～]")
}

.backtrack_playlists <- function(playlists) {
  backtracks <- .calculate_backtrack(playlists)
  dplyr::filter(playlists, grepl(backtracks, playlistName))
}

.get_backtrack_videos <- function(playlists) {
  bt_lists <- .backtrack_playlists(playlists)
  lapply(bt_lists[["playlistId"]],
         function(x)
           .get_videos(paste0("https://www.youtube.com/playlist?list=", x))) %>%
    data.table::rbindlist() %>%
    tibble::as_tibble()
}
#' Title
#' Creates first take table
.create_first_takes <- function(){
  requireNamespace("stringr", quietly = TRUE)
  .get_all_videos() %>%
    .generate_all_palettes(ftpals::first_takes) %>%
    .manual_fix_errors()
}
#' Generate all palettes
#'
#' Creates creates the palettes in bulk. Takes about an hour on my computer for
#' 117 videos.
#'
#' @param first_takes Palette table
.generate_all_palettes <- function(first_takes = ftpals::first_takes) {
  requireNamespace("data.table", quietly = TRUE)
  video_ids <- first_takes[['videoId']]

  dplyr::left_join(first_takes,
            tibble::as_tibble(
              data.table::rbindlist(
                lapply(video_ids,
                       function(x){
                         print(x)
                         create_palette(x,monitor = F,parallel = 6)
                       }
                )
              )
            )
  )
}
#' Get all videos
#'
#' Procedure to scrape all the information about the videos
#'
#' @return Data frame with all the first take videos
.get_all_videos <- function() {
  playlists_df <- .retrieve_playlists()
  # Gets videos from THE FIRST TAKE playlist
  playlist_df <- .get_videos()
  # Mostly gets the oldest songs
  backtracks_df <- .get_backtrack_videos(playlists_df)
  # Gets videos from the main videos page, ~ the most recent 20 videos
  newvideos_df <- .get_videos("https://www.youtube.com/channel/UC9zY_E8mcAo_Oq772LEZq8Q/videos")
  # Gets videos from THE HOME TAKE playlist, not all are in their main playlist
  hometakes_df <- .get_videos("https://www.youtube.com/playlist?list=PLeLvSt3A0Ddll6mG61gi4w03P4-deFSm0")

  videos_df <-
    rbind(playlist_df,
          dplyr::filter(backtracks_df, !videoId %in% playlist_df[["videoId"]]),
          dplyr::filter(newvideos_df, !videoId %in% playlist_df[["videoId"]]),
          dplyr::filter(hometakes_df, !videoId %in% playlist_df[["videoId"]]))
  message(paste0("Scraping ", nrow(videos_df), " take numbers."))
  videos_df[["take_number"]] <- .scrape_take_numbers(videos_df)

  videos_df
}
#' Get take number from video id
#'
#' @param video_id First take video ID to look up
#'
#' @return The number for the video
.get_take_number <- function(video_id) {
  html <- RCurl::getURLContent(paste0("https://www.youtube.com/watch?v=", video_id))
  match_number <- as.numeric(stringr::str_match(html, "(Episode |第)(\\d+)")[,3])
  if (is.na(match_number))
    if (grepl("\u521d\u56de", html))
      match_number <- 1
  else if (grepl("\u7b2c\u4e8c", html))
    match_number <- 2
  else if (grepl("\u7b2c\u4e09", html))
    match_number <- 3
  match_number
}
#' Get videos
#'
#' Retrieve information about videos on a page, works with the video
#' upload page or with a playlist page.
#'
#' @param playlist_url Set to the "THE FIRST TAKE" playlist by default
.get_videos <- function(playlist_url = "https://www.youtube.com/playlist?list=PLeLvSt3A0Ddk9lGjNqmzT0ctVPA5xfinn") {
  requireNamespace("stringr", quietly = TRUE)
  # Default retrieves from the playlist titled "THE FIRST TAKE" which has
  # almost every song (but NOT in the order of release)
  matches <-
    RCurl::getURLContent(playlist_url) %>%
    stringr::str_match_all("vi/([^/]+).{100,200}text\":\"([^\\}]+) ?[-–] ?([^/]+) ?/ ?([^\"]+)")
  # Last row is extraneous
  matches[[1]][seq_len(nrow(matches[[1]]) - 1),2:5] %>%
    as.data.frame() %>%
    setNames(c("videoId", "artist", "song", "type")) %>%
    tibble::as_tibble() %>%
    dplyr::mutate(dplyr::across(where(is.character), function(x) gsub("(^ +)|( +$)", "", x)),
           song = ifelse(song == "", stringr::str_match(artist," [-–] (.+)")[,2], song),
           artist = ifelse(grepl(" [-–] ", artist), stringr::str_match(artist, "(.+) [・] ")[,2], artist))
}
#' Fix errors
#'
#' Some videos just have random typos and errors that have to be corrected. Note
#' that there is NO first take #70
#'
#' @param first_takes Palette table
#'
#' @return Cleaned up first take table
.manual_fix_errors <- function(first_takes) {
  first_takes %>%
    dplyr::mutate(take_number = dplyr::case_when(is.na(take_number) & grepl("Rude", artist) ~ 2,
                                                 is.na(take_number) & grepl("shu", artist) ~ 3,
                                                 TRUE ~ take_number),
                  type = ifelse(type == "THE F1RST TAKE", "THE FIRST TAKE", type),
                  artist = dplyr::case_when(videoId == "niuehQgJIbY" ~ "Jun. K",
                                            TRUE ~ artist)) %>%
    dplyr::arrange(type, take_number) %>%
    dplyr::filter(!duplicated(videoId))
}
#' Get playlists from First Take channel
#'
#' @return Playlists from channel
#'
#' @importFrom stats setNames
.retrieve_playlists <- function() {
  # Mostly used when looking up older videos, the No.X~No.Y playlists aren't
  # updated consistently though.
  matches <-
    RCurl::getURLContent("https://www.youtube.com/channel/UC9zY_E8mcAo_Oq772LEZq8Q/playlists?view=1") %>%
    stringr::str_match_all("\"playlistId\":\"([^\"]+).{0,217}text\":\"([^\"]+)\",.{0,450}text\":\"([^\"]+)")

  setNames(as.data.frame(matches[[1]][,2:4]),
           c("playlistId", "playlistName", "numVideos"))
}
#' Scrape take numbers in bulk
#'
#' @param video_df Video data frame from get_videos()
#'
#' @return Vector of take numbers
.scrape_take_numbers <- function(video_df) {
  requireNamespace("purrr", quietly = TRUE)
  video_ids <- video_df[['videoId']]
  num_vids <- seq_len(length(video_ids))
  buffer <- purrr::list_along(num_vids)

  for (i in num_vids) {
    buffer[[i]] <- .get_take_number(video_ids[[i]])
    Sys.sleep(5)
    if (i %% 5 == 0)
      message(i)
  }

  unlist(buffer)
}
