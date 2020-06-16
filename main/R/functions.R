# Your custom code is a bunch of functions.
create_plot <- function(data) {
  ggplot(data) +
    geom_histogram(aes(x = Ozone), binwidth = 10) +
    theme_gray(24)
}
