# Chapter walkthrough forthcoming in drake manual
# Fixed-Choice Design Simulation

# Load our packages and supporting functions into our session.
source("R/packages.R")
source("R/functions.R")

# Create the `drake` plan that outlines the work we are going to do.
source("R/plan.R")

# Run your work with make().
make(plan)
