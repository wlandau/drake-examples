data {
  int <lower = 1> n;
  vector[n] x;
  vector[n] y;
}
parameters {
  real alpha;
  real beta;
  real <lower = 0> sigma;
}
model {
  for (i in 1:n) {
    y[i] ~ normal(alpha + x[i] * beta, sigma);
  }
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
  sigma ~ uniform(0, 1);
}
