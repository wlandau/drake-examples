# Visit https://ropenscilabs.github.io/drake-manual/plans.html
# to learn about workflow plan data frames in drake.

library(drake)

# Get a workflow plan data frame from an R script
plan <- code_to_plan("script.R")
print(plan)

# The example R Markdown report returns the same plan.
code_to_plan("report.Rmd")

# Run the worklflow with make()
make(plan)

# Inspect the output
readd(z)
