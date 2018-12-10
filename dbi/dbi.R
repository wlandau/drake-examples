library(drake)
library(DBI)
library(RSQLite)

load_mtcars_example()

# Set up the database cache.
mydb <- DBI::dbConnect(RSQLite::SQLite(), "my-db.sqlite")
cache <- storr::storr_dbi("dattbl", "keystbl", mydb)

# Make your targets normally.
make(plan = my_plan, cache = cache)

# Read from the cache.
loadd(small, cache = cache)
head(small)

# Remove the targets.
cached(cache = cache)
clean(cache = cache)
cached(cache = cache)

# Get ready for parallel execution
# powered by the `future` package
future::plan(future::multiprocess)

# Make the targets in parallel
# Below, `caching = "master"` ensures
# that only one process writes to the cache at a time.
# This is key for non-default non-`storr_rds()` caches.
make(
  plan = my_plan,
  cache = cache,
  parallelism = "future",
  jobs = 2,
  caching = "master" # Important for DBI caches!
)

# Disconnect from the cache.
cache$driver$disconnect()
