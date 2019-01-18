# This script is just a sketch of how one might
# scale up the gapminder workflow to many targets.
# Accompanies https://wlandau.github.io/drake-datafest-2019/#/scale-up-to-many-targets-1

library(drake)

# Experimental interface for scaling up to a large
# number of targets. Much more convenient than existing wildcard
# functions such as evaluate_plan() and others like map_plan()
# and gather_by(). Coming to version 7.0.0.
plan <- drake_plan(
  data = target(
    get_data("data_name"),
    transform = cross(data_name = c(oecd, unesco, world_bank))
  ),
  analysis = target(
    fit_large_model(data, "covariate", "priors"),
    transform = cross(
      data,
      covariate = c(log_pop, life_exp, literacy),
      priors = c(normal, t, dirichlet_process)
    )
  ),
  winner = target(
    get_winner(analysis),
    transform = summarize(data, priors)
  )
)

config <- drake_config(plan)
vis_drake_graph(config)
