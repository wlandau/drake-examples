# This script is just a sketch of how one might
# scale up the gapminder workflow to many targets.
# Accompanies https://wlandau.github.io/drake-datafest-2019/#/scale-up-to-many-targets-1

library(drake)
library(dplyr)

# Multiple datasets.
data_plan <- drake_plan(data = get_data("dataset")) %>%
  evaluate_plan(list(dataset = c("oecd", "unesco", "world_bank")))

# Combination of inputs.
combos <- expand.grid(
  dataset = c("data_oecd", "data_unesco", "data_world_bank"),
  covariate = c("log_pop", "life_exp", "literacy"),
  priors = c("normal", "t", "dirichlet_process"),
  stringsAsFactors = FALSE
) %>%
  mutate(
    id = apply(., 1, paste, collapse = "_"),
    dataset = rlang::syms(dataset)
  )

# Map a function to the combos.
analysis_plan <- map_plan(combos, fit_large_model, trace = TRUE) %>%
  
  # Grouop analyses by covariate.
  gather_by(prefix = "results", gather = "summarize_models", covariate)

# Combine plans.
plan <- bind_plans(data_plan, analysis_plan)

config <- drake_config(plan)
vis_drake_graph(config)
