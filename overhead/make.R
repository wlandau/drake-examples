# This workflow is designed to maximize overhead and stress-test drake.
# The goal is to improve drake's internals so this example runs fast.
#
# Let n be the number of targets.
# There are n * (n - 1) / 2 non-file dependency connections
# among all the targets, which is the maximum possible.
# For i = 2, ..., n, target i depends on targets 1 through i - 1.

n <- 4

library(drake)
library(magrittr)
plan <- drake_plan(target_1 = 1)
for (i in seq_len(n - 1) + 1){
  target <- paste0("target_", i)
  dependencies <- paste0("target_", seq_len(i - 1))
  command <- paste0("max(", paste0(dependencies, collapse = ", "), ")")
  plan <- rbind(plan, data.frame(target = target, command = command))
}
make(plan, verbose = 4)
