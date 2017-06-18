function plot_convergence_vs_truncation_error
  q = 2;
  temperature = Constants.T_crit;
  chi_values = [10];
  tolerances = [1e-5 1e-6 1e-7 1e-8 1e-9];

  sim = FixedToleranceSimulation(temperature, chi_values, tolerances, q).run();
  order_parameters = sim.compute('order_parameter');
  truncation_error_structs = sim.compute('truncation_error');
  truncation_errors = arrayfun(@(s) s.truncation_error, truncation_error_structs)

  markerplot(truncation_errors, order_parameters, '--', 'semilogx')
end
