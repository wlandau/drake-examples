# This configuration file empowers the r_*() utility
# functions such as r_make(), r_vis_drake_graph,
# r_outdated() and r_predict_runtime(). For details, visit
# https://ropenscilabs.github.io/drake-manual/projects.html#safer-interactivity
# and
# https://ropensci.github.io/drake/reference/r_make.html
source("R/packages.R")
source("R/functions.R")
source("R/plan.R")
drake_config(plan)
