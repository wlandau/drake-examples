# This is where you set up your workflow plan,
# a data frame with the steps of your analysis.

data(Produc) # Gross State Product
head(Produc) # ?Produc

# We want to predict "gsp" based on the other variables.
predictors <- setdiff(colnames(Produc), "gsp")

# We will try all combinations of three covariates.
combos <- t(combn(predictors, 3))
colnames(combos) <- c("V1", "V2", "V3")
combos <- tibble::as_tibble(combos)

# We want a `combos` data frame with all the
# arguments to `fit_gsp_model()`
# The `data` argument to fit_gsp_model() is a symbol,
# which could stand for a generic dataset or an upstream target.
combos$data <- rlang::syms(rep("Produc", nrow(combos)))

# Let's get some nice target names too.
combos$id <- apply(combos, 1, paste, collapse = "_")

# Now we make a drake plan: we plan to call
# fit_gsp_model() iteratively for each row in `combos`.
model_plan <- map_plan(combos, fit_gsp_model)

# Judge the models based on the root mean squared prediction error (RMSPE)
rmspe_args <- tibble::tibble(
  lm_fit = rlang::syms(model_plan$target),
  data = rlang::syms(combos$data),
  id = paste0("rmspe_", model_plan$target)
)
rmspe_plan <- map_plan(rmspe_args, get_rmspe)

# Aggregate all the results together.
rmspe_results_plan <- gather_plan(
  plan = rmspe_plan,
  target = "rmspe",
  gather = "rbind"
)

# Plan some final output.
output_plan <- drake_plan(
  plot = ggsave(filename = file_out("rmspe.pdf"), plot = plot_rmspe(rmspe)),
  report = knit(knitr_in("report.Rmd"), file_out("report.md"), quiet = TRUE)
)

# Put together the whole plan.
whole_plan <- rbind(model_plan, rmspe_plan, rmspe_results_plan, output_plan)
