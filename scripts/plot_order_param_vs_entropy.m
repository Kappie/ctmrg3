function plot_order_param_vs_entropy
  q = 2;
  temperature = Constants.T_crit;
  chi_values = 10:1:66;

  % chi_values = [10, 14, 19, 25, 33, 43, 55, 70, 88, 110];
  tolerance = 1e-9;
  skip_begin = 0;

  sim = FixedToleranceSimulation(temperature, chi_values, tolerance, q).run();
  order_params = sim.compute('order_parameter');
  entropies = sim.compute('entropy');
  % corr_lengths = sim.compute('correlation_length');

  central_charge = 0.5;
  length_scales = 10.^((6/central_charge)*entropies);

  figure
  [slope, intercept, mse] = logfit(length_scales, order_params, 'loglog', 'skipBegin', skip_begin)
  xlabel('$S$')
  ylabel('M')
  % figure
  % [slope, intercept, mse] = logfit(corr_lengths, order_params, 'loglog', 'skipBegin', skip_begin)

  % figure
  % [slope, intercept, mse] = logfit(chi_values, order_params, 'loglog', 'skipBegin', skip_begin)
end
