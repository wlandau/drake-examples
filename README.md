[![Launch Rstudio Binder](http://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/wlandau/drake-examples/master?urlpath=rstudio)

# `drake` examples

This repository is part of a community effort to collect, curate, and share publicly available examples of data analysis projects powered by the  [`drake` R package](https://github.com/ropensci/drake). Each folder is its own example with a self-sufficient set of code and data files.

# Run in a browser

Click this badge to open the examples in RStudio through your browser: [![Launch Rstudio Binder](http://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/wlandau/drake-examples/master?urlpath=rstudio)


# Run locally

You can download example files and run them locally with [`drake`](https://github.com/ropensci/drake) itself.

```r
# Install and load drake.
devtools::install_github("ropensci/drake")
library(drake)
# List the available examples.
drake_examples()
# Get an example
drake_example("main")
list.files() # See the new 'main' folder
```

# Contributing

Please read the top-level [`CONTRIBUTING.md`](https://github.com/wlandau/drake-examples/blob/master/CONTRIBUTING.md) and [`CONDUCT.md`](https://github.com/wlandau/drake-examples/blob/master/CONDUCT.md) for rules and instructions.

# Introductory examples

- `customer-churn`: based on an [RStudio Solutions Engineering example of how to use Keras with R](https://github.com/sol-eng/tensorflow-w-r). The motivation comes from a [blog post by Matt Dancho](https://blogs.rstudio.com/tensorflow/posts/2018-01-11-keras-customer-churn), and the code is based on a [notebook by Edgar Ruiz](https://github.com/sol-eng/tensorflow-w-r/blob/master/workflow/tensorflow-drake.Rmd).
- `stan`: validating a small Bayesian hierarchical model with [`rstan`](https://mc-stan.org/users/interfaces/rstan).
- `main`: `drake`'s main bare-bones introductory example, originally written by [Kirill Müller](https://github.com/krlmlr) and modified by [Will Landau](https://github.com/wlandau). Now based on R's built-in `airquality` dataset.
- `gsp`: A concrete example using real econometrics data. It explores the relationships between gross state product and other quantities, and it shows off `drake`'s ability to generate lots of reproducibly-tracked tasks with ease.
- `packages`: A concrete example using data on R package downloads. It demonstrates how `drake` can refresh a project based on new incoming data without restarting everything from scratch.
- `mtcars`: An old legacy example with the `mtcars` dataset. Use `load_mtcars_example()` to set up the project in your workspace.

# High-performance computing examples

- `mlr-slurm`: an example machine learning workflow rigged to deploy to a [SLURM](https://slurm.schedmd.com) cluster.
- `Docker-psock`: demonstrates how to deploy targets to a [Docker container](https://www.docker.com/what-container) using a specialized PSOCK cluster.
- `sge`: uses `drake`'s high-performance computing functionality to send work to a [Grid Engine](http://www.univa.com/products/) cluster.
- `slurm`: similar to `sge`, but for [SLURM](https://slurm.schedmd.com).
- `torque`: similar to `sge`, but for [TORQUE](http://www.adaptivecomputing.com/products/open-source/torque/).

# Example for developing `drake`

- `hpc-profiling`: an example with a small number of medium-ish-sized datasets. The goal is to assess how long it takes (relatively speaking) to shuffle data around hpc workers.
- `overhead`: an example explicitly designed to maximize strain on `drake`'s internals. The purpose is to support profiling studies to speed up `drake`.

# Demonstrations of specific features

- `script-based-workflows`: demonstrates how to adapt `drake` to an imperative script-based project.
- `code_to_plan`: questioning. Refer to `script-based-workflows` instead.

# Real-world examples outside this repo

The official [rOpenSci use cases](https://ropensci.org/usecases/) and [associated discussion threads](https://discuss.ropensci.org/c/usecases) describe applications of `drake` in action. Here are some more real-world sightings of `drake` in the wild.

- [efcaguab/demografia-del-voto](https://github.com/efcaguab/demografia-del-voto)
- [efcaguab/great-white-shark-nsw](https://github.com/efcaguab/great-white-shark-nsw)
- [IndianaCHE/Detailed-SSP-Reports](https://github.com/IndianaCHE/Detailed-SSP-Reports)
- [joelnitta/pleurosoriopsis]( https://github.com/joelnitta/pleurosoriopsis)
- [pat-s/pathogen-modeling](https://github.com/pat-s/pathogen-modeling)
- [sol-eng/tensorflow-w-r](https://github.com/sol-eng/tensorflow-w-r)
- [tiernanmartin/home-and-hope](https://github.com/tiernanmartin/home-and-hope)
