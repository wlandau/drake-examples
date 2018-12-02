# Unsurprisingly, GNU Make runs much faster than drake.
# Much of drake's overhead is due to
# static code analysis (preprocessing)
# and base 64 encoding in storr.

library(MakefileR)
library(microbenchmark)

n <- 1024
m <- makefile() +
  make_rule("all", paste0("target_", n)) +
  make_rule("clean", "", "rm -rf target_*")
for (i in seq_len(n)) {
  target <- paste0("target_", i)
  deps <- seq_len(i)[-i]
  if (length(deps)){
    deps <- paste0("target_", deps)
  }
  m <- m + make_rule(target, deps, paste0("touch ", target))
}
write_makefile(m, "Makefile")

system2("make", "clean")
benchmark <- microbenchmark(system2("make"), times = 1)
system2("make", "clean")

print(benchmark)
