# This functions.R file is subtly different from the one from customer-churn-simple:
# https://github.com/wlandau/drake-examples/blob/master/customer-churn-simple/R/functions.R
# See the comments below for details.

prepare_recipe <- function(data) {
  data %>%
    training() %>%
    recipe(Churn ~ .) %>%
    step_rm(customerID) %>%
    step_naomit(all_outcomes(), all_predictors()) %>%
    step_discretize(tenure, options = list(cuts = 6)) %>%
    step_log(TotalCharges) %>%
    step_mutate(Churn = ifelse(Churn == "Yes", 1, 0)) %>%
    step_dummy(all_nominal(), -all_outcomes()) %>%
    step_center(all_predictors(), -all_outcomes()) %>%
    step_scale(all_predictors(), -all_outcomes()) %>%
    prep()
}

define_model <- function(rec) {
  input_shape <- ncol(
    juice(rec, all_predictors(), composition = "matrix")
  )
  keras_model_sequential() %>%
    layer_dense(
      units = 16,
      kernel_initializer = "uniform",
      activation = "relu",
      input_shape = input_shape
    ) %>%
    layer_dropout(rate = 0.1) %>%
    layer_dense(
      units = 16,
      kernel_initializer = "uniform",
      activation = "relu"
    ) %>%
    layer_dropout(rate = 0.1) %>%
    layer_dense(
      units = 1,
      kernel_initializer = "uniform",
      activation = "sigmoid"
    )
}

# We add a new model_file argument.
train_model <- function(data, rec, batch_size, model_file) {
  model <- define_model(rec)
  compile(
    model,
    optimizer = "adam",
    loss = "binary_crossentropy",
    metrics = c("accuracy")
  )
  x_train_tbl <- juice(
    rec,
    all_predictors(),
    composition = "matrix"
  )
  y_train_vec <- juice(rec, all_outcomes()) %>%
    pull()
  history <- fit(
    object = model,
    x = x_train_tbl,
    y = y_train_vec,
    batch_size = batch_size,
    epochs = 35,
    validation_split = 0.30,
    verbose = 0
  )
  
  # Instead of calling serialize_model(), we save the model to a file.
  save_model_hdf5(model, model_file)
  
  # As an added bonus, we can now return the history from the function.
  history
}

# Again, we need a model_file argument.
confusion_matrix <- function(data, rec, model_file) {
  # Instead of calling unserialize_model(),
  # we load the model from the HDF5 file.
  model <- load_model_hdf5(model_file)
  
  testing_data <- bake(rec, testing(data))
  x_test_tbl <- testing_data %>%
    select(-Churn) %>%
    as.matrix()
  y_test_vec <- testing_data %>%
    select(Churn) %>%
    pull()
  yhat_keras_class_vec <- model %>%
    predict_classes(x_test_tbl) %>%
    as.factor() %>%
    fct_recode(yes = "1", no = "0")
  yhat_keras_prob_vec <-
    model %>%
    predict_proba(x_test_tbl) %>%
    as.vector()
  test_truth <- y_test_vec %>%
    as.factor() %>%
    fct_recode(yes = "1", no = "0")
  estimates_keras_tbl <- tibble(
    truth = test_truth,
    estimate = yhat_keras_class_vec,
    class_prob = yhat_keras_prob_vec
  )
  estimates_keras_tbl %>%
    conf_mat(truth, estimate)
}

compare_models <- function(...) {
  batch_sizes <- match.call()[-1] %>%
    as.character() %>%
    gsub(pattern = "conf_", replacement = "")
  df <- map_df(list(...), summary) %>%
    filter(.metric %in% c("accuracy", "sens", "spec")) %>%
    mutate(
      batch_size = rep(batch_sizes, each = n() / length(batch_sizes))
    ) %>%
    rename(metric = .metric, estimate = .estimate)
  ggplot(df) +
    geom_line(
      aes(x = metric, y = estimate, color = batch_size, group = batch_size)
    ) +
    theme_gray(16)
}
