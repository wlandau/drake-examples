# Each row represents a model we fit to gross state product
analysis_steps <- tibble(
  covariate = c("unemp", "emp"),
  dataset = "dataset"
) %>%
  mutate(
    id = covariate,
    dataset = syms(dataset)
  )

# Turn the analysis steps into targets and commands.
analysis_plan <- map_plan(analysis_steps, fit_and_plot) %>%
  gather_plan(target = "plots", gather = "gather_plots", append = TRUE)

# Create the whole drake plan.
plan <- drake_plan(
  dataset = prepare_dataset(),
  report = knit(knitr_in("report.Rmd"), file_out("report.md"), quiet = TRUE)
) %>%
  rbind(analysis_plan)
