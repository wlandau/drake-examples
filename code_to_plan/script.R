# You can use an R script to create a `drake` plan.
# Here is a target and its command.

# Visit https://ropenscilabs.github.io/drake-manual/plans.html
# to learn about workflow plan data frames in drake.

data1 <- rnorm(10)

# You can use various assignment operators.

data2 <<- rnorm(20)

# Assignment operators can go either way.

mean(data1) -> summary1

median(data2) ->> summary2

# You can assign triggers, etc. in the same way you would in `drake_plan()`.
# The following target always builds during `make()`
# because of the `condition` trigger.

discrepancy <- target(
  command = summary2 - summary1,
  trigger = trigger(condition = TRUE),
  timeout = 100
)

# But each target can take only one expression as its command.
# Please enclose multiple lines in curly braces.

sum1 = {
  tmp <- 0
  for (i in 1:10){
    tmp <- tmp + data1[i]
  }
  tmp
}

{
  tmp <- 0
  for (i in 1:10){
    tmp <- tmp + data2[i]
  }
  tmp
} -> sum2
