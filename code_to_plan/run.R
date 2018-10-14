# Visit https://ropenscilabs.github.io/drake-manual/plans.html
# to learn about workflow plan data frames in drake.

# Let us begin wtih a drake plan supporting packages and functions.

library(drake)
library(tidyverse)
pkgconfig::set_config("drake::strings_in_dots" = "literals") # New file API

create_plot <- function(data) {
  ggplot(data, aes(x = Petal.Width, fill = Species)) +
    geom_histogram(binwidth = 0.25) +
    theme_gray(20)
}

plan <- drake_plan(
  raw_data = readxl::read_excel(file_in("raw_data.xlsx")),
  data = raw_data %>%
    mutate(Species = forcats::fct_inorder(Species)) %>%
    select(-X__1),
  hist = create_plot(data),
  fit = lm(Sepal.Width ~ Petal.Width + Species, data),
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  )
)

# This plan is equivalent to following R script
plan_to_code(plan, "new_script.R")

# and the following notebook.
plan_to_notebook(plan, "new_notebook.Rmd")

# In drake, you build the targets by running the plan.
make(plan)

# This is the same as running new_script.R in your workspace.
source("new_script.R", local = TRUE)

# Or running the notebook in your workspace.
knitr::knit("new_notebook.Rmd")
