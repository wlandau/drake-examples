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
  e <- new.env(parent = globalenv())
  for (i in seq_len(1e3)) {
    assign(x = digest::digest(i), value = 1, envir = e)
  }
  rprof_file <- tempfile()
  plan <- create_plan(n = n, max_deps = max_deps)
  Rprof(filename = rprof_file)
  make(plan)
  Rprof(NULL)
  unlink(".drake", recursive = TRUE, force = TRUE)
  data <- read_rprof(rprof_file)
  write_pprof(data, proto_file(n, max_deps))
}

# Change ip_listen to "0.0.0.0" if you want to view the results
# on a different machine.
vis <- function(n, max_deps, ip_listen = "localhost", port = "8080") {
  message(
    "Navigate a web browser to ",
    system2("hostname", shQuote("--long"), stdout = TRUE),
    ":",
    port,
    "."
  )
  system2(
    find_pprof(),
    c(
      "-http",
      paste0(ip_listen, ":", port),
      shQuote(proto_file(n, max_deps))
    )
  )
}

overhead(n, max_deps)
vis(n, max_deps, ip_listen = "localhost", port = "8081")
