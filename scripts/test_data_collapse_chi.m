function test_data_collapse_chi
  width = 0.1; number_of_points = 30;
  temperatures = linspace(Constants.T_crit - width, Constants.T_crit + width, number_of_points);
  chi_values = [4 8 12 16 24 32 40 50];
  q = 2;
  tolerance = 1e-7;

  collapse = DataCollapseChi(q, chi_values, temperatures, tolerance);
  collapse.scaling_quantities
  collapse = collapse.find_best_collapse();
  collapse.results
  % collapse.plot
  % collapse.plot(Constants.T_crit, 1/8, 1)

end
