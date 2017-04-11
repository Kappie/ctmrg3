function long_range_order_q6
  q = 6;
  % In between two kosterlitz points: correlation length should grow as power law in system size
  number_of_points = 25;
  left_bound = 0.65; right_bound = 0.95;
  temperatures = linspace(left_bound, right_bound, number_of_points);
  % temperatures = [0.8];
  % temperatures = [0.4];
  N_values = 10:5:100;
  max_truncation_error = 1e-5;

  sim = FixedTruncationErrorSimulation(temperatures, N_values, max_truncation_error, q).run();
  order_parameters = sim.compute('order_parameter');
  entropies = sim.compute('entropy');

  figure
  markerplot(N_values, entropies, '--', 'loglog')
  make_legend(temperatures, 'T')

  slopes = zeros(1, numel(temperatures))
  for t = 1:numel(temperatures)
    [slope, intercept] = logfit(N_values, entropies(t, :, :), 'logx', 'skipBegin', 9)
    slopes(t) = slope;
  end

  figure
  markerplot(temperatures, 6.*slopes, '--')
  % title('Varying exponent for $M(T, N) \propto N^{a(T)}$ in $q = 6$ clock model.')
  % xlabel('$T$')
  % ylabel('$a(T)$')


  % [slope, intercept] = logfit(corr_lengths(1, :, :), order_parameters(1, :, :), 'loglog', 'skipBegin', 4)

  % figure
  %
  % markerplot(corr_lengths', order_parameters', '--', 'loglog')
  % [slope, intersect] = logfit(chi_values, corr_lengths(1,:), 'loglog', 'skipBegin', 10)
  % [slope, intersect] = logfit(chi_values, corr_lengths(2,:), 'loglog', 'skipBegin', 10)
  % [slope, intersect] = logfit(correlation_lengths, corr_lengths, 'loglog', 'skipBegin', 10)

end
