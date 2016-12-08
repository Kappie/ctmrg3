function plot_ms_vs_tolerance
  temperatures = [Constants.T_crit];
  tolerances = [1e-4, 1e-5, 1e-6, 1e-7, 1e-8, 1e-9, 1e-10, 1e-11, 1e-12];
  chi_values = [6, 10, 16, 24];

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run();
  order_params = sim.compute(OrderParameter);
  size(order_params)
  diffs = circshift(order_params, [0 -1]) - order_params;
  diffs = diffs(:, 1:end-1);

  markerplot(tolerances, order_params, '--', 'semilogx')
  xlabel('tolerance')
  ylabel('$m(\mathrm{tolerance}) - m(10 \cdot \mathrm{tolerance})$')
  make_legend(chi_values, '\chi')

end
