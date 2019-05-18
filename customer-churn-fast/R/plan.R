# This plan is different from the one from customer-churn-simple:
# https://github.com/wlandau/drake-examples/blob/master/customer-churn-simple/R/plan.R
# Below, we save Keras models to special HDF5 files
# to avoid a potential serialization bottleneck:
# https://github.com/richfitz/storr/issues/77#issuecomment-476275570

activations <- c("relu", "sigmoid")

plan <- drake_plan(
  data = read_csv(file_in("data/customer_churn.csv"), col_types = cols()) %>%
    initial_split(prop = 0.3),
  rec = prepare_recipe(data),
  history = target(
    train_model(data, rec, file_out(!!paste0(act, ".h5")), act1 = act),
    transform = map(act = !!activations)
  ),
  conf = target(
    confusion_matrix(data, rec, file_in(!!paste0(act, ".h5"))),
    transform = map(act)
  ),
  metrics = target(
    compare_models(conf),
    transform = combine(conf)
  )
)
