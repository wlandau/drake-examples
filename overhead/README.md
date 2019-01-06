This is a profiling study of `drake`. In order to isolate and measure overhead, the example `drake` project has many targets and minimal work within each target.

## Files

- `run.R`: Run the profiling study and generate `*.proto` files for [`pprof`](https://github.com/google/pprof).
- `graph.sh`: Use [`pprof`](https://github.com/google/pprof) to create pdf graph visualizations of the profiling results.
- `makefile.R`: Benchmark GNU Make on a similar workflow. This would be the performance of `drake` in an ideal world.

## Dependencies

- R packages in the `library()` calls in `run.R`.
- [`pprof`](https://github.com/google/pprof) (requires [Go](https://golang.org)).
- [`RProtoBuf`](https://github.com/eddelBuettel/RProtoBuf) and its dependencies.
