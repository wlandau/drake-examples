# List of learning tasks
tasks <- list(mtcars.task, sonar.task)

# Tune wrapper for SVM
ps_svm <- makeParamSet(
  makeNumericParam("C",
    lower = -5, upper = 12,
    trafo = function(x) 2^x
  ),
  makeNumericParam("sigma",
    lower = -12, upper = 3,
    trafo = function(x) 2^x
  )
)

ctrl_svm <- makeTuneControlRandom(maxit = 100)
inner_svm <- makeResampleDesc("CV", iters = 5)
svm_wrapper <- makeTuneWrapper("classif.ksvm",
  resampling = inner_svm,
  par.set = ps_svm, control = ctrl_svm,
  show.info = TRUE
)

# Tune wrapper for KNN
ps_knn <- makeParamSet(
  makeIntegerParam("k", lower = 10, upper = 50),
  makeIntegerParam("distance", lower = 1, upper = 50)
)
ctrl_knn <- makeTuneControlRandom(maxit = 100)
inner_knn <- makeResampleDesc("CV", iters = 5)
knn_wrapper <- makeTuneWrapper("classif.kknn",
  resampling = inner_knn,
  par.set = ps_knn, control = ctrl_knn,
  show.info = TRUE
)

# Outer resampling config 
outer <- makeResampleDesc("RepCV", reps = 10, folds = 5)

# Benchmark learners and store result in separate objects
res_svm <- benchmark_custom(
  learners = svm_wrapper, tasks = tasks, resampling = outer,
  measures = list(acc, ber), cpus = 17
)

res_knn <- benchmark_custom(
  learners = knn_wrapper, tasks = tasks, resampling = outer,
  measures = list(acc, ber), cpus = 17
)