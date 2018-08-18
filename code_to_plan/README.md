This example demonstrates `drake`'s `code_to_plan()` function, which can turn an R script or `knitr` / R Markdown report into a [workflow plan data frame](https://ropenscilabs.github.io/drake-manual/plans.html). In your script or `knitr` / R Markdown code chunks, you can assign expressions to variables, and `code_to_plan()` will turn them into commands and targets, respectively. The `make.R` script demonstrates how this works for the script `script.R` and the report `report.Rmd`.

This feature is easy to break, so there are some rules:

1. Stick to ssigning a single expression to a single target at a time. For multi-line commands, please enclose the whole command in curly braces. Conversely, compound assignment is not supported (e.g. `target_1 <- target_2 <- target_3 <- get_data()`).
2. Once you assign an expression to a variable, do not modify the variable any more. The target/command [binding](https://cs.stackexchange.com/questions/39525/what-is-the-difference-between-assignment-valuation-and-name-binding) should be permanent.
3. Keep it simple. Please use the assignment operators rather than `assign()` and similar functions.
