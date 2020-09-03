// From https://mc-stan.org/users/documentation/case-studies/boarding_school_case_study.html
functions {
  vector sir(real t, vector y, real beta, real gamma, int N) {

      real S = y[1];
      real I = y[2];
      real R = y[3];
      
      vector[3] dydt;
      
      dydt[1] = -beta * I * S / N;
      dydt[2] =  beta * I * S / N - gamma * I;
      dydt[3]  =  gamma * I;
      
      return dydt;
  }
}

data {
  int<lower=1> n_days;
  vector[3] y0;
  real t0;
  real ts[n_days];
  int N;
  int cases[n_days-1];
}
parameters {
  real<lower=0> gamma;
  real<lower=0> beta;
  real<lower=0> phi_inv;
  
}
transformed parameters{
  real<lower=0> phi = 1. / phi_inv;
  real incidence[n_days-1];
  
   //S(t) - S(t + 1)
  //incidence[1] = cases[1];
   vector<lower=0>[3] y[n_days];

   y = ode_rk45(sir, y0, t0, ts, beta, gamma, N);

  
  //for (i in 2:(n_days-1)) {
   for (i in 1:(n_days-1))
  	incidence[i] = y[i, 1] - y[i + 1, 1];
  
}
model {
  //priors
  beta ~ normal(2, 1);
  gamma ~ normal(0.4, 0.5);
  phi_inv ~ exponential(5);
  
  
  //sampling distribution
  cases ~ neg_binomial_2(incidence, phi);
  
}
generated quantities {
  real R0 = beta / gamma;
  real recovery_time = 1 / gamma;
  real pred_cases[n_days-1];
  
  pred_cases = neg_binomial_2_rng(incidence, phi);
  
}

