# Profile the overhead incurred by drake on a large example.

n <- 1024
max_deps <- floor(sqrt(n))

library(drake)
library(fs)
library(processx)
library(profile)

# Let n be the number of targets.
# If max_deps is Inf, there are n * (n - 1) / 2 dependency connections
# among all the targets (maximum possible)
# For i = 2, ..., n, target i depends on targets 1 through i - 1.
create_plan <- function(n, max_deps = sqrt(n)) {
  plan <- drake_plan(target_1 = 1)
  for (i in seq_len(n - 1) + 1){
    target <- paste0("target_", i)
    dependencies <- paste0("target_", tail(seq_len(i - 1), max_deps))
    command <- paste0("max(", paste0(dependencies, collapse = ", "), ")")
    plan <- rbind(plan, data.frame(target = target, command = command))
  }
  plan
}

config_rprof <- function(n, max_deps = sqrt(n)) {
  paste0("config_rprof_", n, "_", max_deps, ".Rprof")
}

make_rprof <- function(n, max_deps = sqrt(n)) {
  paste0("make_rprof_", n, "_", max_deps, ".Rprof")
}

overhead <- function(n, max_deps = sqrt(n)) {
  plan <- create_plan(n = n, max_deps = max_deps)
  cache <- new_cache(tempfile())
  Rprof(filename = config_rprof(n, max_deps))
  config <- drake_config(plan = plan, cache = cache, verbose = 0)
  Rprof(filename = make_rprof(n, max_deps))
  make(config = config)
  Rprof(NULL)
}

overhead(n, max_deps) # Could take a long time

# Convert profiling results to pprof-friendly format.
for(path in c(config_rprof(n, max_deps), make_rprof(n, max_deps))) {
  proto <- path_ext_set(path, "proto")
  graph <- path_ext_set(path, "pdf")
  data <- read_rprof(path)
  write_pprof(data, proto)
}

# Works on Linux but not from R
# system2("bash", "graph.sh") # Works in Linux but not from R.
