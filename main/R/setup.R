# Load our packages in the usual way.
# This example requires packages forcats, readxl, and rmarkdown,
# but you do not need to load them here.
library(drake)
require(dplyr)
require(ggplot2)
pkgconfig::set_config("drake::strings_in_dots" = "literals") # New file API

# Your custom code is a bunch of functions.
create_plot <- function(data) {
  ggplot(data, aes(x = Petal.Width, fill = Species)) +
    geom_histogram(binwidth = 0.25) +
    theme_gray(20)
}
