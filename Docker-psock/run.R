library(drake) # Needs to be the current CRAN release.
library(future)

host_ip <- "localhost"
if (grepl("(Darwin|Windows)", Sys.info()["sysname"])) {
  host_ip <- "host.docker.internal"
}

cl <- future::makeClusterPSOCK( # nolint
  "localhost",
  ## Launch Rscript inside Docker container
  rscript = c(
    "docker", "run", "--net=host",
    "--mount",
    paste(
      "type=bind,source=",
      getwd(),
      ",target=/home/rstudio",
      sep = ""
    ),
    "rocker/verse",
    "Rscript"
  ),
  rscript_args = c(
    ## Install drake
    "-e", shQuote("install.packages('drake')"),
    
    ## Install future
    "-e", shQuote("install.packages('future')"),
    
    ## set working directory to bound dir
    "-e", shQuote("setwd('home/rstudio')")
  ),
  master = host_ip
)

future::plan(cluster, workers = cl)
load_mtcars_example(overwrite = TRUE)

# Add a code chunk in `report.Rmd` to verify that
# we are really running it in a Docker container.
write("\n```{r info}\nSys.info()\n```", "report.Rmd", append = TRUE)

make(my_plan, parallelism = "future")
