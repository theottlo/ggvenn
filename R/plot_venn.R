#' Plot Venn or Euler diagram with two sets
#'
#' @param dfA Data frame
#' @param dfB Data frame
#' @param by A character vector of variables to join by. If `NULL`, a natural join is performed.
#' @param na_matches Should `NA` and `NAN` values count as a match between `dfA` and `dfB`? Either `"na"` or `"never"`. If `"na"`, they do count as matches and if `"never"`, they don’t. (default=`"never"`)
#' @param euler If set to `TRUE` a Euler diagram is drawn instead of a Venn diagram (default=`FALSE`)
#' @param verbose If set to `TRUE`, logging information is printed out (default=`FALSE`)
#'
#' @return
#' A ggplot object with the Venn or Euler diagram.
#' @export
#'
#' @examples
#' # Generate sample data
#' dfA <- data.frame(movie=c("Finding Nemo", "Shrek", "Toy Story"), rating=c(5, 3, 7))
#' dfB <- data.frame(movie=c("Finding Nemo", "Shrek", "Toy Story", "Inception"), rating=c(5, 3, 7, 8))
#'
#' # Plot Venn diagram
#' plot_venn(dfA, dfB)
#'
#' # Plot Euler diagram
#' plot_venn(dfA, dfB, euler=TRUE)
plot_venn <- function(dfA, dfB, by=NULL, na_matches="never", euler=FALSE, verbose=FALSE) {
  if (verbose) message("Calculating inner joins...")
  inner <- nrow(dplyr::inner_join(dfA, dfB, by=by, na_matches=na_matches))
  if (verbose) message("Calculating anti joins...")
  antiA <- nrow(dplyr::anti_join(dfA, dfB, by=by, na_matches=na_matches))
  antiB <- nrow(dfB) - inner

  plot_type <- "Euler"
  if (!euler || (euler && inner != 0 && inner != nrow(dfA) && inner != nrow(dfB))) {
    plot_type <- "Venn"
    df_circles <- data.frame(x0 = c(0.866, -0.866),
                             y0 = c(0, 0),
                             r = c(1.5, 1.5),
                             labels = c('A', 'B'))

    df_counts <- data.frame(counts = c(antiA, inner, antiB),
                            x = c(1.2, 0, -1.2),
                            y = c(0, 0, 0))
  } else if (inner == 0) {
    if (verbose) message("No matches between dfA and dfB.")
    df_circles <- data.frame(x0 = c(1.834, -1.834),
                             y0 = c(0, 0),
                             r = c(1.5, 1.5),
                             labels = c('A', 'B'))

    df_counts <- data.frame(counts = c(antiA, antiB),
                            x = c(1.834, -1.834),
                            y = c(0, 0))

  } else if (inner == nrow(dfA) && inner == nrow(dfB)) {
    warning("dfA and dfB are the same!")
    df_circles <- data.frame(x0 = 0,
                             y0 = 0,
                             r = 1.5,
                             labels='A/B')

    df_counts <- data.frame(counts = inner,
                            x = 0,
                            y = 0)

  } else {
    if (inner == nrow(dfB)) {
      if (verbose) message("dfB is a subset of dfA.")

      df_circles <- data.frame(x0 = c(0, 0),
                               y0 = c(0, -0.6),
                               r = c(1.5, 0.8),
                               labels=c('A', 'B'))

      df_counts <- data.frame(counts = c(antiA, inner),
                              x = c(0, 0),
                              y = c(0.75, -0.6))

    } else {
      if (verbose) message("dfA is a subset of dfB.")
      df_circles <- data.frame(x0 = c(0, 0),
                               y0 = c(-0.6, 0),
                               r = c(0.8, 1.5),
                               labels=c('A', 'B'))

      df_counts <- data.frame(counts = c(antiB, inner),
                              x = c(0, 0),
                              y = c(0.75, -0.6))
    }
  }

  if (verbose) message(paste("Plotting", plot_type, "diagram...", sep=" "))
  ggplot2::ggplot(df_circles, ggplot2::aes(x0 = x0, y0 = y0, r = r, fill = labels)) +
    ggforce::geom_circle(alpha = .3, colour = 'black') +
    ggplot2::coord_fixed() +
    ggplot2::theme_void() +
    ggplot2::annotate("text", x = df_counts$x, y = df_counts$y, label = df_counts$counts, size = 5)

}
