function tolerance_vs_order_param
  q = 2;
  chi_values = [20 40 70];
  temperature = Constants.T_crit_guess(q);
  tolerances = [1e-6 1e-7 1e-8 1e-9];

  sim = FixedToleranceSimulation(temperature, chi_values, tolerances, q).run();
  order_params = sim.compute('order_parameter');
  diffs = order_params - order_params(:, end)

  markerplot(tolerances, diffs, '--', 'loglog')
  make_legend(chi_values, '\chi')
end
