plan <- drake_plan(
  data = read_csv(file_in("data/customer_churn.csv"), col_types = cols()) %>%
    initial_split(prop = 0.3),
  churn_recipe = prepare_recipe(data),
  history = fit_model(data, churn_recipe, file_out("model.h5")),
  history_plot = plot(history),
  conf_matrix = get_conf_matrix(data, churn_recipe, file_in("model.h5")),
  report_step = rmarkdown::render(
    knitr_in("results.Rmd"),
    output_file = file_out("results.html"),
    quiet = TRUE
  )
)
