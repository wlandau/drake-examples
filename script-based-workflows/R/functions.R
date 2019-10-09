
# Convert the scripts into functions via `code_to_function()`

load_data <- code_to_function("R/01_data.R")
do_munge <- code_to_function("R/02_munge.R")
do_histogram <- code_to_function("R/03_histogram.R")
do_regression <- code_to_function("R/04_regression.R")
generate_report <- code_to_function("R/05_report.R")
