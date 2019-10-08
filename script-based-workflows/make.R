# This is where you set up your workflow plan,
# a data frame with the steps of your analysis.

# drake >= 7.6.2.9000 has a new interface for handling script-based plans.
# Read about it at
# https://ropenscilabs.github.io/drake-manual/script_based_workflows.html

source("R/packages.R")  # Load all the packages you need.
source("R/plan.R")      # Build your workflow plan data frame.

# Now it is time to actually run your project.
make(my_plan)

# Now, if you make(my_plan) again, no work will be done
# because the results are already up to date.
# But change the code in script "03_histogram.R" so that the
# plot is using a bin-width of .5 rather than .25, re-make the
# script-function by either sourcing "R/plan.R" or rerunning the
# `code_to_function()` line that references script "03_histogram.R"
# and some targets will rebuild on the next make(my_plan) call
