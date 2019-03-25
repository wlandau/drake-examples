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

define_model <- function(churn_recipe) {
  input_shape <- ncol(
    juice(churn_recipe, all_predictors(), composition = "matrix")
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

fit_model <- function(data, churn_recipe, model_file) {
  model <- define_model(churn_recipe)
  compile(
    model,
    optimizer = "adam",
    loss = "binary_crossentropy",
    metrics = c("accuracy")
  )
  x_train_tbl <- juice(
    churn_recipe,
    all_predictors(),
    composition = "matrix"
  )
  y_train_vec <- juice(churn_recipe, all_outcomes()) %>%
    pull()
  history <- fit(
    object = model,
    x = x_train_tbl,
    y = y_train_vec,
    batch_size = 50,
    epochs = 35,
    validation_split = 0.30,
    verbose = 0
  )
  save_model_hdf5(model, model_file)
  history
}

get_conf_matrix <- function(data, churn_recipe, model_file) {
  model <- load_model_hdf5(model_file)
  testing_data <- bake(churn_recipe, testing(data))
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
