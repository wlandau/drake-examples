plan <- drake_plan(
  dataset = prepare_gapminder(gapminder::gapminder),
  report = render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  ),
  life_exp = fit_model(covariate = "life_exp", dataset = dataset),
  log_pop = fit_model(covariate = "log_pop", dataset = dataset),
  plots = gather_plots(life_exp = life_exp, log_pop = log_pop)
)
