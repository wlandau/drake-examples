# Perform a linear regression on whether `Sepal.Width` can be predicted by
# Species and `Petal.Width`

munged_data <- readRDS("data/munged_data.RDS")

fit <- lm(Sepal.Width ~ Petal.Width + Species, munged_data)

saveRDS(fit, "data/fit.RDS")
