profile <- function(plan) {
  local_dir(dir_create(tempfile()))
  config <- drake_config(
    plan,
    verbose = 0L,
    log_progress = FALSE,
    recoverable = FALSE,
    history = FALSE,
    session_info = FALSE,
    lock_envir = FALSE
  )
  rprof <- "prof.rprof"
  pprof <- "prof.pprof"
  Rprof(filename = rprof)
  print(system.time(make(config = config), gcFirst = FALSE))
  Rprof(NULL)
  data <- read_rprof(rprof)
  write_pprof(data, pprof)
  vis_pprof(pprof)
}

vis_pprof <- function(path, host = "localhost", port = NULL) {
  server <- sprintf("%s:%s", host, port %||% random_port())
  message("local pprof server: http://", server)
  system2(find_pprof(), c("-http", server, shQuote(path)))
}

random_port <- function(from = 49152L, to = 65355L) {
  sample(seq.int(from = from, to = to, by = 1L), size = 1)
}

`%||%` <- function(x, y) {
  if (is.null(x) || length(x) <= 0) {
    y
  } else {
    x
  }
}
