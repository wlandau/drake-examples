This is a profiling study of `drake`. The goal is to assess speed (and possibly memory) for a small number of medium-ish-sized targets.

## Main profiling workflow

Run `Rscript run.R` to profile [`drake`](https://github.com/ropensci/drake) and visualize the profiling results in a local interactive web server.

## Files

- `run.R`: Run the profiling study and generate `*.proto` files for [`pprof`](https://github.com/google/pprof).

## Dependencies

- [`drake`](https://github.com/ropensci/drake) version > 7.5.2.
- [`fst`](https://github.com/fstpackage/fst)
- [`jointprof`](https://github.com/r-prof/jointprof) and [its dependencies](https://r-prof.github.io/jointprof/#installation), including [Go](https://golang.org)), [`pprof`](https://github.com/google/pprof), and [`gperftools`](https://github.com/gperftools/gperftools).
- [`profile`](https://github.com/r-prof/profile).
- [`RProtoBuf`](https://github.com/eddelBuettel/RProtoBuf) and [its dependencies](https://github.com/eddelBuettel/RProtoBuf#installation).
