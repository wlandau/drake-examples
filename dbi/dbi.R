
library(DBI)
library(RSQLite)

fetch_cache <- drake_strings({
  mydb <- DBI::dbConnect(RSQLite::SQLite(), "my-db.sqlite")
  cache <- storr::storr_dbi(
    "dattbl", "keystbl", con = mydb, hash_algorithm = "murmur32")
  configure_cache(
    cache = cache,
    long_hash_algo = "sha1",
    overwrite_hash_algos = TRUE
  )
})

cache <- eval(parse(text = fetch_cache))
cache2 <- this_cache(fetch_cache = fetch_cache)

scenario <- get_testing_scenario()
e <- eval(parse(text = scenario$envir))
e$mydb <- mydb

# Parallelism currently does not work here.
# I need to debug.
parallelism <- "mclapply"
jobs <- 1
# parallelism <- scenario$parallelism # nolint
# jobs <- scenario$jobs # nolint

load_mtcars_example(envir = e)
con <- drake_config(e$my_plan, envir = e)
con$cache$destroy()

# Need to fix richfitz/storr#60 before using the full workflow plan.
e$my_plan <- e$my_plan[e$my_plan$target != "'report.md'", ]

my_plan <- e$my_plan
config <- drake_config(
  my_plan, envir = e,
  jobs = jobs,
  parallelism = parallelism,
  cache = cache,
  fetch_cache = fetch_cache
)
testrun(config)

sort(built(cache = cache))

# Clean up
cache$driver$disconnect()
cache2$driver$disconnect()
