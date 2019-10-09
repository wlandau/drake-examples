# The workflow plan data frame outlines what you are going to do.

my_plan <- drake_plan(
  raw_data    = load_data(),
  munged_data = do_munge(raw_data),
  hist        = do_histogram(munged_data),
  fit         = do_regression(munged_data),
  report      = generate_report(hist, fit)
)
