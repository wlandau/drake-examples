# Visit https://books.ropensci.org/drake/plans.html
# to learn about workflow plan data frames in drake.

# Let's begin with the main example (drake_example("main")).
# We have our supporting packages,
library(drake)
library(tidyverse)

# and functions,
create_plot <- function(data) {
  ggplot(data) +
    geom_histogram(aes(x = Ozone)) +
    theme_gray(24)
}

# and drake plan.
plan <- drake_plan(
  raw_data = readxl::read_excel(file_in("raw_data.xlsx")),
  data = raw_data %>%
    mutate(Ozone = replace_na(Ozone, mean(Ozone, na.rm = TRUE))),
  hist = create_plot(data),
  fit = lm(Ozone ~ Wind + Temp, data),
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  )
)

# Our plan is equivalent to following R script.
plan_to_code(plan, "new_script.R")
cat(readLines("new_script.R"), sep = "\n")

# And the following notebook.
plan_to_notebook(plan, "new_notebook.Rmd")
cat(readLines("new_notebook.Rmd"), sep = "\n")

# In drake, we build the targets by running the plan.
make(plan)

# This is the similar to running new_script.R in your workspace.
source("new_script.R", local = TRUE)

# Or running the notebook in your workspace.
knitr::knit("new_notebook.Rmd")
