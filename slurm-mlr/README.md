# Disclaimer

This example shows how to use `drake` to perform a benchmark analysis using two algorithms (KNN, SVM) across two datasets.

The shown tuning ranges and settings of the cross-validation are not meant to make sense. 
They are chosen so that the example finishes within 5 minutes with the specified resources.
Runtime will differ depending on how your CPUs are.

For more detailed instructions on how to use `mlr` see https://mlr.mlr-org.com/.

# R interpreter

This example uses [Spack](spack.io) to load R version 3.5.3 in `slurm_clustermq.tmpl`.
Depending on your HPC setup you might want to replace this line with `module load R` or similar.
This command is responsible for loading R on the workers.