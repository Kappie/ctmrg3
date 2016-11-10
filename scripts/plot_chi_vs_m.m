function plot_chi_vs_m
  temperatures = [Constants.T_crit];
  chi_values = [4 6 8 10 12];
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance).run();
  order_parameters = sim.compute(OrderParameter)

  beta = 1/8; nu = 1;
  markerplot(chi_values, order_parameters.^(-nu/beta), '--', 'loglog')
  % make_legend(N_values, 'N')
  % xlabel('$\chi^{-\frac{\kappa \beta}{\nu}}$')
  % ylabel('$|m|$')
end
