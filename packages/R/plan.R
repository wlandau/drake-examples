# We will use the cranlogs package to get the data.
# The data frames `older` and `recent` will
# contain the number of daily downloads for each package
# from the RStudio CRAN mirror.
# For the recent data, we will use a custom trigger.
# That way, drake automatically knows to fetch the recent data
# when a new CRAN log becomes available.

###################
### THE NEW WAY ###
###################

# drake >= 7.0.0 has a new interface for generating plans.
# Read about it at https://ropenscilabs.github.io/drake-manual/plans.html

plan <- drake_plan(
  older = cran_downloads(
    packages = c("knitr", "Rcpp", "ggplot2"),
    from = "2016-11-01",
    to = "2016-12-01",
  ),
  recent = target(
    command = cran_downloads(
      packages = c("knitr", "Rcpp", "ggplot2"),
      when = "last-month"),
    trigger = trigger(change = latest_log_date())
  ),
  averages = target(
    make_my_table(data),
    transform = map(data = c(older, recent))
  ),
  plot = target(
    make_my_plot(data),
    transform = map(data)
  ),
  report = knit(knitr_in("report.Rmd"), file_out("report.md"), quiet = TRUE)
)


###################
### THE OLD WAY ###
###################

# The old way of generating plans takes more steps,
# but it has been around longer.

if (FALSE) { # suppressed

data_plan <- drake_plan(
  older = cran_downloads(
    packages = c("knitr", "Rcpp", "ggplot2"),
    from = "2016-11-01",
    to = "2016-12-01"
  ),
  recent = target(
    command = cran_downloads(
      packages = c("knitr", "Rcpp", "ggplot2"),
      when = "last-month"
    ),
    trigger = trigger(change = latest_log_date())
  )
)

# The latest download data needs to be refreshed every day,
# so in data_plan above, we use triggers
# to force `recent` to always build.
# For more on triggers, see the guide to debugging and testing:
# https://ropenscilabs.github.io/drake-manual/debug.html # nolint

# We want to summarize each set of
# download statistics a couple different ways.

output_types <- drake_plan(
  averages = make_my_table(dataset__),
  plot = make_my_plot(dataset__)
)

# Below, the targets `recent` and `older`
# each take turns substituting the `dataset__` wildcard.
# Thus, `output_plan` has four rows.

output_plan <- evaluate_plan(
  plan = output_types,
  wildcard = "dataset__",
  values = data_plan$target
)

# We plan to weave the results together
# in a dynamic knitr report.

report_plan <- drake_plan(
  report = knit(knitr_in("report.Rmd"), file_out("report.md"), quiet = TRUE)
)

# And we complete the workflow plan data frame by
# concatenating the results together.
# drake analyzes the plan to figure out the dependency network,
# so row order does not matter.

plan <- bind_plans(
  data_plan,
  output_plan,
  report_plan
)

}
