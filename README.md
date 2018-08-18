[![travis](https://travis-ci.org/wlandau/drake-examples.svg?branch=master)](https://travis-ci.org/wlandau/drake-examples)

# `drake` examples

This repository is part of a community effort to collect, curate, and share publicly available examples of data analysis projects powered by the  [`drake` R package](https://github.com/ropensci/drake). Each folder is its own example with a self-sufficient set of code and data files. Eventually, you will be able to download individual examples using [`drake`](https://github.com/ropensci/drake) itself.

```r
# Install and load drake.
devtools::install_github("ropensci/drake")
library(drake)
# List the available examples.
drake_examples()
#> [1] "Docker-psock"     "gsp"              "lfs"              "main"            
#> [5] "Makefile-cluster" "mtcars"           "packages"         "sge"             
#> [9] "slurm"            "torque"     
# Get an example.
drake_example("main")
list.files()
#> [1] "main"
```

# Contributing

Please read the top-level [`CONTRIBUTING.md`](https://github.com/wlandau/drake-examples/blob/master/CONTRIBUTING.md) and [`CONDUCT.md`](https://github.com/wlandau/drake-examples/blob/master/CONDUCT.md) for rules and instructions.

# Introductory examples

- `main`: `drake`'s main example, based on [Kirill Müller's `drake` pitch](https://krlmlr.github.io/drake-pitch/). This is the most accessible example for beginners.
- `gsp`: A concrete example using real econometrics data. It explores the relationships between gross state product and other quantities, and it shows off `drake`'s ability to generate lots of reproducibly-tracked tasks with ease.
- `packages`: A concrete example using data on R package downloads. It demonstrates how `drake` can refresh a project based on new incoming data without restarting everything from scratch.
- `mtcars`: An old example that demonstrates how to generate large workflow plan data frames using wildcard templating. Use `load_mtcars_example()` to set up the project in your workspace.

# High-performance computing examples

- `Docker-psock`: demonstrates how to deploy targets to a [Docker container](https://www.docker.com/what-container) using a specialized PSOCK cluster.
- `Makefile-cluster`: uses [Makefiles](https://www.gnu.org/software/make/) to deploy targets to a generic cluster (configurable).
- `sge`: uses `drake`'s high-performance computing functionality to send work to a [Grid Engine](http://www.univa.com/products/) cluster.
- `slurm`: similar to `sge`, but for [SLURM](https://slurm.schedmd.com).
- `torque`: similar to `sge`, but for [TORQUE](http://www.adaptivecomputing.com/products/open-source/torque/).

# Development examples

- `overhead`: an example explicitly designed to maximize strain on `drake`'s internals. The purpose is to support profiling studies to speed up `drake`.

# Demonstrations of specific features

- `code_to_plan`: a demonstration of `drake`'s `code_to_plan()` function, which can turn ordinary quoted code, R scripts, and `knitr` / R Markdown reports into `drake` [workflow plan data frames](https://ropenscilabs.github.io/drake-manual/plans.html).
