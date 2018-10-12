# This file contains all the functions of the workflow.
# If needed, you could split it up into multiple files.

# Fit a model given a bunch of covarites and data
fit_gsp_model <- function(V1, V2, V3, data){
  lm(as.formula(paste("gsp ~", V1, "+", V2, "+", V3)), data = data)
}
# fit_gsp_model("state", "year", "pcap", Produc) # nolint

# We need to define a function to get the
# root mean squared prediction error.
get_rmspe <- function(lm_fit, data){
  y <- data$gsp
  yhat <- predict(lm_fit, data = data)
  terms <- attr(summary(lm_fit)$terms, "term.labels")
  data.frame(
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
