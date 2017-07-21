function calculate_central_charge_q5
  % load sim object in variable 'sim'
  load('q5_chi10-100_tol25e-9.mat')
  sim_spaced = sim;

  load('q5_chi10-100_tol5e-8_zoom.mat')
  sim_zoom = sim;

  % Use only final (lowest) tolerance
  sim.tolerances = sim.tolerances(end);
  sim_spaced.tolerances = sim_spaced.tolerances(end);
  sim_zoom.tolerances = sim_zoom.tolerances(end);


  temperatures = [sim_spaced.temperatures sim_zoom.temperatures];

  skip_begin = 2;

  entropies = cat(1, sim_spaced.compute('entropy'), sim_zoom.compute('entropy'));
  order_params = cat(1, sim_spaced.compute('order_parameter'), sim_zoom.compute('order_parameter'));
  length_scales_from_entropy = 10.^(6.*entropies);
  % correlation_lengths = sim.compute('correlation_length');

  mses = zeros(1, numel(temperatures));
  slopes = zeros(1, numel(temperatures));

  for t = 1:numel(temperatures)
    % [slope, intercept, mse] = logfit(correlation_lengths(t, :), entropies(t, :), 'logx', 'skipBegin', skip_begin);
    % [slope, intercept, mse, r2, S] = logfit(sim.chi_values, entropies(t, :), 'logx', 'skipBegin', skip_begin);
    [slope, intercept, mse, r2, S] = logfit(length_scales_from_entropy(t, :), order_params(t, :), ...
      'logx', 'skipBegin', skip_begin);
    title(['T = ' num2str(temperatures(t))])

    mses(t) = S.normr;
    % slopes(t) = 6 * slope;
    slopes(t) = -2*slope;
  end

  figure
  markerplot(temperatures, mses, '--', 'semilogy')
  figure
  markerplot(temperatures, slopes, '--')
  %
  % figure
  % markerplot(sim.temperatures, central_charges, '--')

end
