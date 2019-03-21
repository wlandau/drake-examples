plan <- drake_plan(
  data = read_csv(file_in("data/customer_churn.csv"), col_types = cols()) %>%
    initial_split(prop = 0.3),
  training_recipe = customer_churn_recipe(data),
  fitted_model = fit_churn_model(training_recipe, data),
  plotted_model = plot(fitted_model),
  confusion_matrix = get_confusion_matrix(training_recipe, data),
  report_step = rmarkdown::render(
    knitr_in("results.Rmd"),
    output_file = file_out("results.html"),
    quiet = TRUE
  )
)
