# Here, load the packages you need for your workflow.

library(drake)
library(dplyr)
library(Ecdat) # econometrics datasets
library(ggplot2)
library(gridExtra)
library(rlang)
library(rmarkdown)
library(rstanarm) # Bayesian generalized linear models
library(tibble)

pkgconfig::set_config("drake::strings_in_dots" = "literals")
