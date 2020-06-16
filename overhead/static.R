source("setup.R")
plan <- drake_plan(
  z = target(w, transform = map(w = !!seq_len(1e3)))
)
system.time(profile(plan))
