source("R/packages.R")
source("R/functions.R")
source("R/plan.R")

# Uncomment below to use local multicore computing
# when running tar_make_clustermq().
options(clustermq.scheduler = "multicore")

# Uncomment below to deploy targets to parallel jobs
# on a Sun Grid Engine cluster when running tar_make_clustermq().
# options(clustermq.scheduler = "sge", clustermq.template = "sge.tmpl")

drake_config(
  plan,
  # parallelism = "clustermq", # Uncomment for parallel computing.
  # jobs = 4, # Choose the number of parallel workers.
  lock_envir = FALSE
)
