#' @title mlr::benchmark() wrapper
#'
#' @param learners
#' @param tasks
#' @param resampling
#' @param measures
#' @param cpus

benchmark_custom <- function(learners, tasks, resampling, measures, cpus) {

  # `mode = "multicore"` only works on Unix
  parallelStart(
    mode = "multicore", cpus = cpus, level = "mlr.resample",
    mc.set.seed = FALSE
  )
  set.seed(12345)

  bmr <- benchmark(
    learners = learners,
    tasks = tasks,
    models = ignore(FALSE),
    keep.pred = ignore(TRUE),
    resampling = resampling,
    show.info = ignore(TRUE),
    measures = measures
  )

  parallelStop()
  return(bmr)
}
