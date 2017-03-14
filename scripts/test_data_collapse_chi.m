function test_data_collapse_chi
  chi_values = [4 10 16 24 32 40 50];
  % chi_values = [4, 8];
  q = 4;
  tolerance = 1e-7;
  width = 0.1; number_of_points = 10;
  RIGHT_BOUND = 1.13515;
  temperatures = linspace(Constants.T_crit_guess(q) - width, ...
    RIGHT_BOUND, number_of_points);
  temperatures_zoom = linspace(Constants.T_crit_guess(q) - width/10, ...
    RIGHT_BOUND, number_of_points);
  temperatures_super_zoom = linspace(Constants.T_crit_guess(q) - width/100, ...
    RIGHT_BOUND, floor(number_of_points/2));
  temperatures = [temperatures temperatures_zoom temperatures_super_zoom]

  collapse = DataCollapseChi(q, chi_values, temperatures, tolerance);
  collapse.scaling_quantities
  collapse = collapse.find_best_collapse();
  collapse.results
  collapse.plot
  collapse.plot(Constants.T_crit_guess(q), 1/8, 1)

end
