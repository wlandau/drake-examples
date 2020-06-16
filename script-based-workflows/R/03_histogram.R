# Generate a historgram plot of the munged data and save in the data
# folder for later use

munged_data <- readRDS("data/munged_data.RDS")

gg <-  ggplot(munged_data) +
  geom_histogram(aes(x = Ozone), binwidth = 10) +
  theme_gray(24)

ggsave(
  filename = "data/ozone.PNG",
  plot = gg,
  width = 6,
  height = 6
)

saveRDS(gg, "data/ozone.RDS")
