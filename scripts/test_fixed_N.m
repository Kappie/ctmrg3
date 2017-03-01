function test_fixed_N
  N_values = 25:25:525;
  chi = 300;
  q = 4;
  temperature = Constants.T_crit/2;

  sim = FixedNSimulation(temperature, chi, N_values, q).run();

  order_parameters = sim.compute('order_parameter');
  % markerplot(N_values, order_parameters, '--', 'loglog')

  x = N_values;
  y = order_parameters;
  % y = a*x^b
  model_name = 'power1'
  fit_options = fitoptions(model_name, 'Lower', [0 -10], 'Upper', [Inf 0], ...
    'StartPoint', [1 -0.125], 'Exclude', x < 400 | x > 1000);
  [fit_obj, goodness] = fit(x', y, model_name, fit_options)
  plot(fit_obj, x, y)
  set(gca, 'XScale', 'log');
  set(gca, 'YScale', 'log');
end
