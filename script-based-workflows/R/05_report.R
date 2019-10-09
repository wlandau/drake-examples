# Generate the RMD report from report.RMD

rmarkdown::render(
  "report.Rmd",
  output_file = "report.html",
  quiet = TRUE
)
