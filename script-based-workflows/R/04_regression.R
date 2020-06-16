# Perform a linear regression to model ozone concentration as a function
# of wind and temperature in R's built-in `airquality` dataset.

munged_data <- readRDS("data/munged_data.RDS")

fit <- lm(Ozone ~ Wind + Temp, munged_data)

saveRDS(fit, "data/fit.RDS")
