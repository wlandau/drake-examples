# Your custom code is a bunch of functions.
create_plot <- function(data) {
  ggplot(data) +
    geom_point(aes(x = Temp, y = Ozone)) +
    theme_gray(24)
}
