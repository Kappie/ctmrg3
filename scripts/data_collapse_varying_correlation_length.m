function data_collapse_varying_correlation_length
  q = 2;
  width = 0.01; number_of_points = 10;
  temperatures = linspace(Constants.T_crit_guess(q) - width, ...
    Constants.T_crit_guess(q) + width, number_of_points);
  chi_values = [4 8 12 16 20 24];
  tolerance = 1e-7;

  sim = FixedToleranceSimulation(temperatures, chi_values, tolerance, q).run();
  order_params = sim.compute('order_parameter');
  correlation_lengths = sim.compute('correlation_length');
  length_scales = calculate_correlation_lengths(Constants.T_crit_guess(q), chi_values, 1e-8, q, 'spin-up');

  do_data_collapse(temperatures, order_params, correlation_lengths, length_scales);
  xlabel('$t \xi(T_c, \chi)$')
  ylabel('$\xi(T, \chi)^{\beta/\nu}M(T, \chi)$')
  make_legend(chi_values, '\chi')
end

function do_data_collapse(temperatures, order_params, correlation_lengths, length_scales)
  T_crit = Constants.T_crit;
  beta = 1/8; nu = 1;
  reduced_temperatures = temperatures - T_crit;

  figure
  hold on
  for l = 1:numel(length_scales)
    x_values = zeros(1, numel(temperatures));
    scaling_function_values = zeros(1, numel(temperatures));

    for t = 1:numel(temperatures)
      x_values(t) = reduced_temperatures(t).*length_scales(l).^(1/nu);
      scaling_function_values(t) = order_params(t, l) .* correlation_lengths(t, l).^(beta/nu);
    end

    markerplot(x_values, scaling_function_values, 'None')
  end
  hold off
end
