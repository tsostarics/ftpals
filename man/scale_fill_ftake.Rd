% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gg_scale_functions.R
\name{scale_fill_ftake}
\alias{scale_fill_ftake}
\title{Scale fill first take}
\usage{
scale_fill_ftake(
  ...,
  index = NA,
  palette = 1L,
  type = NA,
  take = NA,
  order = 1:6
)
}
\arguments{
\item{...}{Arguments passed from ggplot}

\item{index}{Index of video (ie row number)}

\item{palette}{1 for `palette`, else `optimized_palette`}

\item{type}{F for first take, H for home take, case insensitive}

\item{take}{an integer for which video you want to use}

\item{order}{Integer vector if you want to use an orer other than 1:6}
}
\description{
You can the index of the row from the first_takes table you want to use,
although this isn't stable long-term for uploads from THE HOME TAKE series
since they're at the end of the table and will continually be pushed down.
To avoid this, you can provide which series you want to use with the type
argument and then the take_number you want to use.
}
