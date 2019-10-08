This is the example on how to use the `code_to_function()` tool that is 
implemented in `drake` version 7.6.2.9000. This function allows for 
script-based workflows. Original example was written by 
[Kirill Müller](https://github.com/krlmlr), and adapted by
[Ellis Hughes](https://github.com/thebioengineer) to demonstrate script
based workflows.

Most data science workflows consist of imperative scripts that are numbered in
their order of execution and have a naive make script that executes every single
script when it is run without regard to updates. `drake` overcomes this problem
of repeated work, however `drake` assumes you write *functions* as opposed to
scripts. This example is the suggested use of `code_to_function()` for 
integrationm of `drake` into pre-existing script-based workflows.

`code_to_function()`is a quick and dirty way to retrofit `drake` to 
an existing script-based project. _This approach should only be taken when
re-factoring the workflow into functions is deterimined to be unfeasible._
