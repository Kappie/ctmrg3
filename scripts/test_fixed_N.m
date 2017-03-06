function test_fixed_N
  N_values = 50:50:200;
  chi_values = [10, 20];
  q = 4;
  temperature = Constants.T_crit/2;

  sim = FixedNSimulation(temperature, chi_values, N_values, q).run();
  truncation_errors = arrayfun(@ (s) s.truncation_error, sim.compute('truncation_error'))

  markerplot(N_values, truncation_errors, '--', 'semilogy')
  make_legend(chi_values, '\chi')


  % x = N_values;
  % y = order_parameters;
  % % y = a*x^b
  % model_name = 'power1'
  % fit_options = fitoptions(model_name, 'Lower', [0 -10], 'Upper', [Inf 0], ...
  %   'StartPoint', [1 -0.125], 'Exclude', x < 400 | x > 1400)
  % [fit_obj, goodness] = fit(x', y, model_name, fit_options)
  % plot(fit_obj, x, y)
  % % markerplot(x, y, '--')
  % set(gca, 'XScale', 'log');
  % set(gca, 'YScale', 'log');
end
