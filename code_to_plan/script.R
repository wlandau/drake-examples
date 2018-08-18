# You can use an R script to create a `drake` plan.
# Here is a target and its command.

# Visit https://ropenscilabs.github.io/drake-manual/plans.html
# to learn about workflow plan data frames in drake.

t <- rnorm(10)

# You can use various assignment operators.

u <<- rnorm(10)

# Assignment operators can go either way.

rnorm(10) -> v

rnorm(10) ->> w

# You can assign triggers, etc. in the same way you would in `drake_plan()`.

x <- target(
  command = c((sqrt(5) + 1) / 2, (sqrt(5) - 1) / 2),
  trigger = trigger(condition = TRUE),
  timeout = 100
)

# But each target can take only one expression as its command.
# Please enclose multiple lines in curly braces.

y = {
  tmp <- 0
  for (i in 1:10){
    tmp <- tmp + w + x
  }
  tmp
}

{
  tmp <- 0
  for (i in 1:10){
    tmp <- tmp + x + y
  }
  tmp
} -> z
