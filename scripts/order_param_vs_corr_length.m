function order_param_vs_corr_length
  beta = 1/8; nu = 1;
  z = 2.44591;
  temperature = Constants.T_crit;
  % chi_values = 32:100;
  chi_values = [4, 10, 20, 40, 60, 80, 100];
  tolerance = 1e-8;

  sim = FixedToleranceSimulation(temperature, chi_values, tolerance).run();
  order_parameters = sim.compute(OrderParameter);
  length_scales = calculate_length_scales(sim);
  % correlation_lengths = sim.compute(CorrelationLengthAfun)
  % save('order_param_strip_vs_corr_length.mat')
  % load('order_param_vs_corr_length.mat')

  figure
  hold on
  % markerplot(correlation_lengths .^ (-beta/nu), order_parameters, 'none', 'loglog');
  % [slope, intercept] = logfit(correlation_lengths, order_parameters, 'loglog', 'skipBegin', 3)
  % markerplot(x, y, 'none')

  % markerplot(chi_values, order_parameters .* correlation_lengths.^(beta/nu), '--')
  markerplot(chi_values, order_parameters .* length_scales.^(2.44591*beta/(nu)), '--')
  % xlabel('$\chi$')
  % ylabel('$m(\chi)\xi(\chi)^{\beta/\nu}$')
  title('$t = 0$')

  % P = polyfit(x, y, 1)
  % [slope, intercept, mse] = logfit(correlation_lengths .^ (-beta/nu), order_parameters, 'loglog')
end

function length_scales = calculate_length_scales(sim)
  energy_gaps = arrayfun(@(tensor) log(tensor.C(1, 1)/tensor.C(2, 2)), sim.tensors)
  length_scales = exp(1./energy_gaps);
end
