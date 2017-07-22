function calculate_central_charge_q5
  % load sim object in variable 'sim'
  load('q5_chi10-100_tol25e-9.mat')
  sim_spaced = sim;

  load('q5_chi10-100_tol5e-8_zoom.mat')
  sim_zoom = sim;

  load('q5_chi10-100_tol5e-8_zoom2.mat')
  sim_zoom2 = sim;

  % Use only final (lowest) tolerance
  % sim.tolerances = sim.tolerances(end);
  sim_spaced.tolerances = sim_spaced.tolerances(end);
  sim_zoom.tolerances = sim_zoom.tolerances(end);
  sim_zoom2.tolerances = sim_zoom2.tolerances(end);


  temperatures = [sim_spaced.temperatures sim_zoom.temperatures sim_zoom2.temperatures];

  skip_begin = 2;

  entropies = cat(1, sim_spaced.compute('entropy'), sim_zoom.compute('entropy'), sim_zoom2.compute('entropy'));
  order_params = cat(1, sim_spaced.compute('order_parameter'), sim_zoom.compute('order_parameter'), ...
    sim_zoom2.compute('order_parameter'));

  % correlation_lengths = cat(1, sim_spaced.compute('correlation_length'), ...
  %   sim_zoom.compute('correlation_length'), sim_zoom2.compute('correlation_length'));

  % Select only temperature within bounds
  % left_bound = 0.88; right_bound = 0.98;
  % left_bound = 0.86; right_bound = 0.98;
  left_bound = 0.88; right_bound = 0.967;

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

  temperatures

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
