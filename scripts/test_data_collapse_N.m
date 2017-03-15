function test_data_collapse_N
  q = 2;
  truncation_error = 1e-6;
  N_values = [20 80 160 320 480 600 800 1000 1500 2000 2500];
  % N_values = [20 60 100 140 180];
  width = 0.1; number_of_points = 20;
  temperatures = linspace(Constants.T_crit_guess(q) - width, ...
    Constants.T_crit_guess(q) + width, number_of_points);
  temperatures_zoom = linspace(Constants.T_crit_guess(q) - width/10, ...
    Constants.T_crit_guess(q) + width/10, number_of_points);
  temperatures_super_zoom = linspace(Constants.T_crit_guess(q) - width/100, ...
    Constants.T_crit_guess(q) + width/100, number_of_points);

  temperatures = [temperatures temperatures_zoom temperatures_super_zoom]

  collapse = DataCollapseN(q, N_values, temperatures, truncation_error)
  N_min = 320;
  fit_width = width / 10;

  initial = [Constants.T_crit_guess(q), 0.125, 1];
  lower_bounds = [2.269 0.12 0.997];
  upper_bounds = [2.2692 0.13 1.006];
  collapse = collapse.find_best_collapse(N_min, fit_width, initial, lower_bounds, upper_bounds);
  % collapse.truncation_errors
  collapse.results
  collapse.simulation.chi_values
  collapse.plot()
end
