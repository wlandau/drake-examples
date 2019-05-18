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

# Too slow? Maybe drake is taking too long to store your models.
# How much runtime overhead do we suffer?

build <- build_times(model_relu, type = "build")$elapsed
command <- build_times(model_relu, type = "command")$elapsed
overhead <- sprintf("%.3f%%", 100 * (build - command) / build)
print(overhead)

# For this example, it is not so bad.
# But if it takes too long to fit deep learning models
# in your application, see 
# https://github.com/wlandau/drake-examples/tree/master/customer-churn-fast
