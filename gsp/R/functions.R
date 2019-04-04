# We need to define a function to get the
# root mean squared prediction error.
get_rmspe <- function(model_fit, data){
  y <- data$gsp
  yhat <- as.numeric(predict(model_fit, newdata = data))
  terms <- attr(model_fit$terms, "term.labels")
  tibble(
    rmspe = sqrt(mean((y - yhat)^2)), # nolint
    X1 = terms[1],
    X2 = terms[2],
    X3 = terms[3]
  )
}

# We need a function to generate the plot
# of the root mean squared prediction error.
plot_rmspe <- function(rmspe){
  ggplot(rmspe) +
    geom_histogram(aes(x = rmspe), bins = 30)
}
