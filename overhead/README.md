This is a profiling study of `drake`. In order to isolate and measure overhead, the example `drake` project has many targets and minimal work within each target.

## Main profiling workflow

Generate the benchmarks and then see interactive visuals with `pprof`. The flame graph is particularly useful.

```r
Rscript run.R
pprof -http=0.0.0.0:8080 make_rprof_4096_64.proto
pprof -http=0.0.0.0:8080 config_rprof_4096_64.proto
```

## Files

- `run.R`: Run the profiling study and generate `*.proto` files for [`pprof`](https://github.com/google/pprof).
- `makefile.R`: Benchmark GNU Make on a similar workflow. This would be the performance of `drake` in an ideal world.

## Dependencies

- R packages in the `library()` calls in `run.R`.
- [`pprof`](https://github.com/google/pprof) (requires [Go](https://golang.org)).
- [`RProtoBuf`](https://github.com/eddelBuettel/RProtoBuf) and its dependencies.
