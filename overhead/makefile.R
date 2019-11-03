source("setup.R")

n <- 4096
max_deps <- as.integer(sqrt(n))

m <- makefile() +
  make_rule("all", paste0("target_", n)) +
  make_rule("clean", "", "rm -rf target_*") +
  make_rule("target_1", script = "touch target_1")

for (i in seq_len(n - 1) + 1){
  target <- paste0("target_", i)
  deps <- paste0("target_", tail(seq_len(i - 1), max_deps))
  m <- m + make_rule(target, deps, paste0("touch ", target))
}

with_dir(dir_create(tempfile()), {
  write_makefile(m, "Makefile")
  time <- system.time(microbenchmark(system2("make"), times = 1))
})

print(time)
