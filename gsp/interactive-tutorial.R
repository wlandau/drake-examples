# This file is an interactive tutorial that only depends
# on the included report.Rmd file.
# It is meant to walk you through the analysis step by step.
# The other files show how to set up this example
# as a serious drake project. Run make.R to deploy it
# as a serious workflow.
#
# The following data analysis workflow shows off
# `drake`'s ability to generate lots of reproducibly-tracked
# tasks with ease.
# The same technique would be cumbersome, even intractable,
# with GNU Make (https://www.gnu.org/software/make/).
#
# The goal of the example is to search for factors closely associated with
# the productivity of states in the USA around the 1970s and 1980s.
# For the sake of simplicity, we use gross state product as a metric
# of productivity, and we restrict ourselves to
# multiple linear regression models with three variables.
# For each of the 84 possible models, we fit the data and then
# evaluate the root mean squared prediction error (RMSPE).
#
# RMSPE = sqrt(mean((y - yhat)^2)) # nolint
#
# Here, `y` is the vector of observed gross state products in the data,
# and `yhat` is the vector of predicted gross state products
# under one of the models.
# We take the best variables to be
# the triplet in the model with the lowest RMSPE.
#
# Also see the corresponding chapter of the user manual:
# https://ropenscilabs.github.io/drake-manual/example-gsp.html\

library(drake)
library(Ecdat) # econometrics datasets
library(ggplot2)
library(knitr)
library(magrittr) # for the pipe operator %>%
library(purrr)
library(rlang)

pkgconfig::set_config("drake::strings_in_dots" = "literals")

data(Produc) # Gross State Product
head(Produc) # ?Produc

# We want to predict "gsp" based on the other variables.
predictors <- setdiff(colnames(Produc), "gsp")

# We will try all combinations of three covariates.
combos <- combn(predictors, 3) %>%
  t() %>%
  as.data.frame(stringsAsFactors = FALSE)
head(combos)

# Use these combinations to generate
# a workflow plan data frame for drake.
# We generate the plan in stages.

# First, we apply the models to the datasets.
# We make a separate `drake` plan for this purpose.
# Let's start by making the target names
targets <- apply(combos, 1, paste, collapse = "_")
head(targets)

# Each target will be a call to `fit_gsp_model()`
# on 3 covariates.
fit_gsp_model <- function(..., data){
  c(...) %>%
    paste(collapse = " + ") %>%
    paste("gsp ~", .) %>%
    as.formula() %>%
    lm(data = data)  
}
fit_gsp_model("unemp", "year", "pcap", data = Produc) %>%
  summary()

# So we will generate calls to `fit_gsp_model()`
# as commands for the model-fitting part of the plan.
make_gsp_model_call <- function(...){
  args <- list(..., data = quote(Produc))
  quote(fit_gsp_model) %>%
    c(args) %>%
    as.call() %>%
    rlang::expr_text()
}
make_gsp_model_call("state", "year", "pcap")

commands <- purrr::pmap_chr(combos, make_gsp_model_call)
head(commands)

# We create the model-fitting part of our plan
# by combining the targets and commands together in a data frame.
model_plan <- data.frame(
  target = targets,
  command = commands,
  stringsAsFactors = FALSE
)
head(model_plan)

# Judge the models based on the root mean squared prediction error (RMSPE)
commands <- paste0("get_rmspe(", targets, ", data = Produc)")
targets <- paste0("rmspe_", targets)
rmspe_plan <- data.frame(target = targets, command = commands)

# We need to define a function to get the RMSPE.
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

# Aggregate all the results together.
rmspe_results_plan <- gather_plan(
  plan = rmspe_plan,
  target = "rmspe",
  gather = "rbind"
)

# Plan some final output.
output_plan <- drake_plan(
  ggsave(filename = file_out("rmspe.pdf"), plot = plot_rmspe(rmspe)),
  knit(knitr_in("report.Rmd"), file_out("report.md"), quiet = TRUE)
)

# We need a function to generate the plot.
plot_rmspe <- function(rmspe){
  ggplot(rmspe) +
    geom_histogram(aes(x = rmspe), bins = 30)
}

# Put together the whole plan.
whole_plan <- rbind(model_plan, rmspe_plan, rmspe_results_plan, output_plan)

# Optionally, visualize the interactive workflow graph.
# config <- drake_config(whole_plan) # nolint
# vis_drake_graph(config) # nolint

# Just see the dependencies of the report.
# vis_drake_graph(
#   config,
#   from = file_store("report.md"),
#   mode = "in",
#   order = 1 # nolint
# )

# Run the project.
# View the results rmspe.pdf and report.md
make(whole_plan, jobs = 2, verbose = 3)

# Rendering the final output requires pandoc,
# so I did not include it in the workflow plan.
# rmarkdown::render("report.md") # nolint

# Read the results from the drake cache.
rmspe <- readd(rmspe)

# See the best models. The best variables
# are in the top row under `X1`, `X2`, and `X3`.`
head(rmspe[order(rmspe$rmspe, decreasing = FALSE), ])
