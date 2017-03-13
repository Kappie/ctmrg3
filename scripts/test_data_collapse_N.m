function test_data_collapse_N
  q = 2;
  truncation_error = 1e-6;
  N_values = [20 80 160 320 480 600 1000 1500];
  % N_values = [80 250];
  width = 0.1; number_of_points = 30;
  temperatures = linspace(Constants.T_crit - width, Constants.T_crit + width, number_of_points);

  collapse = DataCollapseN(q, N_values, temperatures, truncation_error)
  collapse = collapse.find_best_collapse();
  % collapse.truncation_errors
  collapse.results
  collapse.simulation.chi_values
  collapse.simulation.truncation_errors
  % collapse.plot()
  % collapse.plot(Constants.T_crit, 0.125, 1);
end
