library(drake)
library(storr)

save_bar_plot <- function(data, file) {
  png(file)
  par(mar = c(15, 4, 0.5, 0.5))
  barplot(data, las = 2)
  dev.off()
  file
}

plan <- drake_plan(
  bar_data = setNames(dat$number, dat$name),
  bar_plot = save_bar_plot(bar_data, file_out("mygraph.png"))
)

cache <- storr_rds("../.drake")
make(plan)
