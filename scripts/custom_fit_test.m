function custom_fit_test
  exp_func = @(a, b, x) a .* exp(x - b);
  default_options = fitoptions(fittype(exp_func));

  x = linspace(1, 2);
  y = 3.*exp(x - 1);
  fit_options = fitoptions(default_options, 'Lower', [0 0], 'Upper', [10 10], 'Startpoint', [3 1])
  [fit_obj, goodness] = fit(x', y', exp_func, fit_options)
  plot(fit_obj, x, y)
end
