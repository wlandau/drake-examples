# Changes the factor order in the `Species` field to order of appearance
# in the field rather than alphabetically

raw_data <- readRDS("data/loaded_data.RDS")

munged_data <- raw_data %>%
  mutate(Species = forcats::fct_inorder(Species))

saveRDS(munged_data, "data/munged_data.RDS")
