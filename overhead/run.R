# Profile the overhead incurred by drake on a large example.

n <- 4096L
max_deps <- as.integer(sqrt(n))

library(drake)
library(jointprof) # remotes::install_github("r-prof/jointprof")
library(profile)

# Let n be the number of targets.
# If max_deps is Inf, there are n * (n - 1) / 2 dependency connections
# among all the targets (maximum possible edges)
# For i = 2, ..., n, target i depends on targets 1 through i - 1.
create_plan <- function(n, max_deps) {
  plan <- drake_plan(target_1 = 1)
  for (i in seq_len(n - 1) + 1){
    target <- paste0("target_", i)
    dependencies <- paste0("target_", tail(seq_len(i - 1), max_deps))
    command <- paste0("max(", paste0(dependencies, collapse = ", "), ")")
    plan <- rbind(plan, data.frame(target = target, command = command))
  }
  plan
}

proto_file <- function(n, max_deps) {
  paste0("overhead_rprof_", n, "_", max_deps, ".proto")
}

overhead <- function(n, max_deps) {
  rprof_file <- tempfile()
  plan <- create_plan(n = n, max_deps = max_deps)
  cache <- new_cache(tempfile())
  Rprof(filename = rprof_file)
  config <- drake_config(plan = plan, cache = cache, verbose = 0L)
  make(config = config)
  Rprof(NULL)
  data <- read_rprof(rprof_file)
  write_pprof(data, proto_file(n, max_deps))
}

vis <- function(n, max_deps) {
  system2(
    find_pprof(),
    c(
      "-http",
      "localhost:8081", # Change to 0.0.0.0:8081 if your browser is on another computer. # nolint
      shQuote(proto_file(n, max_deps))
    )
  )
}

overhead(n, max_deps)
vis(n, max_deps)
# Now, open a browser and navigate to localhost:8081.
