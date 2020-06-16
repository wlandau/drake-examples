source("setup.R")
plan <- drake_plan(
  x = seq_len(1e3),
  y = target(file_create(tempfile()), dynamic = map(x), format = "file")
)
profile(plan)
