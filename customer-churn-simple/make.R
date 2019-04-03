# Run the whole workflow in batch mode.
# For guidance on how to set up drake projects, visit
# https://ropenscilabs.github.io/drake-manual/projects.html
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
# make(plan, parallelism = "clustermq", jobs = 2)

make(plan)
