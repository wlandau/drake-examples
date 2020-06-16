profile <- function(plan) {
  local_dir(dir_create(tempfile()))
  pprof(
    system.time(
      make(
        plan,
        verbose = 0L,
        log_progress = FALSE,
        recoverable = FALSE,
        history = FALSE,
        session_info = FALSE,
        lock_envir = FALSE,
        log_build_times = FALSE
      ),
      gcFirst = FALSE
    )
  )
}
