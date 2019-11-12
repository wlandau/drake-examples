# This configuration file empowers the r_*() utility
# functions such as r_make(), r_vis_drake_graph,
# r_outdated() and r_predict_runtime(). For details, visit
# https://books.ropensci.org/drake/projects.html#safer-interactivity
# and
# https://docs.ropensci.org/drake/reference/r_make.html
source("R/packages.R")
source("R/functions.R")
source("R/plan.R")

# Optional: submit deep learning models to a Grid Engine cluster.
# Other resource managers like SLURM are similar.
# options(clustermq.scheduler = "sge", clustermq.template = "sge_clustermq.tmpl")
#
# Optional: avoid submitting non-model targets to the cluster (requires drake >= 7.1.0).
# plan$hpc <- grepl("^model_", plan$target)
#
# drake_config(plan, parallelism = "clustermq", jobs = 2)

drake_config(plan)
