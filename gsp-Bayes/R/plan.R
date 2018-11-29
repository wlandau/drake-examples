# Each row represents a model we fit to gross state product
analysis_steps <- tibble(
  covariate = c("emp", "unemp"),
  dataset = "dataset"
) %>%
  mutate(
    id = covariate,
    dataset = syms(dataset)
  )

# Turn the analysis steps into targets and commands.
analysis_plan <- map_plan(analysis_steps, fit_model) %>%
  gather_plan(target = "plots", gather = "gather_plots", append = TRUE)

# Create the whole drake plan.
plan <- drake_plan(
  dataset = prepare_dataset(),
  report = render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  )
) %>%
  rbind(analysis_plan)
