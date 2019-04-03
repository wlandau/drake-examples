# Run the whole workflow in batch mode.
# For guidance on how to set up drake projects, visit
# https://ropenscilabs.github.io/drake-manual/projects.html
source("R/packages.R")
source("R/functions.R")
source("R/plan.R")
options(clustermq.scheduler = "sge", clustermq.template = "sge_clustermq.tmpl")
make(plan, parallelism = "clustermq", jobs = 1)
