# This workflow is designed to maximize overhead and stress-test drake.
# The goal is to improve drake's internals so this example runs fast.
#
# Let n be the number of targets.
# There are n * (n - 1) / 2 non-file dependency connections
# among all the targets, which is the maximum possible.
# For i = 2, ..., n, target i depends on targets 1 through i - 1.

library(drake)
library(microbenchmark)
library(storr)

# See vis_drake_graph(drake_config(plan(8)), targets_only = TRUE)

plan <- function(n){
  plan <- drake_plan(target_1 = 1)
  for (i in seq_len(n - 1) + 1){
    target <- paste0("target_", i)
    dependencies <- paste0("target_", seq_len(i - 1))
    command <- paste0("max(", paste0(dependencies, collapse = ", "), ")")
    plan <- rbind(plan, data.frame(target = target, command = command))
  }
  plan
}

cache <- function(n){
  path <- file.path(tempdir(), paste0("cache", n))
  cache <- storr_rds(path, mangle_key = TRUE)
  clean(cache = cache)
  cache
}

overhead <- function(n){
  make(plan(n), cache = cache(n), verbose = 4)
}

# Uncomment the lines below to increase the scale of the testing scenarios.

benchmarks <- microbenchmark(
  overhead(8),
  overhead(16),
  overhead(32),
#  overhead(64),
#  overhead(128),
#  overhead(256),
#  overhead(512),
#  overhead(1024),
  times = 10
)

print(benchmarks)
