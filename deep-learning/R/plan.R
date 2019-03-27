plan <- drake_plan(
  data = read_csv(file_in("data/customer_churn.csv"), col_types = cols()) %>%
    initial_split(prop = 0.3),
  rec = prepare_recipe(data),
  model = target(
    train_model(data, rec, dropout),
    transform = map(dropout = c(0.1, 0.2, 0.3, 0.4))
  ),
  conf = target(
    confusion_matrix(data, rec, model),
    transform = map(model)
  ),
  comparison = target(
    compare_models(conf),
    transform = combine(conf)
  )
)
