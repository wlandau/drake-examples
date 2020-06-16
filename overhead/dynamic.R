source("setup.R")
plan <- drake_plan(
  x = seq_len(1e3),
  y = target(x, dynamic = map(x))
)
system.time(profile(plan))
