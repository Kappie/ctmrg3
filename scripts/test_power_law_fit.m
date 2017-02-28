function test_power_law_fit
  prefactor = 8;
  kappa = -2;
  shift = 3;
  x = linspace(1, 10);
  y = prefactor*x.^kappa + shift;

  [fit_obj, goodness] = fit(x', y', 'power2')
  plot(fit_obj, x, y)
end
