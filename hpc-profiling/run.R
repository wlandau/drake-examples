library(dplyr)
library(drake)
library(jointprof) # remotes::install_github("r-prof/jointprof")
library(profile)

# Just throw around some medium-ish data.
create_plan <- function() {
  plan <- drake_plan(
    data1 = target(x, transform = map(i = !!seq_len(8))),
    data2 = target(data1, transform = map(data1, .id = FALSE)),
    data3 = target(data2, transform = map(data2, .id = FALSE)),
    data4 = target(data3, transform = map(data3, .id = FALSE)),
    data5 = target(bind_rows(data4), transform = combine(data4))
  )
  plan$format <- "fst"
  plan
}

# Profiling.
run_profiling <- function(
  path = "profile.proto",
  n = 2e7,
  parallelism = "loop",
  jobs = 1L
) {
  unlink(path)
  unlink(".drake", recursive = TRUE, force = TRUE)
  on.exit(unlink(".drake", recursive = TRUE, force = TRUE))
  x <- data.frame(x = runif(n), y = runif(n))               
  plan <- create_plan()
  rprof_file <- tempfile()
  Rprof(filename = rprof_file)
  options(
    clustermq.scheduler = "sge",
    clustermq.template = "sge_clustermq.tmpl"
  )
  make(
    plan,
    parallelism = parallelism,
    jobs = jobs,
    memory_strategy = "preclean",
    garbage_collection = TRUE
  )
  Rprof(NULL)
  data <- read_rprof(rprof_file)
  write_pprof(data, path)
}

# Visualize the results.
vis_pprof <- function(path, host = "localhost") {
  server <- sprintf("%s:%s", host, random_port())
  message("local pprof server: http://", server)
  system2(find_pprof(), c("-http", server, shQuote(path)))
}

# These ports should be fine for the pprof server.
random_port <- function(from = 49152L, to = 65355L) {
  sample(seq.int(from = from, to = to, by = 1L), size = 1)
}

# Run stuff.
path <- "profile.proto"
run_profiling(path, n = 2e7)
vis_pprof(path)
