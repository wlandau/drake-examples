With `drake`'s functions `code_to_plan()`, `plan_to_code()`, and `plan_to_notebook()`, you can convert among `drake` plans, traditional R scripts, and R notebooks.

`code_to_plan()` is easy to break, so there are some rules:

1. Stick to ssigning a single expression to a single target at a time. For multi-line commands, please enclose the whole command in curly braces. Conversely, compound assignment is not supported (e.g. `target_1 <- target_2 <- target_3 <- get_data()`).
2. Once you assign an expression to a variable, do not modify the variable any more. The target/command [binding](https://cs.stackexchange.com/questions/39525/what-is-the-difference-between-assignment-valuation-and-name-binding) should be permanent.
3. Keep it simple. Please use the assignment operators rather than `assign()` and similar functions.


