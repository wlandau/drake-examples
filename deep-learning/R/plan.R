plan <- drake_plan(
  data = read_csv(file_in("data/customer_churn.csv"), col_types = cols()) %>%
    initial_split(prop = 0.3),
  rec = prepare_recipe(data),
  model = train_model(data, rec),
  conf = confusion_matrix(data, rec, model),
  report = rmarkdown::render(
    knitr_in("results.Rmd"),
    output_file = file_out("results.html"),
    quiet = TRUE
  )
)
