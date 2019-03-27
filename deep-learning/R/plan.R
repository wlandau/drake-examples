dropout <- seq(0.1, 0.4, by = 0.1)

plan <- drake_plan(
  data = read_csv(file_in("data/customer_churn.csv"), col_types = cols()) %>%
    initial_split(prop = 0.3),
  rec = prepare_recipe(data),
  model = target(
    train_model(data, rec, drop),
    transform = map(drop = !!dropout)
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
