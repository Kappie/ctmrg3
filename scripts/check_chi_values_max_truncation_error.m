function check_chi_values_max_truncation_error
  max_truncation_error = 1e-7;
  q = 2;
  temperature = Constants.T_crit;
  N_values = [1000 2000 8000];

  sim = FixedTruncationErrorSimulation(temperature, N_values, max_truncation_error, q).run()

end
