function order_param_vs_corr_length
  beta = 1/8; nu = 1;
  temperature = Constants.T_crit;
  % chi_values = 32:100;
  chi_values = [4, 10, 20, 40, 60, 80, 100];
  tolerance = 1e-8;

  sim = FixedToleranceSimulation(temperature, chi_values, tolerance).run();
  order_parameters = sim.compute(OrderParameter);
  % correlation_lengths = sim.compute(CorrelationLengthAfun);
  correlation_lengths = 2 .* [21.379621349095427  34.253462487137007  45.913582910903287 ...
    62.127387476946382 73.419480243418789  82.580197265074588  90.137360639728115] + 1
  % save('order_param_strip_vs_corr_length.mat')
  % load('order_param_vs_corr_length.mat')

  figure
  hold on
  % markerplot(correlation_lengths .^ (-beta/nu), order_parameters, 'none', 'loglog');
  x = (-beta/nu)*log(correlation_lengths);
  y = log(order_parameters);
  % [slope, intercept] = logfit(correlation_lengths, order_parameters, 'loglog', 'skipBegin', 3)
  % markerplot(x, y, 'none')

  % markerplot(chi_values, order_parameters .* correlation_lengths.^(beta/nu), '--')
  markerplot(chi_values, order_parameters .* correlation_lengths.^(-0.125), '--')
  % xlabel('$\chi$')
  % ylabel('$m(\chi)\xi(\chi)^{\beta/\nu}$')
  title('$t = 0$')

  % P = polyfit(x, y, 1)
  % [slope, intercept, mse] = logfit(correlation_lengths .^ (-beta/nu), order_parameters, 'loglog')
end
