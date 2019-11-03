source("setup.R")

n <- 4096L
max_deps <- as.integer(sqrt(n))

plan <- tibble(target = "target_1", command = "1")
for (i in seq_len(n - 1) + 1){
  target <- paste0("target_", i)
  dependencies <- paste0("target_", tail(seq_len(i - 1), max_deps))
  command <- paste0(
    "if(FALSE) loadd(",
    paste0(dependencies, collapse = ", "),
    ")"
  )
  plan <- bind_plans(
    plan,
    tibble(target = target, command = command)
  )
}

profile(plan)