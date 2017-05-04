function plot_order_param
  q = 2;
  width = 0.02; number_of_points = 20;
  % temperatures = linspace(Constants.T_crit_guess(q) - width, Constants.T_crit_guess(q) + width, ...
  %   number_of_points);
  temperature = Constants.T_crit_guess(q);
  chi_values = 8:2:70;
  tolerance = 1e-9;
  skipBegin = 4;
  skipEnd = 0;

  sim = FixedToleranceSimulation(temperature, chi_values, tolerance, q).run();
  order_params = sim.compute('order_parameter');
  free_energies = sim.compute('free_energy');
  corr_lengths = sim.compute('correlation_length');
  entropies = sim.compute('entropy')
  diffs = free_energies - Constants.free_energy_per_site(temperature);

  % [slope, intercept] = logfit(chi_values, entropies, 'logx', 'skipBegin', skipBegin, ...
  % 'skipEnd', skipEnd)
  % [slope, intercept] = logfit(chi_values, order_params, 'loglog', 'skipBegin', skipBegin, ...
  % 'skipEnd', skipEnd)
  % [slope, intercept] = logfit(chi_values, diffs, 'loglog', 'skipBegin', skipBegin, ...
  % 'skipEnd', skipEnd)
  % [slope, intercept] = logfit(chi_values, corr_lengths, 'loglog', 'skipBegin', skipBegin, ...
  % title(num2str(tolerance))
  [slope, intercept] = logfit(corr_lengths, entropies, 'logx', 'skipBegin', skipBegin, ...
  'skipEnd', skipEnd)
  % title(num2str(tolerance))
  % kappa = -8*slope
  % kappa = slope * (6 / 0.5)
  % kappa = -0.5*slope
  central_charge = 6 * slope


end
