function calculate_central_charge_q6
  % load sim object in variable 'sim'
  load('q6_chi10-80_tol1e-7.mat')
  sim_spaced = sim;

  load('q6_chi10-80_tol1e-7_zoom.mat')
  sim_zoom = sim;

  % Use only final (lowest) tolerance
  % sim.tolerances = sim.tolerances(end);
  sim_spaced.tolerances = sim_spaced.tolerances(end);
  sim_zoom.tolerances = sim_zoom.tolerances(end);

  temperatures = [sim_spaced.temperatures sim_zoom.temperatures];

  skip_begin = 0;

  entropies = cat(1, sim_spaced.compute('entropy'), sim_zoom.compute('entropy'));
  order_params = cat(1, sim_spaced.compute('order_parameter'), sim_zoom.compute('order_parameter'));

  % correlation_lengths = cat(1, sim_spaced.compute('correlation_length'), ...
  %   sim_zoom.compute('correlation_length'), sim_zoom2.compute('correlation_length'));

  % Select only temperature within bounds
  left_bound = 0.67; right_bound = 0.93;

  indices_to_include = temperatures >= left_bound & temperatures <= right_bound;
  temperatures = temperatures(indices_to_include);
  entropies = entropies(indices_to_include, :);
  order_params = order_params(indices_to_include, :);
  % correlation_lengths = correlation_lengths(indices_to_include, :);
  length_scales_from_entropy = 10.^(6.*entropies);

  % Fit
  mses = zeros(1, numel(temperatures));
  slopes = zeros(1, numel(temperatures));

  for t = 1:numel(temperatures)
    % if IsNear(temperatures(t), 0.88333, 1e-5)
      % figure
      % [slope, intercept, mse, r2, S] = logfit(correlation_lengths(t, :), entropies(t, :), 'logx', ...
      %   'skipBegin', skip_begin);
      % [slope, intercept, mse, r2, S] = logfit(sim.chi_values, entropies(t, :), 'logx', 'skipBegin', skip_begin);
      [slope, intercept, mse, r2, S] = logfit(length_scales_from_entropy(t, :), order_params(t, :), ...
        'loglog', 'skipBegin', skip_begin);
      title(['T = ' num2str(temperatures(t))])

      mses(t) = S.normr;
      % slopes(t) = 6 * slope;
      slopes(t) = -2*slope;
    % end
  end


  figure
  markerplot(temperatures, mses, '--', 'semilogy')
  title('mses')
  % figure
  % markerplot(temperatures, slopes, '--')
  % title('central charge')
  %
  % figure
  % markerplot(sim.temperatures, central_charges, '--')

end
