plan <- drake_plan(
  model = target(
    "stan/model.stan",
    format = "file",
    hpc = FALSE
  ),
  compiled = target(
    compile_model(model),
    format = "file",
    hpc = FALSE
  ),
  index = target(
    seq_len(10), # Change the number of simulations here.
    hpc = FALSE
  ),
  data = target(
    simulate_data(),
    dynamic = map(index),
    format = "fst_tbl"
  ),
  fit = target(
    fit_model(compiled, data),
    dynamic = map(data),
    format = "fst_tbl"
  ),
  report = target(
    render(
      knitr_in("report.Rmd"),
      output_file = file_out("report.html"),
      quiet = TRUE
    ),
    hpc = FALSE
  )
)