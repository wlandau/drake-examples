# This plan is different from the one from customer-churn-simple:
# https://github.com/wlandau/drake-examples/blob/master/customer-churn-simple/R/plan.R
# Below, we save Keras models to special HDF5 files
# to avoid a potential serialization bottleneck:
# https://github.com/richfitz/storr/issues/77#issuecomment-476275570

batch_sizes <- c(16, 32)
model_files <- paste0("model_", batch_sizes, ".h5")

plan <- drake_plan(
  data = read_csv(file_in("data/customer_churn.csv"), col_types = cols()) %>%
    initial_split(prop = 0.3),
  rec = prepare_recipe(data),
  history = target(
    train_model(data, rec, batch_size, file_out(model_file)),
    transform = map(
      batch_size = !!batch_sizes,
      model_file = !!model_files,
      .id = batch_size
    )
  ),
  conf = target(
    confusion_matrix(data, rec, file_in(model_file)),
    transform = map(model_file, .id = batch_size)
  ),
  comparison = target(
    compare_models(conf),
    transform = combine(conf)
  )
)
