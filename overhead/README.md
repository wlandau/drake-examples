This is a profiling study of `drake`. In order to isolate and measure overhead, the example `drake` project has many targets and minimal work within each target.

## Main profiling workflow

Run `Rscript run.R` to profile [`drake`](https://github.com/ropensci/drake) and visualize the profiling results in a local interactive web server.

## Files

- `run.R`: Run the profiling study and generate `*.proto` files for [`pprof`](https://github.com/google/pprof).
- `makefile.R`: Benchmark GNU Make on a similar workflow. This would be the performance of `drake` in an ideal world.

## Dependencies

- [`drake`](https://github.com/ropensci/drake)
- [`jointprof`](https://github.com/r-prof/jointprof) and [its dependencies](https://r-prof.github.io/jointprof/#installation), including [Go](https://golang.org)), [`pprof`](https://github.com/google/pprof), and [`gperftools`](https://github.com/gperftools/gperftools).
- [`profile`](https://github.com/r-prof/profile).
- [`RProtoBuf`](https://github.com/eddelBuettel/RProtoBuf) and [its dependencies](https://github.com/eddelBuettel/RProtoBuf#installation).
