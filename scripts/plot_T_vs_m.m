function plot_T_vs_m
  q = 4;
  chi_values = [10];
  tolerance = 1e-7;
  T_crit_guess = 1.13; width = 0.1; number_of_points = 5;
  temperatures = linspace(T_crit_guess - width, T_crit_guess + width, number_of_points);

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance, q).run();
  order_params = sim.compute('order_parameter')

  markerplot(temperatures, order_params, '--')
end
