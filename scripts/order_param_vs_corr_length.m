function order_param_vs_corr_length
  beta = 1/8; nu = 1;
  temperature = Constants.T_crit;
  chi_values = 32:100;
  tolerance = 1e-8;

  sim = FixedToleranceSimulation(temperature, chi_values, tolerance).run();
  order_parameters = sim.compute(OrderParameterStrip);
  correlation_lengths = sim.compute(CorrelationLengthAfun);
  save('order_param_strip_vs_corr_length.mat')
  % load('order_param_vs_corr_length.mat')

  figure
  hold on
  % markerplot(correlation_lengths .^ (-beta/nu), order_parameters, 'none', 'loglog');
  x = (-beta/nu)*log(correlation_lengths);
  y = log(order_parameters);
  % markerplot(x, y, 'none')

  markerplot(chi_values, order_parameters .* correlation_lengths.^(beta/nu), '--')
  xlabel('$\chi$')
  ylabel('$m(\chi)\xi(\chi)^{\beta/\nu}$')
  title('$t = 0$')

  % P = polyfit(x, y, 1)
  % [slope, intercept, mse] = logfit(correlation_lengths .^ (-beta/nu), order_parameters, 'loglog')
end
