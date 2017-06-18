function plot_quantities_vs_truncation_error
  q = 2;
  temperature = Constants.T_crit_guess(q);
  N_values = [100 1000 2000];
  max_truncation_errors = [1e-3 1e-4 1e-5 1e-6];

end
