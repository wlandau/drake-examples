# Execution

Run `r_make()` to execute the whole workflow.

# Introduction

This example shows how to use `drake` to perform a benchmark analysis using two algorithms (KNN, SVM) across two datasets.

The shown tuning ranges and settings of the cross-validation are scaled down for pedagogical purposes and should not be used as defaults in practice. 
They are chosen so that the example finishes within 5 minutes with the specified resources.
Runtime will differ depending on your CPU performance.

For more detailed usage instructions on `mlr` see [their online tutorial](https://mlr.mlr-org.com/).

# Loading R on the cluster

This example uses [Spack](spack.io) to load R version 3.5.3 in `slurm_clustermq.tmpl`.  
Depending on your HPC setup you might want to replace this line with `module load R` or similar and choose a different R version.
The `module load` command takes care that R is loaded on all machines of the cluster.

# Working with other schedulers

This example is tailored to work with SLURM.
If you want to use a different scheduler (SGE, PBS, LSF), you only need to use the respective template and tweak it.
`drake` uses `clustermq` under the hood for job forwarding.
Please take a look [here](https://github.com/mschubert/clustermq/wiki/Configuration#setting-up-the-scheduler) on how to set up templates for different schedulers.
Also make sure to read the section about [High-Performance-Computing](https://ropenscilabs.github.io/drake-manual/hpc.html) in the `drake` manual for further information.

# Additional resources

See chapters [Projects](https://ropenscilabs.github.io/drake-manual/projects.html) and [Batch mode](https://ropenscilabs.github.io/drake-manual/hpc.html#batch-mode-for-long-workflows) in the `drake` manual for more information on structuring your own project and dealing with long-running jobs.