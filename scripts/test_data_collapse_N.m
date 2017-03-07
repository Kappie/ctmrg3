function test_data_collapse_N
  q = 2;
  N_values = [40 80 160 320 1000];
  width = 0.1; number_of_points = 10;
  temperatures = linspace(Constants.T_crit - width, Constants.T_crit + width, number_of_points);

  collapse = DataCollapseN(q, N_values, temperatures)
  collapse = collapse.find_best_collapse();
  collapse.results
  collapse.plot
end
