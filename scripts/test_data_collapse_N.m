function test_data_collapse_N
  q = 2;
  N_values = [160 320 1000];
  width = 0.1; number_of_points = 50;
  temperatures = linspace(Constants.T_crit - width, Constants.T_crit + width, number_of_points);

  collapse = DataCollapseN(q, N_values, temperatures)
  collapse.truncation_errors
  collapse = collapse.find_best_collapse();
  collapse.results
  collapse.plot(Constants.T_crit, 0.125, 1);
  collapse.plot()
end
