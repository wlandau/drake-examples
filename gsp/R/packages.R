# Here, load the packages you need for your workflow.

library(drake)
library(Ecdat) # econometrics datasets
library(ggplot2)
library(knitr)
library(magrittr) # for the pipe operator %>%
library(purrr)
library(rlang)

pkgconfig::set_config("drake::strings_in_dots" = "literals")
