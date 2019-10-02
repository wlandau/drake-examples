# The factor order in the `Species` field will be re-ordered

raw_data <- readRDS("data/loaded_data.RDS")

munged_data <- raw_data %>%
  mutate(Species = forcats::fct_inorder(Species))

saveRDS(munged_data, "data/munged_data.RDS")

