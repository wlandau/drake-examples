# This is where you set up your workflow plan,
# a data frame with the steps of your analysis.

data(Produc) # Gross State Product
head(Produc) # ?Produc

# We want to predict "gsp" based on the other variables.
predictors <- setdiff(colnames(Produc), "gsp")

# We will try all combinations of three covariates.
combos <- combn(predictors, 3)

# We have a grid of covariates.
x1 <- rlang::syms(combos[1, ])
x2 <- rlang::syms(combos[2, ])
x3 <- rlang::syms(combos[3, ])

# Requires drake >= 7.0.0 or the development version
# at github.com/ropensci/drake.
# Install with remotes::install_github("ropensci/drake").
plan <- drake_plan(
  model = target(
    lm(gsp ~ x1 + x2 + x3, data = Ecdat::Produc),
    transform = map(x1 = !!x1, x2 = !!x2, x3 = !!x3)
  ),
  rmspe_i = target(
    get_rmspe(model, Ecdat::Produc),
    transform = map(model)
  ),
  rmspe = target(
    do.call(rbind, rmspe_i),
    transform = reduce()
  ),
  plot = ggsave(filename = file_out("rmspe.pdf"), plot = plot_rmspe(rmspe)),
  report = knit(knitr_in("report.Rmd"), file_out("report.md"), quiet = TRUE)
)
