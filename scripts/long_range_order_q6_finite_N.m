function long_range_order_q6_finite_N
  q = 6;
  % In between two kosterlitz points: correlation length should grow as power law in system size
  number_of_points = 33;
  left_bound = 0.65; right_bound = 1.05;
  temperatures = linspace(left_bound, right_bound, number_of_points);
  % temperatures = [0.8];
  % temperatures = [0.4];
  N_values = 10:5:100;
  max_truncation_error = 1e-5;

  sim = FixedTruncationErrorSimulation(temperatures, N_values, max_truncation_error, q).run();
  order_parameters = sim.compute('order_parameter');
  entropies = sim.compute('entropy');

  slopes = zeros(1, numel(temperatures));
  mses = zeros(1, numel(temperatures));
  for t = 1:numel(temperatures)
    % figure
    % [slope, intercept, mse] = logfit(N_values, entropies(t, :, :), 'logx', 'skipBegin', 7)
    [slope, intercept, mse] = logfit(N_values, order_parameters(t, :, :), 'loglog', 'skipBegin', 7)
    title(['$T = ' num2str(temperatures(t)) '$'])
    slopes(t) = slope;
    mses(t) = mse;
  end

  mse_limit = 1e-9;
  indices_to_plot = mses < mse_limit;
  mses
  figure
  markerplot(temperatures(indices_to_plot), slopes(indices_to_plot), '--')
  hline(-0.125, '--')
  figure
  markerplot(temperatures, mses, '--', 'semilogy')
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
