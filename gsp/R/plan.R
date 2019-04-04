# This is where you set up your workflow plan,
# a data frame with the steps of your analysis.

data(Produc) # Gross State Product
head(Produc) # ?Produc

# We want to predict "gsp" based on the other variables.
predictors <- setdiff(colnames(Produc), "gsp")

# We will try all combinations of three covariates.
combos <- combn(predictors, 3) %>%
  t() %>%
  as.data.frame(stringsAsFactors = FALSE) %>%
  setNames(c("x1", "x2", "x3"))

# We need to list each covariate as a symbol.
for (col in colnames(combos)) {
  combos[[col]] <- rlang::syms(combos[[col]])
}

# Requires drake >= 7.0.0 or the development version
# at github.com/ropensci/drake.
# Install with remotes::install_github("ropensci/drake").
plan <- drake_plan(
  model = target(
    biglm(gsp ~ x1 + x2 + x3, data = Ecdat::Produc),
    transform = map(.data = !!combos) # Remember the bang-bang!!
  ),
  rmspe_i = target(
    get_rmspe(model, Ecdat::Produc),
    transform = map(model)
  ),
  rmspe = target(
    bind_rows(rmspe_i, .id = "model"),
    transform = combine(rmspe_i)
  ),
  plot = ggsave(
    filename = file_out("rmspe.pdf"),
    plot = plot_rmspe(rmspe),
    width = 8,
    height = 8
  ),
  report = knit(knitr_in("report.Rmd"), file_out("report.md"), quiet = TRUE)
)
