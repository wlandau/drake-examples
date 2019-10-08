
# Load the scripts into functions via `code_to_function()`

load_data <- code_to_function("R/01_data.R")
do_munge <- code_to_function("R/02_munge.R")
do_histogram <- code_to_function("R/03_histogram.R")
do_regression <- code_to_function("R/04_regression.R")
generate_report <- code_to_function("R/05_report.R")


# The workflow plan data frame outlines what you are going to do.
my_plan <- drake_plan(
  raw_data    = load_data(),
  munged_data = do_munge(raw_data),
  hist        = do_histogram(munged_data),
  fit         = do_regression(munged_data),
  report      = generate_report(hist, fit)
)
