function plot_order_param
  q = 2;
  width = 0.02; number_of_points = 20;
  temperatures = linspace(Constants.T_crit_guess(q) - width, Constants.T_crit_guess(q) + width, ...
    number_of_points);
  N_values = [40 100 400 1000];
  chi_values = [2 4 6 8];
  max_truncation_error = 1e-6;
  tolerance = 1e-7;

  sim_chi = FixedToleranceSimulation(temperatures, chi_values, tolerance, q).run();
  sim_N = FixedTruncationErrorSimulation(temperatures, N_values, max_truncation_error, q).run();

  % figure
  % markerplot(temperatures, sim_chi.compute('order_parameter'), '--')
  % vline(Constants.T_crit_guess(q), '--')
  % make_legend(chi_values, '\chi')
  figure
  markerplot(temperatures, sim_N.compute('order_parameter'), '--')
  vline(Constants.T_crit_guess(q), '--')
  make_legend(N_values, 'N')
end
