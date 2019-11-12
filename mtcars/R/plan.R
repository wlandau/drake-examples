# This is where you set up your workflow plan,
# a data frame with the steps of your analysis.

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
