# Load packages and function -----------------------------------------------------------
source("packages.R")

sourceDirectory("R")

# Set Slurm options for workers -------------------------------------------

options(clustermq.scheduler = "slurm",
        clustermq.template = "slurm_clustermq.tmpl")

# Create plans ------------------------------------------------------------

benchmark_plan = code_to_plan("benchmark.R")

# Set the config ----------------------------------------------------------

drake_config(benchmark_plan, verbose = 2, parallelism = "clustermq", jobs = 2,
             template = list(n_cpus = 17, memory = 34000, log_file = "worker%a.log"), 
             console_log_file = "drake.log")


