source("setup.R")
plan <- drake_plan(
  z = target(w, transform = map(w = !!seq_len(1e4)))
)
profile(plan)
