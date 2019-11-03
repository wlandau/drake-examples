source("setup.R")
plan <- drake_plan(
  x = seq_len(1e4),
  y = target(x, dynamic = map(x))
)
profile(plan)
