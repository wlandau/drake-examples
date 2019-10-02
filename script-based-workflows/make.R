# This is where you set up your workflow plan,
# a data frame with the steps of your analysis.

# drake >= 7.6.2.9000 as a new interface for handling script-based plans.
# Read about it at
# https://ropenscilabs.github.io/drake-manual/script_based_workflows.html

source("R/packages.R")  # Load all the packages you need.
source("R/plan.R")      # Build your workflow plan data frame.

# Now it is time to actually run your project.
make(my_plan)

# Now, if you make(my_plan) again, no work will be done
# because the results are already up to date.
# But change the code and some targets will rebuild.
