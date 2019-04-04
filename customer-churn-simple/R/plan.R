batch_sizes <- c(16, 32)

plan <- drake_plan(
  data = read_csv(
    file_in("data/customer_churn.csv"),
    col_types = cols()
  ) %>%
    initial_split(prop = 0.3),
  rec = prepare_recipe(data),
  model = target(
    train_model(data, rec, batch_size),
    transform = map(batch_size = !!batch_sizes)
  ),
  conf = target(
    confusion_matrix(data, rec, model),
    transform = map(model, .id = batch_size)
  ),
  comparison = target(
    compare_models(conf),
    transform = combine(conf)
  )
)
