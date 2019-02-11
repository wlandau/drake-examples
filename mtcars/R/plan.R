# This is where you set up your workflow plan,
# a data frame with the steps of your analysis.

###################
### THE NEW WAY ###
###################

# drake >= 7.0.0 has a new interface for generating plans.
# Read about it at https://ropenscilabs.github.io/drake-manual/plans.html

my_plan <- drake_plan(
  report = knit(knitr_in("report.Rmd"), file_out("report.md"), quiet = TRUE),
  small = simulate(48),
  large = simulate(64),
  regression1 = target(
    reg1(data),
    transform = map(data = c(small, large), .tag_out = reg)
  ),
  regression2 = target(
    reg2(data),
    transform = map(data, .tag_out = reg)
  ),
  summ = target(
    suppressWarnings(summary(reg$residuals)),
    transform = map(reg)
  ),
  coef = target(
    suppressWarnings(summary(reg))$coefficients,
    transform = map(reg)
  )
)

###################
### THE OLD WAY ###
###################

# The old way of generating plans takes more steps,
# but it has been around longer.

if (FALSE) { # suppressed

# We write drake commands to generate our two bootstrapped datasets.
my_datasets <- drake_plan(
  small = simulate(48),
  large = simulate(64)
)

# Optionally, get replicates with expand_plan(my_datasets,
#   values = c("rep1", "rep2")).
# Bootstrapping involves randomness, so this is good practice
# in real life. But this is a miniaturized workflow,
# so we will not use replicates here.

# This is a wildcard template for generating more commands.
# These new commands will apply our regression models
# to each of the datasets in turn.
methods <- drake_plan(
  regression1 = reg1(dataset__),
  regression2 = reg2(dataset__)
)

# Here, we use the template to expand the `methods` template
# over the datasets we will analyze.
my_analyses <- evaluate_plan(
  methods, wildcard = "dataset__",
  values = my_datasets$target
)

# Now, we summarize each regression fit of each bootstrapped dataset.
# We will look at these summaries to figure out if fuel efficiency
# and weight are related somehow.
summary_types <- drake_plan(
  summ = suppressWarnings(summary(analysis__$residuals)), # Summarize the RESIDUALS of the model fit. # nolint
  coef = suppressWarnings(summary(analysis__))$coefficients # Coefficinents with p-values # nolint
)

my_summaries <- evaluate_plan(
  summary_types,
  wildcard = "analysis__",
  values = my_analyses$target
)

# Use `knitr_in()` to tell drake to look for dependencies
# inside report.Rmd (targets referenced explicitly with loadd() and readd()
# in active code chunks).
# Use file_out() to tell drake that the target is a file.
# drake knows to put report.md in the "target" column when it comes
# time to make().
report <- drake_plan(
  report = knit(knitr_in("report.Rmd"), file_out("report.md"), quiet = TRUE)
)

# Row order doesn't matter in the workflow my_plan.
my_plan <- bind_plans(report, my_datasets, my_analyses, my_summaries)

}

