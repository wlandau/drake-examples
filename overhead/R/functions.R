profile <- function(plan) {
  local_dir(dir_create(tempfile()))
  config <- drake_config(
    plan,
    verbose = 0L,
    log_progress = FALSE,
    recoverable = FALSE,
    history = FALSE,
    session_info = FALSE,
    lock_envir = FALSE,
    log_build_times = FALSE
  )
  pprof(system.time(make(config = config), gcFirst = FALSE))
}
