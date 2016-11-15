function plot_m_vs_T
  width = 0.01;
  temperatures = linspace(Constants.T_crit - width, Constants.T_crit + width, 9);
  chi_values = [16];
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance).run();
  order_params = sim.compute(OrderParameter);
  markerplot(temperatures, order_params)
end
