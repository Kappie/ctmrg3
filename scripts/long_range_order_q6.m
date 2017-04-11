function long_range_order_q6
  q = 6;
  % In between two kosterlitz points: correlation length should grow as power law in system size
  % temperatures = [0.75 0.8 0.85];
  temperatures = [0.8];
  % temperatures = [0.4];
  chi_values = 4:2:40;
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance, q).run();
  order_parameters = sim.compute('order_parameter');
  corr_lengths = sim.compute('correlation_length');

  % markerplot(chi_values, corr_lengths, '--', 'loglog')
  figure
  markerplot(corr_lengths', order_parameters', '--', 'loglog')
  make_legend(temperatures, 'T')

  figure
  [slope, intercept] = logfit(corr_lengths, order_parameters, 'loglog', 'skipBegin', 5)

  % [slope, intercept] = logfit(corr_lengths(1, :, :), order_parameters(1, :, :), 'loglog', 'skipBegin', 4)

  % figure
  %
  % markerplot(corr_lengths', order_parameters', '--', 'loglog')
  % [slope, intersect] = logfit(chi_values, corr_lengths(1,:), 'loglog', 'skipBegin', 10)
  % [slope, intersect] = logfit(chi_values, corr_lengths(2,:), 'loglog', 'skipBegin', 10)
  % [slope, intersect] = logfit(correlation_lengths, corr_lengths, 'loglog', 'skipBegin', 10)

end
