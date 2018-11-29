# Center and scale the dataset.
prepare_dataset <- function() {
  data(Produc) # From package Ecdat
  Produc %>%
    select(-year, -state) %>%
    as.matrix() %>%
    scale() %>%
    as_tibble()
}

fit_and_plot <- function(covariate, dataset) {
  fit_model(covariate, dataset) %>%
    plot_model(covariate, dataset)
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
    iter = 1e4, # Change the number of iterations to vary runtime.
    refresh = 0,
    show_messages = FALSE
  )
}

# Plot a fitted Bayesian regression model
# along with the data.
plot_model <- function(fit, covariate, dataset) {
  samples <- as.data.frame(fit)
  colnames(samples)[1] <- "intercept"
  ggplot() +
    geom_point(aes_string(x = covariate, y = "gsp"), dataset) +
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

# Plot multiple ggplot2 plots in the same window.
gather_plots <- function(...) {
  grid.arrange(..., ncol = 2)
}
