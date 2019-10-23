# Generate a historgram plot of the munged data and save in the data
# folder for later use

munged_data <- readRDS("data/munged_data.RDS")

gg <- munged_data %>%
  ggplot() +
    geom_histogram(
      aes(
        x = Petal.Width,
        fill = Species
        ),
      binwidth = 0.25) +
    theme_gray(20)

ggsave(
  filename = "data/Petal_Width_vs_Species.PNG",
  plot = gg,
  width = 6,
  height = 6
)

saveRDS(gg, "data/Petal_Width_vs_Species.RDS")
