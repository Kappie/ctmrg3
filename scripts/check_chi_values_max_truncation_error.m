function check_chi_values_max_truncation_error
  max_truncation_error = 1e-5;
  q = 2;
  temperature = Constants.T_crit;
  N_values = [200 1000 2200 8000];

  sim = FixedTruncationErrorSimulation(temperature, N_values, max_truncation_error, q).run()

end
