function plot_entropy_vs_T
  q = 2;
  width = 0.01;
  number_of_points = 10;
  temperatures = linspace(Constants.T_crit_guess(q) - width, Constants.T_crit_guess(q) + width, ...
    number_of_points);
  temperatures_right = linspace(Constants.T_crit_guess(q) - 5*width, Constants.T_crit_guess(q) - width, ...
    number_of_points);
  temperatures_left = linspace(Constants.T_crit_guess(q) + width, Constants.T_crit_guess(q) + 5*width, ...
    number_of_points);
  temperatures = [temperatures_right temperatures temperatures_left];
  temperatures = temperatures(temperatures ~= Constants.T_crit_guess(q))
  chi_values = [30];
  N_values = [500];
  tolerance = 1e-7;
  truncation_error = 1e-6;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance, q).run();
  % sim = FixedTruncationErrorSimulation(temperatures, N_values, truncation_error, q).run();


  entropy_fixed = sim.compute('entropy');
  order_param_fixed = sim.compute('order_parameter');
  free_energy_fixed = sim.compute('free_energy');

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance, q);
  % sim = FixedTruncationErrorSimulation(temperatures, N_values, truncation_error, q).run();
  sim.initial_condition = 'symmetric';
  sim = sim.run();
  entropy_free = sim.compute('entropy');
  order_param_free = sim.compute('order_parameter');
  free_energy_free = sim.compute('free_energy');


  diffs = free_energy_fixed - free_energy_free

  % markerplot(temperatures, diffs, '--')
  hold on

  % markerplot(temperatures, entropy_fixed, '--')
  % markerplot(temperatures, entropy_free, '--')
  % markerplot(temperatures, free_energy_fixed, '--')
  % markerplot(temperatures, free_energy_free, '--')
  markerplot(temperatures, order_param_fixed, '--')
  markerplot(temperatures, order_param_free, '--')
  hold off
  % legend({'fixed', 'free'})
  xlabel('$T$')
  % ylabel('$S(T, \chi)$')
  % ylabel('$f_{\mathrm{fixed}} - f_{\mathrm{free}}$')
  % title('Competition of phases in Ising model for $N = 500$.')
  % make_legend(chi_values, '\chi')
  % hline(0, '--')
end
