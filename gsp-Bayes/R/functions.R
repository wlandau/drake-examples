# Center and scale the dataset.
prepare_dataset <- function() {
  data(Produc) # From package Ecdat
  Produc %>%
    select(-year, -state) %>%
    as.matrix() %>%
    scale() %>%
    as_tibble()
}

# Fit a Bayesian regression model of gross state product
# using the rstanarm package.
# Since we are running Markov chain Monte Carlo,
# this function takes a long time if `iter` is high.
fit_model <- function(covariate, dataset) {
  stan_glm(
    formula = as.formula(paste("gsp ~", covariate)),
    data = dataset,
    family = gaussian(link = "identity"),
    iter = 1e3, # Change the number of iterations to vary runtime.
    refresh = 0,
    show_messages = FALSE
  )
}

# Visualize a single model fit from rstanarm.
plot_model <- function(fit) {
  covariate <- names(coef(fit))[2]
  samples <- as.data.frame(fit)
  colnames(samples)[1] <- "intercept"
  ggplot() +
    geom_point(aes_string(x = covariate, y = "gsp"), fit$data) +
    geom_abline(
      aes_string(slope = covariate, intercept = "intercept"),
      samples,
      color = "skyblue",
      size = 0.2,
      alpha = 0.25
    ) +
    geom_abline(intercept = coef(fit)[1], slope = coef(fit)[2]) +
    theme_gray(20)
}

# Show multiple plots together.
gather_plots <- function(...) {
  grobs <- lapply(list(...), plot_model)
  arrangeGrob(grobs = grobs, ncol = 2)
}
