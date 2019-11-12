# We will use the cranlogs package to get the data.
# The data frames `older` and `recent` will
# contain the number of daily downloads for each package
# from the RStudio CRAN mirror.
# For the recent data, we will use a custom trigger.
# That way, drake automatically knows to fetch the recent data
# when a new CRAN log becomes available.

plan <- drake_plan(
  older = cran_downloads(
    packages = c("knitr", "Rcpp", "ggplot2"),
    from = "2016-11-01",
    to = "2016-12-01"
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
