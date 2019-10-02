# A plot of the resulting munged data will be generated and saved in the data
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
  plot = gg
  )

saveRDS(gg, "data/Petal_Width_vs_Species.RDS")
