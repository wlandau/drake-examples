# Changes the factor order in the `Species` field to order of appearance
# in the field rather than alphabetically

raw_data <- readRDS("data/loaded_data.RDS")

munged_data <- raw_data %>%
  mutate(Ozone = replace_na(Ozone, mean(Ozone, na.rm = TRUE)))

saveRDS(munged_data, "data/munged_data.RDS")
