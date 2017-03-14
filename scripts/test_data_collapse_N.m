function test_data_collapse_N
  q = 4;
  truncation_error = 1e-5;
  % N_values = [20 80 160 320 480 600 1000 1500];
  N_values = [20 60 100 140 180];
  width = 0.1; number_of_points = 10;
  temperatures = linspace(Constants.T_crit_guess(q) - width, ...
    Constants.T_crit_guess(q) + width, number_of_points);
  temperatures_zoom = linspace(Constants.T_crit_guess(q) - width/10, ...
    Constants.T_crit_guess(q) + width/10, number_of_points);
  temperatures_super_zoom = linspace(Constants.T_crit_guess(q) - width/100, ...
    Constants.T_crit_guess(q) + width/100, 5);

  collapse = DataCollapseN(q, N_values, temperatures, truncation_error)
  collapse = collapse.find_best_collapse();
  % collapse.truncation_errors
  collapse.results
  collapse.simulation.chi_values
  collapse.simulation.truncation_errors
  collapse.plot()
  collapse.plot(Constants.T_crit_guess(q), 0.125, 1);
end
