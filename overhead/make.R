# There are 2n targets, each with n dependencies.
# You can increase n to put heavy strain on drake's internals for profiling.
n <- 4

library(drake)
library(magrittr)
x <- drake_plan(x = sqrt(y__)) %>%
  evaluate_plan(rules = list(y__ = seq_len(n)))
y <- gather_plan(x, target = "y") %>%
  expand_plan(values = seq_len(n))
plan <- rbind(x, y)
make(plan)
